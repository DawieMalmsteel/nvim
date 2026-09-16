local pack = require 'custom.pack'

-- [[ SchemaStore.nvim ]]
-- `version = false` (lazy.nvim) meant "latest commit"; vim.pack's default
-- (no version) tracks the default branch, which is the same thing.
-- Used by lua/config/lsp_servers.lua for yamlls/jsonls `before_init`.
pack.add { pack.gh 'b0o/SchemaStore.nvim' }

-- vim: ts=2 sts=2 sw=2 et
