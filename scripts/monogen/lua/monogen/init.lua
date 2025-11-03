local M = {}

M.config = require("monogen.config")

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  
  -- 명령어 등록
  vim.api.nvim_create_user_command("MonogenAdapter", function()
    require("monogen.generators.adapter").generate()
  end, { desc = "Generate adapter from Port interface" })
  
  -- 나중에 추가할 명령어들
  -- vim.api.nvim_create_user_command("MonogenService", function()
  --   require("monogen.generators.service").generate()
  -- end, { desc = "Generate service" })
end

return M
