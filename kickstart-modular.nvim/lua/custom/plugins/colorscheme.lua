local pack = require 'custom.pack'

-- [[ Colorscheme ]]
pack.add { pack.gh 'folke/tokyonight.nvim' }

require('tokyonight').setup {
  transparent = true,
}

vim.cmd.colorscheme 'tokyonight'
-- vim.cmd.colorscheme 'base46-eldritch'

-- base46 is installed but never loaded (same as the lazy.nvim `lazy = true`
-- spec it replaces). Re-enable with `load = true` if you want to switch.
vim.pack.add({ pack.gh 'AvengeMedia/base46' }, { confirm = false, load = false })

-- vim: ts=2 sts=2 sw=2 et
