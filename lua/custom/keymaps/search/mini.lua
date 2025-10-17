local map = vim.keymap.set

map('n', '<leader>sh', '<CMD>Pick help<CR>', { desc = 'Search [H]elp' })

map('n', '<leader>sG', function()
  vim.cmd('cd ' .. vim.env.PWD or vim.fn.getcwd())
  vim.cmd 'Pick grep_live'
end, { desc = 'Search by Grep Global' })

map('n', '<leader>sg', function()
  local mini_pick = require 'mini.pick'
  local file = vim.api.nvim_buf_get_name(0)
  local dir = (file ~= '' and vim.fn.filereadable(file) == 1) and vim.fn.fnamemodify(file, ':h') or vim.fn.getcwd()
  mini_pick.builtin.grep_live(nil, { source = { cwd = dir } })
end, { desc = 'Search by Grep in file root or cwd' })

map('n', '<leader>sr', '<CMD>Pick resume<CR>', { desc = 'Search Resume' })

map('n', '<leader>sw', function()
  local mini_pick = require 'mini.pick'
  mini_pick.builtin.grep { pattern = vim.fn.expand '<cword>' }
end, { desc = 'Search current Word' })
