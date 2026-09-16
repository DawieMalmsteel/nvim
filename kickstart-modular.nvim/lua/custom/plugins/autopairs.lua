local pack = require 'custom.pack'

-- autopairs
-- https://github.com/windwp/nvim-autopairs
pack.add {
  pack.gh 'windwp/nvim-autopairs',
  pack.gh 'windwp/nvim-ts-autotag',
}

require('nvim-autopairs').setup {}
require('nvim-ts-autotag').setup {}

-- vim: ts=2 sts=2 sw=2 et
