local pack = require 'custom.pack'

-- [[ grug-far.nvim ]]
pack.add { pack.gh 'MagicDuck/grug-far.nvim' }

require('grug-far').setup { headerMaxWidth = 80 }

vim.keymap.set({ 'n', 'x' }, '<leader>S', function()
  local grug = require 'grug-far'
  local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
  grug.open {
    transient = true,
    prefills = {
      filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
    },
  }
end, { desc = 'Search and Replace' })

-- vim: ts=2 sts=2 sw=2 et
