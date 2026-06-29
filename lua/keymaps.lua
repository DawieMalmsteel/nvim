-- Generated while flattening keymaps; keep global maps here.
local map = vim.keymap.set

-- old keymaps: desc.lua
-- Decriptions for keymaps
map({ 'n', 'v' }, '<leader>c', '', { desc = '+code' })
map({ 'n', 'v' }, '<leader>a', '', { desc = '+ai' })
map({ 'n', 'v' }, '<leader>f', '', { desc = '+find' })
map({ 'n', 'v' }, '<leader>g', '', { desc = '+git' })
map({ 'n', 'v' }, '<leader>u', '', { desc = '+ui' })
map({ 'n', 'v' }, '<leader>q', '', { desc = '+quit' })
map({ 'n', 'v' }, '<leader>t', '', { desc = '+toggles' })
map({ 'n', 'v' }, '<leader>s', '', { desc = '+search' })
map({ 'n', 'v' }, 'gr', '', { desc = '+LSP' })
map({ 'n', 'v' }, '<leader>b', '', { desc = '+buffers' })
map({ 'n', 'v' }, '<leader>d', '', { desc = '+debug' })
map({ 'n', 'v' }, '<leader>cr', '', { desc = '+refactor' })
map({ 'n', 'v' }, '<leader>N', '', { desc = '+notes' })
map({ 'n', 'v' }, '<leader>m', '', { desc = '+make snip' })
map({ 'n', 'v' }, '<leader>x', '', { desc = '+diagnostic' })
map({ 'n', 'v' }, '<leader>w', '', { desc = '+wtf' })
map({ 'n', 'v' }, '<leader>C', '', { desc = '+Cargo' })
map({ 'n', 'v' }, '<leader>z', '', { desc = '+Zoom' })
map({ 'n', 'v' }, '<leader>bs', '', { desc = '+sort buffer' })

-- old keymaps: notes/init.lua
local notes_dir = vim.fn.stdpath 'config' .. '/notes'

map('n', '<leader>N', function()
  if vim.fn.isdirectory(notes_dir) == 0 then
    vim.fn.mkdir(notes_dir, 'p')
  end
  require('oil').open_float(notes_dir)
end, { desc = 'Open notes folder', silent = true })

-- old keymaps: buffer.lua
local TEMP = vim.fn.stdpath 'cache' .. '/temp.md'

-- Close Hidden Buffers
map('n', '<leader>bh', function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(buf) == 1 and vim.fn.bufwinnr(buf) == -1 then
      require('mini.bufremove').delete(buf, false)
    end
  end
end, { desc = 'Close Others Hidden Buffers' })

map('n', '<leader>bS', function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end, { desc = 'New Scratch Buffer' })

-- Open (or create) single temp file
map('n', '<leader>be', function()
  vim.cmd.edit(TEMP)
  vim.bo.bufhidden = 'hide'
  vim.notify('Temp file: ' .. TEMP, vim.log.levels.INFO)
end, { desc = 'Open Temp File' })

map('n', '<leader>bn', function()
  local file = vim.api.nvim_buf_get_name(0)
  local dir = (file ~= '' and vim.fn.filereadable(file) == 1) and vim.fn.fnamemodify(file, ':h') or vim.fn.getcwd()

  vim.ui.input({ prompt = 'New file: ', default = dir .. '/' }, function(path)
    if not path or path == '' or path == dir .. '/' then
      return
    end

    path = vim.fn.fnamemodify(path, ':p')
    if vim.fn.filereadable(path) == 1 then
      vim.cmd.edit(vim.fn.fnameescape(path))
      return
    end

    vim.fn.mkdir(vim.fn.fnamemodify(path, ':h'), 'p')
    vim.cmd.enew()
    vim.cmd.file(vim.fn.fnameescape(path))
    vim.cmd.startinsert()
  end)
end, { desc = 'New Named File' })

-- Open a split window on the right (20% width)
vim.keymap.set('n', '<leader>bv', function()
  local main_win = vim.api.nvim_get_current_win()
  
  -- Mở cửa sổ mới cố định ở bên phải
  vim.cmd('rightbelow vnew')
  local right_win = vim.api.nvim_get_current_win()
  local right_buf = vim.api.nvim_win_get_buf(right_win)
  
  -- Thiết lập độ rộng bằng 20% tổng màn hình
  vim.api.nvim_win_set_width(right_win, math.floor(vim.o.columns * 0.2))
  
  -- Ẩn các thành phần giao diện để biến cửa sổ này thành khoảng trống
  vim.wo[right_win].number = false
  vim.wo[right_win].relativenumber = false
  vim.wo[right_win].signcolumn = 'no'
  vim.wo[right_win].statusline = ' '
  vim.wo[right_win].winbar = ''
  
  -- Thiết lập buffer trống, tự xóa khi đóng
  vim.bo[right_buf].buftype = 'nofile'
  vim.bo[right_buf].bufhidden = 'wipe'
  vim.bo[right_buf].filetype = 'nofile'
  
  -- Đưa con trỏ quay lại cửa sổ chính bên trái
  vim.api.nvim_set_current_win(main_win)
end, { desc = 'Create 20% Right Padding' })

-- Delete temp file (and close its buffer if loaded)
map('n', '<leader>bE', function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf) == TEMP then
      require('mini.bufremove').delete(buf, true)
      break
    end
  end
  local ok, err = os.remove(TEMP)
  if ok then
    vim.notify('Deleted temp file', vim.log.levels.INFO)
  else
    vim.notify('Could not delete temp file: ' .. (err or ''), vim.log.levels.WARN)
  end
end, { desc = 'Delete Temp File' })

-- old keymaps: code.lua
-- Hiển thị diagnostic dưới con trỏ
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })

-- Mở diagnostics ra quickfix list
map('n', '<leader>cq', vim.diagnostic.setqflist, { desc = 'Diagnostics → Quickfix' })

-- Mason
map('n', '<leader>cm', '<CMD>Mason<CR>', { desc = 'Mason' })

-- refactor

map({ 'n', 'x' }, '<leader>cre', function()
  return require('refactoring').refactor 'Extract Function'
end, { expr = true, desc = 'Extract Function' })

map({ 'n', 'x' }, '<leader>crf', function()
  return require('refactoring').refactor 'Extract Function To File'
end, { expr = true, desc = 'Extract Function To File' })

map({ 'n', 'x' }, '<leader>crv', function()
  return require('refactoring').refactor 'Extract Variable'
end, { expr = true, desc = 'Extract Variable' })

map({ 'n', 'x' }, '<leader>crI', function()
  return require('refactoring').refactor 'Inline Function'
end, { expr = true, desc = 'Inline Function' })

map({ 'n', 'x' }, '<leader>cri', function()
  return require('refactoring').refactor 'Inline Variable'
end, { expr = true, desc = 'Inline Variable' })

map({ 'n', 'x' }, '<leader>crb', function()
  return require('refactoring').refactor 'Extract Block'
end, { expr = true, desc = 'Extract Block' })

map({ 'n', 'x' }, '<leader>crB', function()
  return require('refactoring').refactor 'Extract Block To File'
end, { expr = true, desc = 'Extract Block To File' })

map({ 'n', 'x' }, '<leader>crr', function()
  require('refactoring').select_refactor()
end, { desc = 'Select Refactor' })

-- old keymaps: diagnostics.lua
-- Diagnostic keymaps
-- map('n', '<leader>x', vim.diagnostic.setloclist, { desc = 'Diagnostic Quickfix list' })

map('n', '<C-x>', function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable()
  end
end, { desc = 'Toggle diagnostics (Ctrl+x)' })

-- Di chuyển diagnostic: dùng jump với float
map('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous diagnostic' })

map('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next diagnostic' })

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

-- old keymaps: general.lua
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

map({ 'n', 'x' }, 'j', 'gj', { noremap = true, silent = true })
map({ 'n', 'x' }, 'k', 'gk', { noremap = true, silent = true })

-- Chế độ normal (Normal mode)
map('n', ';', ':', { desc = 'CMD enter command mode' })

-- Chế độ insert (Insert mode)
map('i', 'kj', '<ESC>')
map('i', '<C-l>', '<C-o>a')
map('i', '<C-h>', '<C-o>h') -- Maybe not need

-- Save file
map({ 'n', 'i', 'x' }, '<C-s>', '<Esc>:w<CR>', { noremap = true, silent = true, desc = 'Save file' })

-- Tăng tốc độ cuộn của Ctrl-E và Ctrl-Y
map('n', '<C-e>', '2<C-e>', { noremap = true, silent = true })
map('n', '<C-y>', '2<C-y>', { noremap = true, silent = true })

-- Xóa dòng nhưng không thay đổi register
map('v', 'c', [["_c]])
map('n', 'c', [["_c]])
map('n', 'x', [["_x]])
map('n', 'X', [["_dd]])
map('v', 'x', [["_x]])

-- map('n', 'H', '<CMD>execute "silent! bprevious " . v:count1<CR>', { desc = 'Previous Buffer (with count)' })
-- map('n', 'L', '<CMD>execute "silent! bnext " . v:count1<CR>', { desc = 'Next Buffer (with count)' })

-- map('v', 'J', ":m'>+1<cr>gv=gv")
-- map('v', 'K', ":m'<-2<cr>gv=gv")

map({ 'n', 'x' }, '-', '_')

-- Visual mode: > / < nhiều lần (giữ nguyên selection để ấn tiếp)
map('x', '>', '>gv', { desc = 'Indent và giữ selection' })
map('x', '<', '<gv', { desc = 'Unindent và giữ selection' })
-- map({ 'n', 'x' }, '+', 'g_')
-- map({ 'n', 'x' }, '<S-tab>', '%')

map('n', "y'", "yi'", { noremap = true })
map('n', "v'", "vi'", { noremap = true })

map('n', 'y"', 'yi"', { noremap = true })
map('n', 'v"', 'vi"', { noremap = true })

-- old keymaps: misc.lua
-- add keymap to remove trailing whitespace
map('n', '<C-\\>', ':%s/\\r//g<CR>', { noremap = true, silent = true })

-- paste nhưng không thay đổi register
map('x', '<leader>P', [["_dP]])

-- Edit file
-- map('n', '<leader><Tab>', function()
--   local dir = vim.fn.expand '%:p:h' .. '/'
--   require('snacks').input({ prompt = 'New file: ', default = dir }, function(path)
--     if not path or path == '' or path == dir then
--       return
--     end
--     vim.cmd('edit ' .. vim.fn.fnameescape(path))
--   end)
-- end, { desc = 'New file (curr dir)' })

-- old keymaps: quit.lua
-- Quit
map('n', '<leader>qq', '<CMD>qa<CR>', { desc = 'quit all' })

map('n', '<leader>qQ', '<CMD>qa!<CR>', { desc = 'quit all !' })

map('n', '<leader>qb', function()
  local Snacks = require 'snacks'
  Snacks.bufdelete()
end, { desc = 'Delete Buffer' })

map('n', '<leader>qB', '<CMD>bw<CR>', { desc = 'Quit Buffer and windows' })

-- old keymaps: terminal.lua
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('t', '<C-z>', '<Nop>', { desc = 'Disable Ctrl-Z in terminal mode' })

-- old keymaps: toggle.lua
map('n', '<leader>td', function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable()
  end
end, { desc = 'Toggle diagnostics (Ctrl+x)' })

map('n', '<leader>tc', '<CMD>TSContext toggle<CR>', { desc = 'Toggle Treesitter Context' })

map('n', '<leader>tm', function()
  local mini_map = require 'mini.map'
  mini_map.toggle()
end, { desc = 'Toggle Mini Map' })

map('n', '<leader>ts', '<CMD>ShowkeysToggle<CR>', { desc = 'Toggle showkeys' })

-- map('n', '<leader>Tw', function()
--   if vim.wo.wrap then
--     vim.wo.wrap = false
--     vim.wo.linebreak = false
--     vim.opt_local.relativenumber = false
--     vim.opt_local.number = false
--     vim.notify('Wrap: OFF', vim.log.levels.INFO)
--   else
--     vim.wo.wrap = true
--     vim.wo.linebreak = true
--     vim.opt_local.relativenumber = true
--     vim.opt_local.number = true
--     vim.notify('Wrap: ON', vim.log.levels.INFO)
--   end
-- end, { desc = 'Toggle Wrap' })

-- map('n', '<leader>TT', '<Cmd>vertical term fish<CR>', { noremap = true, silent = true, desc = 'Terminal (vertical)' })

map('n', '<leader>tn', function()
  -- :set laststatus=0
  -- :set nonumber=0
  -- :set statuscolumn=""
  -- :set signcolumn=no
  if vim.o.number == false then
    vim.o.laststatus = 2
    vim.wo.number = true
    -- vim.wo.relativenumber = true
    vim.wo.signcolumn = 'yes'
    vim.notify('Numbers: ON', vim.log.levels.INFO)
  else
    vim.o.laststatus = 0
    vim.wo.number = false
    -- vim.wo.relativenumber = false
    vim.wo.signcolumn = 'no'
    vim.wo.statuscolumn = ''
    vim.notify('Numbers: OFF', vim.log.levels.INFO)
  end
end, { desc = 'Toggle Wrap' })

-- old keymaps: ui.lua
-- Wraptext
map('n', '<leader>uw', function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = 'Toggle Wrap Text' })

-- Open mini starter
-- map('n', '<leader>uo', function()
--   local mini_starter = require 'mini.starter'
--   mini_starter.open()
-- end, { desc = 'Open MiniStarter' })

-- Open Mini map
map('n', '<leader>um', function()
  local mini_map = require 'mini.map'
  mini_map.toggle()
end, { desc = 'Toggle Mini Map' })

-- Toggle Mini map focus
map('n', '<leader>uM', function()
  local mini_map = require 'mini.map'
  mini_map.toggle_focus()
end, { desc = 'Toggle Mini Map Focus' })

-- old keymaps: window.lua
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

-- old keymaps: database.lua
-- map('n', '<leader>d', '<CMD>DBUIToggle<CR>', { desc = 'Toggle DB' })

-- old keymaps: cargo.lua
-- Core Commands
map('n', '<leader>Cb', '<CMD>CargoBench<CR>', { desc = '📊 Run benchmarks' })
map('n', '<leader>CB', '<CMD>CargoBuild<CR>', { desc = '🏗️ Build the project' })
map('n', '<leader>Cc', '<CMD>CargoClean<CR>', { desc = '🧹 Remove generated artifacts' })
map('n', '<leader>Cd', '<CMD>CargoDoc<CR>', { desc = '📚 Generate project documentation' })
map('n', '<leader>CN', '<CMD>CargoNew<CR>', { desc = '✨ Create a new Cargo project' })
map('n', '<leader>CR', '<CMD>CargoRun<CR>', { desc = '▶️ Run the project in a floating window' })
map('n', '<leader>Cr', '<CMD>CargoRunTerm<CR>', { desc = '📟 Run the project in terminal mode' })
map('n', '<leader>Ct', '<CMD>CargoTest<CR>', { desc = '🧪 Run tests' })
map('n', '<leader>Cu', '<CMD>CargoUpdate<CR>', { desc = '🔄 Update dependencies' })

-- Additional Commands
map('n', '<leader>Ck', '<CMD>CargoCheck<CR>', { desc = '🔍 Check the project for errors' })
map('n', '<leader>Cp', '<CMD>CargoClippy<CR>', { desc = '📋 Run the Clippy linter' })
map('n', '<leader>Ca', ':CargoAdd ', { desc = '➕ Add dependency' })
map('n', '<leader>Cx', ':CargoRemove ', { desc = '➖ Remove dependency' })
map('n', '<leader>Cf', '<CMD>CargoFmt<CR>', { desc = '🎨 Format code with rustfmt' })
map('n', '<leader>CF', '<CMD>CargoFix<CR>', { desc = '🔧 Auto-fix warnings' })
map('n', '<leader>CP', '<CMD>CargoPublish<CR>', { desc = '📦 Publish package' })
map('n', '<leader>CI', ':CargoInstall ', { desc = '📥 Install binary' })
map('n', '<leader>CU', ':CargoUninstall ', { desc = '📤 Uninstall binary' })
map('n', '<leader>CS', ':CargoSearch ', { desc = '🔎 Search packages' })
map('n', '<leader>CT', '<CMD>CargoTree<CR>', { desc = '🌲 Show dependency tree' })
map('n', '<leader>CV', '<CMD>CargoVendor<CR>', { desc = '📦 Vendor dependencies' })
map('n', '<leader>CA', '<CMD>CargoAudit<CR>', { desc = '🛡️ Audit dependencies' })
map('n', '<leader>CO', '<CMD>CargoOutdated<CR>', { desc = '📊 Check outdated dependencies' })
map('n', '<leader>CD', '<CMD>CargoAutodd<CR>', { desc = '🤖 Automatically manage dependencies' })

-- old keymaps: markdown_sniprun.lua
map({ 'n', 'v' }, '<leader>mr', '<plug>SnipRun', { silent = true, desc = 'Run code block' })
map('n', '<leader>mc', '<CMD>SnipClose<CR>', { silent = true, desc = 'Close code block' })
map('n', '<leader>mC', '<cmd>SnipReplMemoryClean<cr>', { silent = true, desc = 'REPL memory clean' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function(ev)
    map('x', '<C-k>', '2sa]', { buffer = ev.buf, remap = true, desc = 'Wrap as wiki link' })
  end,
})
