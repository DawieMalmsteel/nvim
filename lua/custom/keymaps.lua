local map = vim.keymap.set
local Snacks = require 'snacks'
local picker = Snacks.picker
local mini_files = require 'mini.files'
local mini_pick = require 'mini.pick'

-- Decriptions for keymaps
map({ 'n', 'v' }, '<leader>c', '', { desc = '+code' })
map({ 'n', 'v' }, '<leader>a', '', { desc = '+ai' })
map({ 'n', 'v' }, '<leader>cp', '', { desc = '+copilot' })
map({ 'n', 'v' }, '<leader>f', '', { desc = '+find' })
map({ 'n', 'v' }, '<leader>g', '', { desc = '+git' })
map({ 'n', 'v' }, '<leader>u', '', { desc = '+ui' })
map({ 'n', 'v' }, '<leader>q', '', { desc = '+quit' })
map({ 'n', 'v' }, 'gr', '', { desc = '+LSP' })

-- Chế độ normal (Normal mode)
map('n', ';', ':', { desc = 'CMD enter command mode' })
map('i', 'kj', '<ESC>')

-- Save file
map({ 'n', 'i' }, '<C-s>', '<Esc>:w<CR>', { noremap = true, silent = true, desc = 'Save file' })

-- Sql query
-- map("n", "<leader>r", ":'<,'>DB", { noremap = true, silent = true })

-- Explore
-- map('n', '<leader>E', '<CMD>Oil<CR>', { noremap = true, silent = true, desc = 'Open Oil (cwd)' })
map('n', '<leader>e', function()
  Snacks.explorer()
end, { desc = 'Explorer Snacks (cwd)' })
map('n', '<leader>o', '<CMD>Pick oldfiles<CR>', { desc = 'Open oldfiles' })

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
end, { desc = 'Lazygit' })

map('n', '<leader>gB', function()
  Snacks.picker.git_branches { layout = 'select' }
end, { desc = 'Pick and Change Git Branches' })

map('n', '<leader>gs', function()
  Snacks.picker.git_status()
end, { desc = 'Git Status' })

map('n', '<leader>gS', function()
  Snacks.picker.git_stash()
end, { desc = 'Git Stash' })

-- Quit
map('n', '<leader>qq', '<CMD>qa<CR>', { desc = 'quit all' })
map('n', '<leader>q<ESC>', '<CMD>qa!<CR>', { desc = 'quit all !' })
map('n', '<leader>qb', '<CMD>bd<CR>', { desc = 'Quit Buffer (Keep Window)' })
map('n', '<leader>qB', '<CMD>bw<CR>', { desc = 'Quit Buffer and windows' })

-- Window management
map('n', '<leader>-', '<CMD>split<CR>', { desc = 'Split window below' })
map('n', '<leader>_', '<CMD>split<CR>', { desc = 'Split window above' })
map('n', '<leader>\\', '<CMD>vsplit<CR>', { desc = 'Split window right' })
map('n', '<leader>?', '<CMD>vsplit<CR>', { desc = 'Split window left' })
map('n', '<leader>qd', '<CMD>close<CR>', { desc = 'Close Window (Keep Buffer)' })

-- Resize window
map('n', '<C-Down>', ':resize +1<CR>', { desc = 'Tăng chiều cao cửa sổ' })
map('n', '<C-Up>', ':resize -1<CR>', { desc = 'Giảm chiều cao cửa sổ' })
map('n', '<C-Left>', ':vertical resize +1<CR>', { desc = 'Tăng chiều rộng cửa sổ' })
map('n', '<C-Right>', ':vertical resize -1<CR>', { desc = 'Giảm chiều rộng cửa sổ' })

-- Wraptext
map('n', '<leader>uw', function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = 'Toggle Wrap Text' })

-- Change color scheme
map('n', '<leader>uc', '<CMD>Pick colorschemes<CR>', { desc = 'Change theme' })

-- Switch buffer
map('n', '<Tab>', '<CMD>bnext<CR>', { desc = 'Next Buffer' })
map('n', '<S-Tab>', '<CMD>bprevious<CR>', { desc = 'Previous Buffer' })

-- Snacks picker
map('n', '<leader>fb', function()
  picker.buffers()
end, { desc = 'Buffers' })

map('n', '<leader>ff', function()
  picker.files()
end, { desc = 'Find Files' })

map('n', '<leader>fr', function()
  picker.recent { live = true }
end, { desc = 'Recent Files' })

-- GIT
map('n', '<leader>gb', function()
  picker.git_branches()
end, { desc = 'Git Branches' })

map('n', '<leader>gL', function()
  picker.git_log_line()
end, { desc = 'Git Log Line' })

map('n', '<leader>gf', '<CMD>Pick git_files<CR>', { desc = 'Open git files' })
map('n', '<leader>gc', '<CMD>Pick git_commits<CR>', { desc = 'Open git commits' })
map('n', '<leader>go', function()
  require('mini.diff').toggle_overlay(0)
end, { desc = 'Toggle mini.diff overlay' })

map('n', '<leader>;', function()
  picker.command_history()
end, { desc = 'Command History' })

map('n', '<leader>n', function()
  picker.notifications()
end, { desc = 'Notification History' })

-- custom grep picker:
map('n', '<leader>fg', function()
  picker.grep { prompt = 'Search> ', live = true }
end, { desc = 'Live grep' })

-- Di chuyển diagnostic: dùng jump với float
map('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous diagnostic' })

map('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next diagnostic' })

-- Hiển thị diagnostic dưới con trỏ
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })

-- Mở diagnostics ra quickfix list
map('n', '<leader>cq', vim.diagnostic.setqflist, { desc = 'Diagnostics → Quickfix' })

-- Diagnostic mức độ error tiếp theo
map('n', ']e', function()
  vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR, float = true }
end, { desc = 'Next Error' })

-- Diagnostic mức độ error trước đó
map('n', '[e', function()
  vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR, float = true }
end, { desc = 'Prev Error' })

-- Diagnostic mức độ warning tiếp theo
map('n', ']w', function()
  vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.WARN, float = true }
end, { desc = 'Next Warning' })

-- Diagnostic mức độ warning trước đó
map('n', '[w', function()
  vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.WARN, float = true }
end, { desc = 'Prev Warning' })

-- Mason
map('n', '<leader>cm', '<CMD>Mason<CR>', { desc = 'Mason' })

-- Mini Files
map('n', '<leader>fm', function()
  mini_files.open(vim.api.nvim_buf_get_name(0), true)
end, { desc = 'Open mini.files (Directory of Current File)' })

map('n', '<leader>fM', function()
  mini_files.open(vim.uv.cwd(), true)
end, { desc = 'Open mini.files (cwd)' })

map('n', '<leader>fc', "<CMD>lua require('mini.files').open(vim.fn.stdpath('config'))<CR>", { noremap = true, silent = true })

-- Keymaps adapted from Telescope, using command strings to avoid nil errors
map('n', '<leader>sh', '<CMD>Pick help<CR>', { desc = 'Search [H]elp' })
map('n', '<leader><leader>', '<CMD>Pick files<CR>', { desc = 'Search [F]iles' })
map('n', '<leader>sg', '<CMD>Pick grep_live<CR>', { desc = 'Search by [G]rep' })
map('n', '<leader>sr', '<CMD>Pick resume<CR>', { desc = 'Search [R]esume' })
map('n', '<leader>r', '<CMD>Pick buffers<CR>', { desc = '[ ] Find existing buffers' })
map('n', '<leader>sd', '<CMD>Pick diagnostic<CR>', { desc = 'Search [D]iagnostics' })
map('n', '<leader>sw', function()
  mini_pick.builtin.grep { pattern = vim.fn.expand '<cword>' }
end, { desc = 'Search current Word' })
map('n', '<leader>/', "<CMD>Pick buf_lines scope='current'<CR>", { desc = '[/] Fuzzily search' })
map('n', '<leader>sk', '<CMD>Pick keymaps', { desc = '[S]earch [K]eymaps' })
-- map('n', '<leader>ss', ':lua pick_registry()<CR>', { desc = '[S]earch [S]elect MiniPick' }) TODO: Fix this keymap
