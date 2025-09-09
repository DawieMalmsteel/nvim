local core = require 'custom.keymaps.core'
local map = core.map

-- Cơ bản / di chuyển / chỉnh sửa
map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('n', 'j', 'gj', { silent = true })
map('n', 'k', 'gk', { silent = true })

-- (Điều hướng cửa sổ đã chuyển sang extras.lua để tránh trùng)

map('n', ';', ':', { desc = 'CMD mode' })
map('i', 'kj', '<ESC>', { desc = 'Thoát insert' })

-- Lưu file
map({ 'n', 'i', 'x' }, '<C-s>', '<Esc>:w<CR>', { desc = 'Save file' })

-- Xoá CR rác
map('n', '<C-\\>', ':%s/\\r//g<CR>', { desc = 'Remove ^M' })

-- Cuộn nhanh
map('n', '<C-e>', '3<C-e>')
map('n', '<C-y>', '3<C-y>')

-- Giữ register khi change / delete
map('v', 'c', [["_c]])
map('n', 'c', [["_c]])
map('n', 'x', [["_x]])
map('n', '<S-X>', [["_dd]])
map('v', 'x', [["_x]])

-- Dán mà không ghi đè
map('x', '<leader>P', [["_dP]], { desc = 'Paste giữ register' })

-- Di chuyển dòng trong visual
map('v', 'J', ":m'>+1<CR>gv=gv")
map('v', 'K', ":m'<-2<CR>gv=gv")

-- Đi đầu dòng / cuối từ đã trim
map({ 'n', 'x' }, 'gi', '^')
map({ 'n', 'x' }, 'ga', 'g_')
map({ 'n', 'x' }, '<Tab>', '%')

-- Yank / select trong cặp ký tự
map('n', "y'", "yi'")
map('n', "v'", "vi'")
map('n', 'y"', 'yi"')
map('n', 'v"', 'vi"')

-- Tạo file mới nhanh
map('n', '<leader><Tab>', ':e <Space>', { desc = '+New file' })
