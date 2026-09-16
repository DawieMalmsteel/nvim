local pack = require 'custom.pack'

-- [[ nvim-origami ]]
pack.add { pack.gh 'chrisgrieser/nvim-origami' }

-- recommended: disable vim's auto-folding
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

require('origami').setup {} -- required even when using default config

-- vim: ts=2 sts=2 sw=2 et
