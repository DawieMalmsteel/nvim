local map = require('custom.keymaps.core').map

-- Refactoring.nvim
local function refactor(name)
  return function()
    return require('refactoring').refactor(name)
  end
end

map({ 'n', 'x' }, '<leader>cre', refactor 'Extract Function', { expr = true, desc = 'Extract Function' })
map({ 'n', 'x' }, '<leader>crf', refactor 'Extract Function To File', { expr = true, desc = 'Extract Function To File' })
map({ 'n', 'x' }, '<leader>crv', refactor 'Extract Variable', { expr = true, desc = 'Extract Variable' })
map({ 'n', 'x' }, '<leader>crI', refactor 'Inline Function', { expr = true, desc = 'Inline Function' })
map({ 'n', 'x' }, '<leader>cri', refactor 'Inline Variable', { expr = true, desc = 'Inline Variable' })
map({ 'n', 'x' }, '<leader>crbb', refactor 'Extract Block', { expr = true, desc = 'Extract Block' })
map({ 'n', 'x' }, '<leader>crbf', refactor 'Extract Block To File', { expr = true, desc = 'Extract Block To File' })

map({ 'n', 'x' }, '<leader>rr', function()
  require('refactoring').select_refactor()
end, { desc = 'Select Refactor' })
