local map = vim.keymap.set

map('n', '<leader>Z', function()
  local Snacks = require 'snacks'
  Snacks.zen()
end, { desc = 'Toggle Zen' })
