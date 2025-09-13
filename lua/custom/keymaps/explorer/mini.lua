local map = vim.keymap.set

-- Mini Files
map('n', '<leader>e', function()
  local mini_files = require 'mini.files'
  local current_file = vim.api.nvim_buf_get_name(0)
  -- Check for special buffers first - only check specific known protocols
  if current_file == '' or current_file:match '^ministarter://' or current_file:match '^oil://' or vim.fn.filereadable(current_file) ~= 1 then
    mini_files.open(vim.fn.getcwd(), true)
  else
    mini_files.open(current_file, true)
  end
end, { desc = 'Minifile cwd' })
