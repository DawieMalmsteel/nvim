local pack = require 'custom.pack'

-- [[ bafa.nvim ]]
pack.add { { src = pack.gh 'mistweaverco/bafa.nvim', version = 'v1.12.3' } }

vim.keymap.set('n', '<Tab>', function()
  require('bafa').toggle { with_jump_labels = true }
end, { desc = 'Bafa' })

-- vim: ts=2 sts=2 sw=2 et
