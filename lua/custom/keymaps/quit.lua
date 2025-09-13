local map = vim.keymap.set

-- Quit
map('n', '<leader>qq', '<CMD>qa<CR>', { desc = 'quit all' })

map('n', '<leader>qQ', '<CMD>qa!<CR>', { desc = 'quit all !' })

map('n', '<leader>qb', function()
  local Snacks = require 'snacks'
  Snacks.bufdelete()
end, { desc = 'Delete Buffer' })

map('n', '<leader>qB', '<CMD>bw<CR>', { desc = 'Quit Buffer and windows' })
