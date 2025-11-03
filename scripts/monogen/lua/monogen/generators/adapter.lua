local utils = require("monogen.utils")
local config = require("monogen.config")

local M = {}

-- Port 인터페이스에서 메서드 추출
local function extract_methods(port_content, domain_cap)
  -- export interface PostPort { ... } 패턴 매칭
  local pattern = "export%s+interface%s+" .. domain_cap .. "Port%s*(%b{})"
  local interface_block = port_content:match(pattern)
  
  if not interface_block then
    return nil, "Could not find " .. domain_cap .. "Port interface in file"
  end
  
  -- 중괄호 제거
  local body = interface_block:sub(2, -2)
  
  local methods = {}
  
  -- 줄 단위로 분리하여 메서드 찾기
  for line in body:gmatch("[^\r\n]+") do
    line = vim.trim(line)
    
    -- 주석이나 빈 줄 무시
    if line ~= "" and not line:match("^%s*$") and not line:match("^%s*%*") and not line:match("^%s*//") then
      -- async 키워드 제거
      local cleaned = line:gsub("^%s*async%s+", "")
      
      -- 메서드 파싱: methodName(param1: Type1, param2: Type2): ReturnType
      local method_name, params, return_type = cleaned:match("^([%w_]+)%s*%((.-)%)%s*:%s*(.+)$")
      
      if method_name then
        -- 반환 타입 정리 (세미콜론 제거)
        return_type = vim.trim(return_type):gsub(";$", "")
        
        -- 반환 타입에서 Promise<T> 추출
        local inner_type = return_type:match("Promise%s*<%s*(.-)%s*>")
        
        -- 기본 반환값 결정
        local return_statement = ""
        if inner_type then
          if inner_type == "void" or inner_type == "" then
            return_statement = ""
          elseif inner_type:match("undefined") or inner_type:match("|%s*undefined") then
            return_statement = "return undefined;"
          elseif inner_type:match("%[%]$") or inner_type:match("^%w+%[%]") then
            return_statement = "return [];"
          else
            return_statement = "return undefined as any;"
          end
        else
          return_statement = "return undefined as any;"
        end
        
        -- 메서드 구현 생성
        local method_impl = string.format(
          "  async %s(%s): %s {\n    // TODO: implement %s\n%s%s\n  }",
          method_name,
          params,
          return_type,
          method_name,
          return_statement ~= "" and "    " or "",
          return_statement
        )
        
        table.insert(methods, method_impl)
      end
    end
  end
  
  if #methods == 0 then
    return nil, "No methods found in " .. domain_cap .. "Port interface"
  end
  
  return methods, nil
end

-- Adapter 코드 생성
local function generate_adapter_code(domain, domain_cap, adapter_cap, methods)
  local import_statement = string.format(
    'import { %s, %sPort } from "@domains/%s/%sPort";',
    domain_cap,
    domain_cap,
    domain,
    domain_cap
  )
  
  local class_declaration = string.format(
    "export class %sAdapter%s implements %sPort {",
    domain_cap,
    adapter_cap,
    domain_cap
  )
  
  local methods_code = table.concat(methods, "\n\n")
  
  local full_code = string.format(
    "%s\n\n%s\n%s\n}\n",
    import_statement,
    class_declaration,
    methods_code
  )
  
  return full_code
end

-- 메인 생성 함수
function M.generate()
  -- 1. 현재 경로 파싱
  local path_info = utils.parse_current_path()
  if not path_info then
    vim.notify("❌ Failed to parse current path", vim.log.levels.ERROR)
    return
  end
  
  local domain = path_info.domain
  local parent_folder = path_info.parent
  
  -- 2. domains 폴더 체크
  if parent_folder ~= "domains" then
    vim.notify(
      "❌ This command must be run from /packages/domains/<domain> folder",
      vim.log.levels.ERROR
    )
    return
  end
  
  -- 3. Adapter 타입 입력받기
  vim.ui.input({ prompt = "Adapter type (e.g., Memory, Api): " }, function(adapter_type)
    if not adapter_type or adapter_type == "" then
      vim.notify("❌ Adapter type is required", vim.log.levels.ERROR)
      return
    end
    
    local domain_cap = utils.capitalize(domain)
    local adapter_cap = utils.capitalize(adapter_type)
    
    -- 4. Port 파일 경로 생성
    local port_file = string.format("%s/%sPort.ts", path_info.full_path, domain_cap)
    
    -- 5. Port 파일 존재 확인
    if not utils.file_exists(port_file) then
      vim.notify(
        string.format("❌ Port file not found: %s", port_file),
        vim.log.levels.ERROR
      )
      return
    end
    
    -- 6. Port 파일 읽기
    local port_content = utils.read_file(port_file)
    if not port_content then
      vim.notify("❌ Failed to read Port file", vim.log.levels.ERROR)
      return
    end
    
    -- 7. 메서드 추출
    local methods, err = extract_methods(port_content, domain_cap)
    if err then
      vim.notify(
        string.format("❌ %s\n\nPort file path: %s", err, port_file),
        vim.log.levels.ERROR
      )
      return
    end
     -- 8. Adapter 코드 생성
    local adapter_code = generate_adapter_code(domain, domain_cap, adapter_cap, methods)
    
    -- 9. 출력 경로 설정
    local adapter_dir = string.format(
      "%s/../../adapters/%s",
      path_info.full_path,
      domain
    )
    
    local file_name = string.format("%sAdapter%s.ts", domain_cap, adapter_cap)
    local target_path = adapter_dir .. "/" .. file_name
    
    -- 경로 정규화
    target_path = vim.fn.fnamemodify(target_path, ":p")
    
    -- 11. 파일 쓰기
    if utils.write_file(target_path, adapter_code) then
      vim.notify(
        string.format("✅ Successfully created: %s", target_path),
        vim.log.levels.INFO
      )
      
      -- 12. 파일 열기 여부 선택
      vim.ui.select(
        { "Yes", "No" },
        { prompt = "Open the generated file?" },
        function(choice)
          if choice == "Yes" then
            vim.cmd("edit " .. vim.fn.fnameescape(target_path))
          end
        end
      )
    else
      vim.notify("❌ Failed to write adapter file", vim.log.levels.ERROR)
    end
  end)
end

return M
