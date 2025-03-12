vim.uv = vim.uv or vim.loop

local M = {}

---@param opts? LazyChadConfig
function M.setup(opts)
  require("lazychad.config").setup(opts)
end

return M
