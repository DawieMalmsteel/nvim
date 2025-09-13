local map = vim.keymap.set

-- Wraptext
map('n', '<leader>uw', function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = 'Toggle Wrap Text' })

-- Change color scheme
map('n', '<leader>uc', '<CMD>lua Snacks.picker.colorschemes()<CR>', { desc = 'Change theme' })

-- Open mini starter
-- map('n', '<leader>uo', function()
--   local mini_starter = require 'mini.starter'
--   mini_starter.open()
-- end, { desc = 'Open MiniStarter' })

-- Open Mini map
map('n', '<leader>um', function()
  local mini_map = require 'mini.map'
  mini_map.toggle()
end, { desc = 'Toggle Mini Map' })

-- Toggle Mini map focus
map('n', '<leader>uM', function()
  local mini_map = require 'mini.map'
  mini_map.toggle_focus()
end, { desc = 'Toggle Mini Map Focus' })
