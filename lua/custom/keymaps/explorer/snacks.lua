local map = vim.keymap.set

-- Explore
map('n', '<leader>E', function()
  local Snacks = require 'snacks'
  Snacks.explorer()
end, { desc = 'Explorer Snacks (cwd)' })
map('n', '<leader>o', '<CMD>Pick oldfiles<CR>', { desc = 'Open oldfiles' })
