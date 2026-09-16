local pack = require 'custom.pack'

-- [[ supermaven-nvim ]]
-- Loaded before bafa.nvim in lua/plugins.lua so bafa's `<Tab>` toggle wins
-- (same net effect as the old lazy.nvim `keys` registration).
pack.add { pack.gh 'supermaven-inc/supermaven-nvim' }

require('supermaven-nvim').setup {
  keymaps = {
    accept_suggestion = '<Tab>',
    clear_suggestion = '<C-]>',
    accept_word = '<C-8>',
  },
}

-- vim: ts=2 sts=2 sw=2 et
