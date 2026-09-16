local pack = require 'custom.pack'

-- [[ crates.nvim ]]
pack.add { pack.gh 'Saecki/crates.nvim' }

require('crates').setup {
  completion = {
    crates = {
      enabled = true,
    },
  },
  lsp = {
    enabled = true,
    actions = true,
    completion = true,
    hover = true,
  },
}

-- vim: ts=2 sts=2 sw=2 et
