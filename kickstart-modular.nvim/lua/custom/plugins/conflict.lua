local pack = require 'custom.pack'

-- [[ conflict.nvim ]]
pack.add { pack.gh 'niekdomi/conflict.nvim' }

require('conflict').setup {
  -- your config here
}

-- vim: ts=2 sts=2 sw=2 et
