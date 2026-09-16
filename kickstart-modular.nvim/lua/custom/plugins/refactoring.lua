local pack = require 'custom.pack'

-- [[ refactoring.nvim ]]
-- NOTE: refactoring.nvim does `require('async')`, which is provided by
-- guh.nvim (packaged in lua/async.lua). That is why custom.plugins.guh is
-- required before this module in lua/plugins.lua.
pack.add {
  pack.gh 'ThePrimeagen/refactoring.nvim',
  pack.gh 'nvim-lua/plenary.nvim',
  pack.gh 'nvim-treesitter/nvim-treesitter',
}

require('refactoring').setup {}

-- Keymaps live in lua/custom/keymaps.lua.

-- vim: ts=2 sts=2 sw=2 et
