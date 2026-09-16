local pack = require 'custom.pack'

-- [[ trouble.nvim ]]
pack.add { pack.gh 'folke/trouble.nvim' }

require('trouble').setup {
  modes = {
    preview_float = {
      mode = 'diagnostics',
      preview = {
        type = 'float',
        relative = 'editor',
        border = 'rounded',
        title = 'Preview',
        title_pos = 'center',
        -- position = { -1, -0.5 },
        size = { width = 0.4, height = 0.3 },
        zindex = 200,
      },
    },
  },
} -- for default options, refer to the configuration section for custom setup.

vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Diagnostics (Trouble)' })
vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Buffer Diagnostics (Trouble)' })
-- vim.keymap.set('n', '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', { desc = 'Symbols (Trouble)' })
vim.keymap.set('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', { desc = 'LSP Definitions / references / ... (Trouble)' })
vim.keymap.set('n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>', { desc = 'Location List (Trouble)' })
vim.keymap.set('n', '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', { desc = 'Quickfix List (Trouble)' })
vim.keymap.set('n', '<leader>xp', '<cmd>Trouble preview_float toggle<cr>', { desc = 'Diagnostics Float Preview (Trouble)' })

-- vim: ts=2 sts=2 sw=2 et
