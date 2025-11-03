local M = {}

-- 대문자화
function M.capitalize(str)
  return str:sub(1, 1):upper() .. str:sub(2)
end

-- 현재 디렉토리 경로 파싱
function M.parse_current_path()
  local cwd = vim.fn.getcwd()
  local parts = vim.split(cwd, "/")
  
  return {
    domain = parts[#parts],
    parent = parts[#parts - 1],
    full_path = cwd,
  }
end

-- 파일 존재 확인
function M.file_exists(path)
  return vim.fn.filereadable(path) == 1
end

-- 디렉토리 생성
function M.ensure_dir(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

-- 파일 읽기
function M.read_file(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end
  local content = file:read("*all")
  file:close()
  return content
end

-- 파일 쓰기
function M.write_file(path, content)
  local file = io.open(path, "w")
  if not file then
    return false
  end
  file:write(content)
  file:close()
  return true
end

return M
