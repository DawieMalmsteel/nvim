local map = vim.keymap.set

-- add keymap to remove trailing whitespace
map('n', '<C-\\>', ':%s/\\r//g<CR>', { noremap = true, silent = true })

-- paste nhưng không thay đổi register
map('x', '<leader>P', [["_dP]])

map({ 'n', 't' }, ']]', function()
  local Snacks = require 'snacks'
  Snacks.words.jump(vim.v.count1)
end, { desc = 'Next Reference' })

map({ 'n', 't' }, '[[', function()
  local Snacks = require 'snacks'
  Snacks.words.jump(-vim.v.count1)
end, { desc = 'Prev Reference' })

map('n', '<leader>;', function()
  local picker = require 'snacks.picker'
  picker.command_history()
end, { desc = 'Search Command History' })

-- Edit file
map('n', '<leader><Tab>', ':e<Space>', { desc = '+New file' })
