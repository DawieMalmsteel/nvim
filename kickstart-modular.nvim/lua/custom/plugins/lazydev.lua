local pack = require 'custom.pack'

-- [[ lazydev.nvim ]]
-- Lua LSP "library" definitions and the blink.cmp `lazydev` source.
--
-- lazy.nvim's `${3rd}` placeholder is gone in the vim.pack world; point
-- lazydev at Neovim's own runtime instead, which defines `vim.uv`.
pack.add { pack.gh 'folke/lazydev.nvim' }

require('lazydev').setup {
  library = {
    { path = vim.env.VIMRUNTIME, words = { 'vim%.uv' } },
  },
}

-- vim: ts=2 sts=2 sw=2 et
