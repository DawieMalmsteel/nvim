local map = vim.keymap.set

map('n', '<leader>ff', function()
  vim.cmd('cd ' .. vim.env.PWD or vim.fn.getcwd())
  vim.cmd 'Pick files'
end, { desc = 'Find Files' })

map('n', '<leader>fm', function()
  local mini_files = require 'mini.files'
  mini_files.open(vim.uv.cwd(), true)
end, { desc = 'Open mini.files (cwd)' })

map(
  'n',
  '<leader>fC',
  ":lua require('mini.pick').builtin.files(nil, { source = { cwd = vim.fn.stdpath 'config' } })<CR>",
  { desc = 'Open mini.files (nvim config)' }
)

map(
  'n',
  '<leader>fc',
  ":lua require('mini.pick').builtin.files(nil, { source = { cwd = vim.fn.stdpath 'config' } })<CR>",
  { desc = 'Open mini.picker (nvim config)' }
)

map('n', '<leader>f"', '<CMD>Pick registers<CR>', { desc = 'Open register' })

map('n', "<leader>f'", '<CMD>Pick marks<CR>', { desc = 'Open marks' })

map('n', '<leader>f/', '<Cmd>Pick history scope="/"<CR>', { desc = 'Search history (/)' })
map('n', '<leader>f:', '<Cmd>Pick history scope=":"<CR>', { desc = 'Search history (:)' })
map('n', '<leader>f;', '<Cmd>Pick history scope=":"<CR>', { desc = 'Search history (:)' })
