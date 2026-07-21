return {
  'hedyhli/outline.nvim',
  lazy = true,
  cmd = { 'Outline', 'OutlineOpen' },
  keys = { -- Example mapping to toggle outline
    { '<leader>cs', '<cmd>Outline<CR>', desc = 'Toggle outline' },
  },
  opts = {
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
      auto_preview = true,
      open_hover_on_preview = true,
    }
  },
}
