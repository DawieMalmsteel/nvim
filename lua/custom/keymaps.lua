local map = vim.keymap.set

-- Chế độ normal (Normal mode)
map('n', ';', ':', { desc = 'CMD enter command mode' })
map('i', 'kj', '<ESC>')

-- Sql query
-- map("n", "<leader>r", ":'<,'>DB", { noremap = true, silent = true })

-- diagnostics list
map('n', '<leader>D', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Oil
map('n', '<leader>o', '<CMD>Oil<CR>', { noremap = true, silent = true, desc = 'Open parent directory' })

-- --bring ctrl i back
-- map('n', '<Tab>', '<C-i>', { noremap = true, silent = true })

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

-- git keymaps
map('n', '<leader>gl', function()
  require('snacks').lazygit.log()
end, { desc = 'Lazygit Logs' })

map('n', '<leader>gg', function()
  require('snacks').lazygit()
end, { desc = 'Lazygit Logs' })

map('n', '<leader>gbr', function()
  require('snacks').picker.git_branches { layout = 'select' }
end, { desc = 'Pick and Switch Git Branches' })

-- Snacks
map('n', '<leader>e', function()
  require('snacks').explorer()
end, { desc = 'Explorer Snacks (cwd)' })

map({ 'n', 'i' }, '<C-s>', '<Esc>:w<CR>', { noremap = true, silent = true, desc = 'Save file' })
