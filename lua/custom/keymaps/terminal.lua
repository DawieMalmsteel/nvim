local core = require 'custom.keymaps.core'
local map = core.map

-- Toggle terminal (Snacks)
map({ 'n', 't' }, '<C-/>', function()
  local Snacks = core.sr 'snacks'
  if Snacks and Snacks.terminal then
    Snacks.terminal()
  end
end, { desc = 'Toggle Terminal' })

-- Jump references (Snacks words)
map({ 'n', 't' }, ']]', function()
  local Snacks = core.sr 'snacks'
  if Snacks and Snacks.words then
    Snacks.words.jump(vim.v.count1)
  end
end, { desc = 'Next Reference' })
map({ 'n', 't' }, '[[', function()
  local Snacks = core.sr 'snacks'
  if Snacks and Snacks.words then
    Snacks.words.jump(-vim.v.count1)
  end
end, { desc = 'Prev Reference' })

-- Thoát terminal nhanh
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
