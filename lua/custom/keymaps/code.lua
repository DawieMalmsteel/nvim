local map = vim.keymap.set

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
