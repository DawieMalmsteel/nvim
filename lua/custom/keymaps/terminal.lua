local map = vim.keymap.set

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Toggle terminal
map({ 'n', 't' }, '<C-/>', function()
  local Snacks = require 'snacks'
  Snacks.terminal()
end, { noremap = true, silent = true, desc = 'Toggle Terminal' })

map({ 'n', 't' }, '<C-_>', function()
  local Snacks = require 'snacks'
  Snacks.terminal()
end, { noremap = true, silent = true, desc = 'which_key_ignore' })
