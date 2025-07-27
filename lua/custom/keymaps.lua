local map = vim.keymap.set
local Snacks = require 'snacks'

-- Chế độ normal (Normal mode)
map('n', ';', ':', { desc = 'CMD enter command mode' })
map('i', 'kj', '<ESC>')

-- Save file
map({ 'n', 'i' }, '<C-s>', '<Esc>:w<CR>', { noremap = true, silent = true, desc = 'Save file' })

-- Sql query
-- map("n", "<leader>r", ":'<,'>DB", { noremap = true, silent = true })

-- diagnostics list
map('n', '<leader>D', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Explore
map('n', '<leader>eo', '<CMD>Oil<CR>', { noremap = true, silent = true, desc = 'Open parent directory' })
map('n', '<leader>ee', function()
  Snacks.explorer()
end, { desc = 'Explorer Snacks (cwd)' })

-- add keymap to remove trailing whitespace
map('n', '<C-\\>', ':%s/\\r//g<CR>', { noremap = true, silent = true })

-- Terminal
map('t', '<ESC><ESC>', '<C-\\><C-n>', { noremap = true })

-- paste nhưng không thay đổi register
map('x', '<leader>P', [["_dP]])

-- Tăng tốc độ cuộn của Ctrl-E và Ctrl-Y
map('n', '<C-e>', '3<C-e>', { noremap = true, silent = true })
map('n', '<C-y>', '3<C-y>', { noremap = true, silent = true })

-- Xóa dòng nhưng không thay đổi register
map('v', 'c', [["_c]])
map('n', 'c', [["_c]])
map('n', 'x', [["_x]])
map('n', '<S-X>', [["_dd]])
map('v', 'x', [["_x]])

-- Snacks git keymaps
map('n', '<leader>gl', function()
  Snacks.lazygit.log()
end, { desc = 'Lazygit Logs' })

map('n', '<leader>gg', function()
  Snacks.lazygit()
end, { desc = 'Lazygit Logs' })

map('n', '<leader>gbr', function()
  Snacks.picker.git_branches { layout = 'select' }
end, { desc = 'Pick and Switch Git Branches' })

map('n', '<leader>gs', function()
  Snacks.picker.git_status()
end, { desc = 'Git Status' })

map('n', '<leader>gS', function()
  Snacks.picker.git_stash()
end, { desc = 'Git Stash' })
