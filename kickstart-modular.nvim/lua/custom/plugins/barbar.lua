local pack = require 'custom.pack'

-- [[ barbar.nvim ]]
pack.add {
  pack.gh 'romgrk/barbar.nvim',
  pack.gh 'nvim-tree/nvim-web-devicons',
}

vim.g.barbar_auto_setup = true
vim.g.barbar_tabline_visible = false
vim.opt.showtabline = 0

require('barbar').setup {
  animation = false,
  insert_at_start = false,
  deleted = { enabled = true, icon = ' ' },
}
vim.opt.showtabline = 0

local function map(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { desc = desc })
end

map('H', '<CMD>execute "silent! BufferPrevious " . v:count1<CR>', 'Previous Buffer (with count)')
map('L', '<CMD>execute "silent! BufferNext " . v:count1<CR>', 'Next Buffer (with count)')
map('<A-[>', '<Cmd>BufferMovePrevious<CR>', 'Move Buffer Previous')
map('<A-]>', '<Cmd>BufferMoveNext<CR>', 'Move Buffer Next')
map('<A-q>', '<Cmd>BufferClose<CR>', 'Close Buffer')
map('<A-r>', '<Cmd>BufferRestore<CR>', 'Restore Buffer')
-- map('<Space>bsb', '<Cmd>BufferOrderByBufferNumber<CR>', 'Order Buffers by Number')
-- map('<Space>bsn', '<Cmd>BufferOrderByName<CR>', 'Order Buffers by Name')
-- map('<Space>bsd', '<Cmd>BufferOrderByDirectory<CR>', 'Order Buffers by Directory')
-- map('<Space>bsl', '<Cmd>BufferOrderByLanguage<CR>', 'Order Buffers by Language')
-- map('<Space>bsw', '<Cmd>BufferOrderByWindowNumber<CR>', 'Order Buffers by Window Number')
map('<leader>ub', function()
  vim.g.barbar_tabline_visible = not vim.g.barbar_tabline_visible
  vim.opt.showtabline = vim.g.barbar_tabline_visible and 2 or 0
  vim.cmd 'redrawtabline'
end, 'Toggle tabline')

-- vim: ts=2 sts=2 sw=2 et
