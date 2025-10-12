local map = vim.keymap.set

map('n', '<leader>z', function()
  local Snacks = require 'snacks'
  Snacks.zen()
end, { desc = 'Toggle Zen Mode' })

map('n', '<leader>Z', function()
  local Snacks = require 'snacks'
  Snacks.zen.zoom()
end, { desc = 'Toggle Zoom' })
