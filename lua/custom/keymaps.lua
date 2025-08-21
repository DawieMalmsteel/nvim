local map = vim.keymap.set
local Snacks = require 'snacks'
local picker = Snacks.picker
local mini_files = require 'mini.files'
local mini_pick = require 'mini.pick'
local mini_extra = require 'mini.extra'
local mini_starter = require 'mini.starter'
local mini_map = require 'mini.map'

-- NOTE: fold
-- zc: Collapse the fold under the cursor.
-- zo: Open the fold under the cursor.
-- zM: Collapse all folds in the file.
-- zR: Open all folds in the file.

map('n', '<Esc>', '<cmd>nohlsearch<CR>')

map('n', 'j', 'gj', { noremap = true, silent = true })
map('n', 'k', 'gk', { noremap = true, silent = true })

-- Diagnostic keymaps
map('n', '<leader>x', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
map('n', '<leader>td', function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable()
  end
end, { desc = 'Toggle diagnostics (Ctrl+x)' })
map('n', '<C-x>', function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable()
  end
end, { desc = 'Toggle diagnostics (Ctrl+x)' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Decriptions for keymaps
map({ 'n', 'v' }, '<leader>c', '', { desc = '+code' })
map({ 'n', 'v' }, '<leader>a', '', { desc = '+ai' })
map({ 'n', 'v' }, '<leader>f', '', { desc = '+find' })
map({ 'n', 'v' }, '<leader>g', '', { desc = '+git' })
map({ 'n', 'v' }, '<leader>u', '', { desc = '+ui' })
map({ 'n', 'v' }, '<leader>q', '', { desc = '+quit' })
map({ 'n', 'v' }, '<leader>S', '', { desc = '+session' })
map({ 'n', 'v' }, 'gr', '', { desc = '+LSP' })

-- Chế độ normal (Normal mode)
map('n', ';', ':', { desc = 'CMD enter command mode' })
map('i', 'kj', '<ESC>')

-- Save file
map({ 'n', 'i' }, '<C-s>', '<Esc>:w<CR>', { noremap = true, silent = true, desc = 'Save file' })

-- Sql query
-- map("n", "<leader>r", ":'<,'>DB", { noremap = true, silent = true })

-- Explore
map('n', '<leader>E', function()
  Snacks.explorer()
end, { desc = 'Explorer Snacks (cwd)' })
map('n', '<leader>o', '<CMD>Pick oldfiles<CR>', { desc = 'Open oldfiles' })

-- add keymap to remove trailing whitespace
map('n', '<C-\\>', ':%s/\\r//g<CR>', { noremap = true, silent = true })

-- Toggle terminal
map({ 'n', 't' }, '<C-/>', function()
  Snacks.terminal()
end, { noremap = true, silent = true, desc = 'Toggle Terminal' })
map({ 'n', 't' }, '<C-_>', function()
  Snacks.terminal()
end, { noremap = true, silent = true, desc = 'which_key_ignore' })

map({ 'n', 't' }, ']]', function()
  Snacks.words.jump(vim.v.count1)
end, { desc = 'Next Reference' })
map({ 'n', 't' }, '[[', function()
  Snacks.words.jump(-vim.v.count1)
end, { desc = 'Prev Reference' })

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
  Snacks.lazygit.log { cwd = vim.fn.expand '%:p:h' }
end, { desc = 'Lazygit Logs' })

map('n', '<leader>gg', function()
  Snacks.lazygit { cwd = vim.fn.expand '%:p:h' }
end, { desc = 'Lazygit' })

map('n', '<leader>gB', function()
  Snacks.picker.git_branches { layout = 'select', cwd = vim.fn.expand '%:p:h' }
end, { desc = 'Pick and Change Git Branches' })

map('n', '<leader>gh', function()
  vim.cmd('cd ' .. vim.fn.expand '%:p:h')
  vim.cmd 'Pick git_hunks'
end, { desc = 'Open git hunks (cwd to file dir)' })

map('n', '<leader>gS', function()
  Snacks.picker.git_stash { cwd = vim.fn.expand '%:p:h' }
end, { desc = 'Git Stash' })

map('n', '<leader>gs', function()
  Snacks.picker.git_status { cwd = vim.fn.expand '%:p:h' }
end, { desc = 'Git Status' })

map('n', '<leader>gd', function()
  Snacks.picker.git_diff { cwd = vim.fn.expand '%:p:h' }
end, { desc = 'Git diff' })

map('n', '<leader>gF', function()
  Snacks.picker.git_log_file { cwd = vim.fn.expand '%:p:h' }
end, { desc = 'Git Log File' })

-- Quit
map('n', '<leader>qq', '<CMD>qa<CR>', { desc = 'quit all' })
map('n', '<leader>qQ', '<CMD>qa!<CR>', { desc = 'quit all !' })
map('n', '<leader>qb', function()
  Snacks.bufdelete()
end, { desc = 'Delete Buffer' })
map('n', '<leader>qB', '<CMD>bw<CR>', { desc = 'Quit Buffer and windows' })
map('n', '<leader>qw', function()
  local session_file = 'Session.vim'
  local uv = vim.loop
  local stat = uv.fs_stat(session_file)
  if stat then
    vim.cmd('mksession! ' .. session_file)
  else
    vim.cmd('mksession ' .. session_file)
  end
  vim.cmd 'qa'
end, { desc = 'Save session and quit' })

-- Window management all trash
-- map('n', '<leader>-', '<CMD>split<CR>', { desc = 'Split window below' })
-- map('n', '<leader>_', '<CMD>split<CR>', { desc = 'Split window above' })
-- map('n', '<leader>\\', '<CMD>vsplit<CR>', { desc = 'Split window right' })
-- map('n', '<leader>|', '<CMD>vsplit<CR>', { desc = 'Split window left' })
map('n', '<leader>qd', '<C-w>q', { desc = 'Close Window (Keep Buffer)' })
-- NOTE: use Ctrl-W for window management

-- Resize window
map('n', '<C-Up>', ':resize +1<CR>', { desc = 'Tăng chiều cao cửa sổ' })
map('n', '<C-Down>', ':resize -1<CR>', { desc = 'Giảm chiều cao cửa sổ' })
map('n', '<C-Right>', ':vertical resize +1<CR>', { desc = 'Tăng chiều rộng cửa sổ' })
map('n', '<C-Left>', ':vertical resize -1<CR>', { desc = 'Giảm chiều rộng cửa sổ' })

-- Wraptext
map('n', '<leader>uw', function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = 'Toggle Wrap Text' })

-- Change color scheme
map('n', '<leader>uc', '<CMD>lua Snacks.picker.colorschemes()<CR>', { desc = 'Change theme' })

-- Switch buffer
map('n', '<Tab>', '<CMD>bnext<CR>', { desc = 'Next Buffer' })
map('n', '<S-Tab>', '<CMD>bprevious<CR>', { desc = 'Previous Buffer' })
map('n', 'H', '<CMD>execute "silent! bprevious " . v:count1<CR>', { desc = 'Previous Buffer (with count)' })
map('n', 'L', '<CMD>execute "silent! bnext " . v:count1<CR>', { desc = 'Next Buffer (with count)' })

-- Snacks picker
map('n', '<leader>fb', function()
  picker.buffers()
end, { desc = 'Buffers' })

map('n', '<leader>ff', function()
  vim.cmd('cd ' .. vim.env.PWD or vim.fn.getcwd())
  vim.cmd 'Pick files'
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

map('n', '<leader>gf', function()
  vim.cmd('cd ' .. vim.fn.expand '%:p:h')
  vim.cmd 'Pick git_files'
end, { desc = 'Open git files (cwd to file dir)' })

map('n', '<leader>gc', function()
  vim.cmd('cd ' .. vim.fn.expand '%:p:h')
  vim.cmd 'Pick git_commits'
end, { desc = 'Open git commits (cwd to file dir)' })

map('n', '<leader>go', function()
  vim.cmd('cd ' .. vim.fn.expand '%:p:h')
  require('mini.diff').toggle_overlay(0)
end, { desc = 'Toggle mini.diff overlay (cwd to file dir)' })

map('n', '<leader>;', function()
  picker.command_history()
end, { desc = 'Search Command History' })

map('n', '<leader>n', function()
  if Snacks.config.picker and Snacks.config.picker.enabled then
    Snacks.picker.notifications()
  else
    Snacks.notifier.show_history()
  end
end, { desc = 'Notification History' })

map('n', '<leader>un', function()
  Snacks.notifier.hide()
end, { desc = 'Dismiss All Notifications' })

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
map('n', '<leader>e', function()
  local current_file = vim.api.nvim_buf_get_name(0)
  -- Check for special buffers first - only check specific known protocols
  if current_file == '' or current_file:match '^ministarter://' or current_file:match '^oil://' or vim.fn.filereadable(current_file) ~= 1 then
    mini_files.open(vim.fn.getcwd(), true)
  else
    mini_files.open(current_file, true)
  end
end, { desc = 'Open mini.files (Directory of Current File)' })

map('n', '<leader>fm', function()
  mini_files.open(vim.uv.cwd(), true)
end, { desc = 'Open mini.files (cwd)' })

map(
  'n',
  '<leader>fC',
  ":lua require('mini.pick').builtin.files(nil, { source = { cwd = vim.fn.stdpath 'config' } })<CR>",
  { desc = 'Open mini.files (nvim config)' }
)
map(
  'n',
  '<leader>fc',
  ":lua require('mini.pick').builtin.files(nil, { source = { cwd = vim.fn.stdpath 'config' } })<CR>",
  { desc = 'Open mini.picker (nvim config)' }
)
map('n', '<leader>fR', '<CMD>Pick registers<CR>', { desc = 'Open register' })
map('n', '<leader>fM', '<CMD>Pick marks<CR>', { desc = 'Open marks' })

-- Keymaps adapted from Telescope, using command strings to avoid nil errors
map('n', '<leader>sh', '<CMD>Pick help<CR>', { desc = 'Search [H]elp' })
map('n', '<leader><leader>', function()
  local file = vim.api.nvim_buf_get_name(0)
  local dir = (file ~= '' and vim.fn.filereadable(file) == 1) and vim.fn.fnamemodify(file, ':h') or vim.fn.getcwd()
  mini_pick.builtin.files(nil, { source = { cwd = dir } })
end, { desc = 'Search Files in cwd' })

map('n', '<leader>sG', function()
  vim.cmd('cd ' .. vim.env.PWD or vim.fn.getcwd())
  vim.cmd 'Pick grep_live'
end, { desc = 'Search by [G]rep' })

map('n', '<leader>sg', function()
  local file = vim.api.nvim_buf_get_name(0)
  local dir = (file ~= '' and vim.fn.filereadable(file) == 1) and vim.fn.fnamemodify(file, ':h') or vim.fn.getcwd()
  mini_pick.builtin.grep_live(nil, { source = { cwd = dir } })
end, { desc = 'Search by [G]rep in file root or cwd' })
map('n', '<leader>sr', '<CMD>Pick resume<CR>', { desc = 'Search [R]esume' })
map('n', '<leader>r', function()
  local wipeout_cur = function()
    vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {})
  end
  local buffer_mappings = { wipeout = { char = '<c-d>', func = wipeout_cur } }
  MiniPick.builtin.buffers({ include_current = true }, { mappings = buffer_mappings })
end, { desc = 'Find existing buffers' })

-- map('n', '<leader>sd', '<CMD>Pick diagnostic<CR>', { desc = 'Search [D]iagnostics' })
map('n', '<leader>sw', function()
  mini_pick.builtin.grep { pattern = vim.fn.expand '<cword>' }
end, { desc = 'Search current Word' })
map('n', '<leader>/', "<CMD>Pick buf_lines scope='current'<CR>", { desc = 'Fuzzily search' })
-- map('n', '<leader>sk', '<CMD>Pick keymaps<CR>', { desc = '[S]earch [K]eymaps' })

-- LSP keymaps
map('n', 'grd', function()
  mini_extra.pickers.lsp { scope = 'definition' }
end, { desc = '[G]o to [D]efinition' })
map('n', 'gri', function()
  mini_extra.pickers.lsp { scope = 'implementation' }
end, { desc = '[G]oto [I]mplementation' })
map('n', 'grr', function()
  mini_extra.pickers.lsp { scope = 'references' }
end, { desc = '[G]oto [R]eferences' })
map('n', 'grD', function()
  mini_extra.pickers.lsp { scope = 'declaration' }
end, { desc = '[G]oto [D]eclaration' })
map('n', 'gO', function()
  mini_extra.pickers.lsp { scope = 'document_symbol' }
end, { desc = 'Open Document Symbols' })
map('n', 'gW', function()
  mini_extra.pickers.lsp { scope = 'workspace_symbol' }
end, { desc = 'Open Workspace Symbols' })
map('n', 'grt', function()
  mini_extra.pickers.lsp { scope = 'type_definition' }
end, { desc = '[G]oto [T]ype Definition' })

map('n', 'grN', function()
  Snacks.rename.rename_file()
end, { desc = 'Rename current file with mini.files' })

-- Treesitter context keymaps
map('n', '[c', function()
  require('treesitter-context').go_to_context(vim.v.count1)
end, { silent = true, desc = 'Go to upward Treesitter context' })
-- Toggle Treesitter context
map('n', '<leader>tc', '<CMD>TSContext toggle<CR>', { desc = 'Toggle Treesitter Context' })

-- Open mini starter
map('n', '<leader>uo', function()
  mini_starter.open()
end, { desc = 'Open MiniStarter' })

-- Open Mini map
map('n', '<leader>um', function()
  mini_map.toggle()
end, { desc = 'Toggle Mini Map' })
-- Toggle Mini map focus
map('n', '<leader>uM', function()
  mini_map.toggle_focus()
end, { desc = 'Toggle Mini Map Focus' })

-- Mini session
map('n', '<leader>Ss', function()
  require('mini.sessions').select()
end, { desc = 'Open Session' })
map('n', '<leader>Sw', function()
  require('mini.sessions').write()
end, { desc = 'Write Session' })
map('n', '<leader>Sd', function()
  require('mini.sessions').delete(nil, { force = true })
end, { desc = 'Remove Session' })
map('n', '<leader>Sl', function()
  require('mini.sessions').read(nil, { force = true })
end, { desc = 'Load Last Session (Current Project)' })
map('n', '<leader>ql', function()
  require('mini.sessions').read(nil, { force = true })
end, { desc = 'Load Last Session (Current Project)' })

map('n', '<leader>Sc', function()
  vim.cmd 'mksession'
end, { desc = 'Create Session (:mksession)' })

-- Edit file
map('n', '<leader><Tab>', ':e<Space>', { desc = '+New file' })

-- Delete marks
map('n', '<C-m>', ':delmarks<Space>', { desc = 'Delete marks' })

-- Toggle dashboard
map('n', '<leader>tD', function()
  Snacks.dashboard()
end, { desc = 'Toggle Dashboard' })

map('n', '<leader>sb', function()
  Snacks.picker.lines()
end, { desc = 'Buffer Lines' })

map('n', '<leader>sB', function()
  Snacks.picker.grep_buffers()
end, { desc = 'Grep Open Buffers' })

map('n', '<leader>sp', function()
  Snacks.picker.lazy()
end, { desc = 'Search for Plugin Spec' })

map('n', '<leader>s"', function()
  Snacks.picker.registers()
end, { desc = 'Registers' })

map('n', '<leader>s/', function()
  Snacks.picker.search_history()
end, { desc = 'Search History' })

map('n', '<leader>sa', function()
  Snacks.picker.autocmds()
end, { desc = 'Autocmds' })

map('n', '<leader>sc', function()
  Snacks.picker.command_history()
end, { desc = 'Command History' })

map('n', '<leader>sC', function()
  Snacks.picker.commands()
end, { desc = 'Commands' })

map('n', '<leader>sd', function()
  Snacks.picker.diagnostics()
end, { desc = 'Diagnostics' })

map('n', '<leader>sD', function()
  Snacks.picker.diagnostics_buffer()
end, { desc = 'Buffer Diagnostics' })

map('n', '<leader>sh', function()
  Snacks.picker.help()
end, { desc = 'Help Pages' })

map('n', '<leader>sH', function()
  Snacks.picker.highlights()
end, { desc = 'Highlights' })

map('n', '<leader>si', function()
  Snacks.picker.icons()
end, { desc = 'Icons' })

map('n', '<leader>sj', function()
  Snacks.picker.jumps()
end, { desc = 'Jumps' })

map('n', '<leader>sk', function()
  Snacks.picker.keymaps()
end, { desc = 'Keymaps' })

map('n', '<leader>sl', function()
  Snacks.picker.loclist()
end, { desc = 'Location List' })

map('n', '<leader>sM', function()
  Snacks.picker.man()
end, { desc = 'Man Pages' })

map('n', '<leader>sm', function()
  Snacks.picker.marks()
end, { desc = 'Marks' })

map('n', '<leader>sR', function()
  Snacks.picker.resume()
end, { desc = 'Resume' })

map('n', '<leader>sq', function()
  Snacks.picker.qflist()
end, { desc = 'Quickfix List' })

map('n', '<leader>su', function()
  Snacks.picker.undo()
end, { desc = 'Undotree' })

map('n', '<leader>fF', function()
  Snacks.picker.buffers { hidden = true, nofile = true }
end, { desc = 'Files buffers in Snacks (all)' })

map('v', 'J', ":m'>+1<cr>gv=gv")
map('v', 'K', ":m'<-2<cr>gv=gv")

map({ 'n', 'x' }, 'ga', '^')
map({ 'n', 'x' }, 'gA', 'g_')
map({ 'n', 'x' }, '\\', '%')
