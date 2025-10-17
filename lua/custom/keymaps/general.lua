local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<CR>')

map({ 'n', 'x' }, 'j', 'gj', { noremap = true, silent = true })
map({ 'n', 'x' }, 'k', 'gk', { noremap = true, silent = true })

-- Chế độ normal (Normal mode)
map('n', ';', ':', { desc = 'CMD enter command mode' })
-- map('i', 'kj', '<ESC>')

-- Save file
map({ 'n', 'i', 'x' }, '<C-s>', '<Esc>:w<CR>', { noremap = true, silent = true, desc = 'Save file' })

-- Tăng tốc độ cuộn của Ctrl-E và Ctrl-Y
map('n', '<C-e>', '3<C-e>', { noremap = true, silent = true })
map('n', '<C-y>', '3<C-y>', { noremap = true, silent = true })

-- Xóa dòng nhưng không thay đổi register
map('v', 'c', [["_c]])
map('n', 'c', [["_c]])
map('n', 'x', [["_x]])
map('n', '<S-X>', [["_dd]])
map('v', 'x', [["_x]])

map('n', 'H', '<CMD>execute "silent! bprevious " . v:count1<CR>', { desc = 'Previous Buffer (with count)' })
map('n', 'L', '<CMD>execute "silent! bnext " . v:count1<CR>', { desc = 'Next Buffer (with count)' })

map('v', 'J', ":m'>+1<cr>gv=gv")
map('v', 'K', ":m'<-2<cr>gv=gv")

map({ 'n', 'x' }, 'gi', '^')
map({ 'n', 'x' }, 'ga', 'g_')
map({ 'n', 'x' }, '<S-tab>', '%')

map('n', "y'", "yi'", { noremap = true })
map('n', "v'", "vi'", { noremap = true })

map('n', 'y"', 'yi"', { noremap = true })
map('n', 'v"', 'vi"', { noremap = true })

map('n', '<leader><leader>', function()
  local mini_pick = require 'mini.pick'
  local file = vim.api.nvim_buf_get_name(0)
  local dir = (file ~= '' and vim.fn.filereadable(file) == 1) and vim.fn.fnamemodify(file, ':h') or vim.fn.getcwd()
  mini_pick.builtin.files(nil, { source = { cwd = dir } })
end, { desc = 'Search Files in cwd' })
