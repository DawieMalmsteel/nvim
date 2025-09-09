local map = require('custom.keymaps.core').map

-- Refactoring.nvim
local function refactor(name)
  return function()
    return require('refactoring').refactor(name)
  end
end

map({ 'n', 'x' }, '<leader>re', refactor 'Extract Function', { expr = true, desc = 'Extract Function' })
map({ 'n', 'x' }, '<leader>rf', refactor 'Extract Function To File', { expr = true, desc = 'Extract Function To File' })
map({ 'n', 'x' }, '<leader>rv', refactor 'Extract Variable', { expr = true, desc = 'Extract Variable' })
map({ 'n', 'x' }, '<leader>rI', refactor 'Inline Function', { expr = true, desc = 'Inline Function' })
map({ 'n', 'x' }, '<leader>ri', refactor 'Inline Variable', { expr = true, desc = 'Inline Variable' })
map({ 'n', 'x' }, '<leader>rbb', refactor 'Extract Block', { expr = true, desc = 'Extract Block' })
map({ 'n', 'x' }, '<leader>rbf', refactor 'Extract Block To File', { expr = true, desc = 'Extract Block To File' })

map({ 'n', 'x' }, '<leader>rr', function()
  require('refactoring').select_refactor()
end, { desc = 'Select Refactor' })
