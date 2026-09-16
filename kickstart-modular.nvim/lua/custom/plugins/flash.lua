local pack = require 'custom.pack'

-- [[ flash.nvim ]]
pack.add { pack.gh 'folke/flash.nvim' }

require('flash').setup {
  modes = {
    char = {
      enabled = true,
    },
  },
}

local function jump(opts)
  return function()
    require('flash').jump(opts)
  end
end

local modes = { 'n', 'x', 'o' }

vim.keymap.set(modes, 'S', function()
  require('flash').jump()
end, { desc = 'Flash' })
vim.keymap.set(modes, 'R', function()
  require('flash').treesitter()
end, { desc = 'Flash Treesitter' })
vim.keymap.set(
  modes,
  'f',
  jump {
    search = { mode = 'search', max_length = 0 },
    label = { after = { 0, 0 } },
    pattern = '^',
  },
  { desc = 'Flash f' }
)
vim.keymap.set(
  modes,
  'F',
  jump {
    search = { mode = 'search', max_length = 0 },
    label = { after = { 0, 0 } },
    pattern = '^',
  },
  { desc = 'Flash F' }
)
vim.keymap.set(
  modes,
  't',
  jump {
    search = { mode = 'search', max_length = 0 },
    label = { after = { 0, 0 } },
    pattern = '.',
  },
  { desc = 'Flash t' }
)
vim.keymap.set(
  modes,
  'T',
  jump {
    search = { mode = 'search', max_length = 0 },
    label = { after = { 0, 0 } },
    pattern = '.',
  },
  { desc = 'Flash T' }
)

-- vim: ts=2 sts=2 sw=2 et
