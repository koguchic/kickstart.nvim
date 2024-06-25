-- ~/.config/nvim/lua/run_python_file.lua
local function run_python_file()
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  vim.api.nvim_command 'write'
  vim.api.nvim_command 'vsplit'
  vim.api.nvim_command('terminal python "' .. bufname .. '"')
  vim.api.nvim_command 'startinsert'
end

return {
  run_python_file = run_python_file,
}
