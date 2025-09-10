local map = vim.keymap.set

-- Keybinds to make split navigation easier.
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Resize window
map('n', '<C-Up>', ':resize +1<CR>', { desc = 'Tăng chiều cao cửa sổ' })
map('n', '<C-Down>', ':resize -1<CR>', { desc = 'Giảm chiều cao cửa sổ' })
map('n', '<C-Right>', ':vertical resize +1<CR>', { desc = 'Tăng chiều rộng cửa sổ' })
map('n', '<C-Left>', ':vertical resize -1<CR>', { desc = 'Giảm chiều rộng cửa sổ' })
