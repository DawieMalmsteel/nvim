local pack = require 'custom.pack'

-- [[ neogit ]]
pack.add {
  pack.gh 'NeogitOrg/neogit',
  pack.gh 'nvim-lua/plenary.nvim', -- required
}

-- Commands come from the plugin itself; no setup call needed.
vim.keymap.set('n', '<leader>gg', '<cmd>Neogit <cr>', { desc = 'Show Neogit UI' })
vim.keymap.set('n', '<leader>gc', '<cmd>Neogit cwd=%:p:h<cr>', { desc = 'Show Neogit UI current file' })

-- vim: ts=2 sts=2 sw=2 et
