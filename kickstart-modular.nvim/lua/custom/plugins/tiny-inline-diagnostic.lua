local pack = require 'custom.pack'

-- [[ tiny-inline-diagnostic.nvim ]]
-- Required to run after custom/plugins/lsp.lua so it can disable Neovim's
-- default virtual text diagnostics.
pack.add { pack.gh 'rachartier/tiny-inline-diagnostic.nvim' }

require('tiny-inline-diagnostic').setup()
vim.diagnostic.config { virtual_text = false } -- Disable Neovim's default virtual text diagnostics

-- vim: ts=2 sts=2 sw=2 et
