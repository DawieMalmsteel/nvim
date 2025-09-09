local core = require 'custom.keymaps.core'
local map = core.map

-- Mason
map('n', '<leader>cm', '<CMD>Mason<CR>', { desc = 'Mason' })

-- DB UI
map('n', '<leader>D', '<CMD>DBUIToggle<CR>', { desc = 'Toggle DB UI' })

-- Thay đổi kích thước cửa sổ
map('n', '<C-Up>', ':resize +1<CR>', { desc = 'Resize + height' })
map('n', '<C-Down>', ':resize -1<CR>', { desc = 'Resize - height' })
map('n', '<C-Right>', ':vertical resize +1<CR>', { desc = 'Resize + width' })
map('n', '<C-Left>', ':vertical resize -1<CR>', { desc = 'Resize - width' })
