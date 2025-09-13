local map = vim.keymap.set

-- Snacks picker
map('n', '<leader>fb', function()
  local picker = require 'snacks.picker'
  picker.buffers()
end, { desc = 'Buffers' })

map('n', '<leader>fr', function()
  local picker = require 'snacks.picker'
  picker.recent { live = true }
end, { desc = 'Recent Files' })

-- custom grep picker:
map('n', '<leader>fg', function()
  local picker = require 'snacks.picker'
  picker.grep { prompt = 'Search> ', live = true }
end, { desc = 'Live grep' })

map('n', '<leader>fF', function()
  local Snacks = require 'snacks'
  Snacks.picker.buffers { hidden = true, nofile = true }
end, { desc = 'Files buffers in Snacks (all)' })
