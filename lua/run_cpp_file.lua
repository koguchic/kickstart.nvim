local function run_cpp_file()
  -- Get current buffer and file name
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)

  -- Get file name without extension and directory
  local file_no_ext = vim.fn.fnamemodify(bufname, ':t:r') -- Extract file name without extension
  local dir = vim.fn.fnamemodify(bufname, ':p:h') -- Get the directory of the current file

  -- Construct paths
  local executable_path = dir .. '/' .. file_no_ext
  local input_file = dir .. '/input.txt' -- Assume input.txt is in the same directory

  -- Write the file
  vim.api.nvim_command 'write'

  -- Open a vertical split and run the compile + execute command
  vim.api.nvim_command 'vsplit'

  -- Compile, execute, and remove the executable
  local compile_and_run_command =
    string.format('g++-14 -std=c++17 -o "%s" "%s" && "%s" < "%s" && rm "%s"', executable_path, bufname, executable_path, input_file, executable_path)
  vim.api.nvim_command('terminal ' .. compile_and_run_command)

  -- Focus on terminal
  vim.api.nvim_command 'startinsert'
end

return {
  run_cpp_file = run_cpp_file,
}
