local map = vim.keymap.set

-- map('n', '<leader>z', function()
--   local Snacks = require 'snacks'
--   Snacks.zen()
-- end, { desc = 'Toggle Zen Mode' })

map('n', '<leader>zz', function()
  local Mini = require 'mini.misc'
  Mini.zoom()
end, { desc = 'Toggle Zoom Mode' })

map('n', '<leader>zr', function()
  local Mini = require 'mini.misc'
  Mini.resize_window()
end, { desc = 'Resize window' })

map('n', '<leader>Z', function()
  local Snacks = require 'snacks'
  Snacks.zen.zoom()
end, { desc = 'Toggle Zoom' })
