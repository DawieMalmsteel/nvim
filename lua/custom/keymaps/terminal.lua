local map = vim.keymap.set

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Toggle terminal
-- map({ 'n', 't' }, '<C-/>', function()
--   local Snacks = require 'snacks'
--   Snacks.terminal()
-- end, { noremap = true, silent = true, desc = 'Toggle Terminal' })
--
-- map({ 'n', 't' }, '<C-_>', function()
--   local Snacks = require 'snacks'
--   Snacks.terminal()
-- end, { noremap = true, silent = true, desc = 'which_key_ignore' })

map('n', '<C-/>', ':FloatermToggle<CR>', { noremap = true, silent = true, desc = 'Toggle Terminal' })
map('n', '<C-_>', ':FloatermToggle<CR>', { noremap = true, silent = true, desc = 'Toggle Terminal' })
map('t', '<C-/>', '<C-\\><C-n>:FloatermToggle<CR>', { noremap = true, silent = true, desc = 'Toggle Terminal' })

map('t', '<C-_>', '<C-\\><C-n>:FloatermToggle<CR>', { noremap = true, silent = true, desc = 'which_key_ignore' })

-- horizontal terminal
-- map('n', '<leader>TT', '<Cmd>horizontal term<CR>', { noremap = true, silent = true, desc = 'Terminal (horizontal)' })

-- vertical terminal
-- map('n', '<leader>T', '<Cmd>vertical term fish<CR>', { noremap = true, silent = true, desc = 'Terminal (vertical)' })
