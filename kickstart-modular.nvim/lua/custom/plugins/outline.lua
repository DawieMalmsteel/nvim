local pack = require 'custom.pack'

-- [[ outline.nvim ]]
pack.add { pack.gh 'hedyhli/outline.nvim' }

require('outline').setup {
  outline_window = {
    position = 'left',
    wrap = false,
  },
  auto_width = {
    -- Dynamically resize window width to fit content
    enabled = false,
    -- -- Maximum width (columns or percent if relative_width)
    max_width = 40,
    -- Include symbol details in width calculation
    include_symbol_details = true,
  },
  preview_window = {
    auto_preview = false,
    open_hover_on_preview = true,
  },
}

-- Example mapping to toggle outline
vim.keymap.set('n', '<leader>cs', '<cmd>Outline<CR>', { desc = 'Toggle outline' })

-- vim: ts=2 sts=2 sw=2 et
