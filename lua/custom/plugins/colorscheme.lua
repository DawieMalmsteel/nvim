return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {
      flavour = 'frappe', -- latte, frappe, macchiato, mocha
      background = { -- :h background
        light = 'latte',
        dark = 'frappe',
      },
      transparent_background = false,
      float = {
        transparent = false, -- enable transparent floating windows
        solid = true, -- use solid styling for floating windows, see |winborder|
      },
      show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
      term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
      dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = 'dark',
        percentage = 0.25, -- percentage of the shade to apply to the inactive window
      },
      no_italic = false, -- Force no italic
      no_bold = false, -- Force no bold
      no_underline = false, -- Force no underline
      styles = {
        comments = { 'italic' },
        conditionals = { 'italic' },
        loops = { 'italic' },
        keywords = { 'italic', 'bold' },

        functions = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        miscs = {},
      },
      lsp_styles = { -- Handles the style of specific lsp hl groups (see `:h lsp-highlight`).
        virtual_text = {
          errors = { 'bold' },
          hints = { 'bold' },
          warnings = { 'bold' },
          information = { 'bold' },
          ok = { 'bold' },
        },
        underlines = {
          errors = { 'underline' },
          hints = { 'underline' },
          warnings = { 'underline' },
          information = { 'underline' },
          ok = { 'underline' },
        },
        inlay_hints = {
          background = true,
        },
      },
      color_overrides = {},
      custom_highlights = {},
      default_integrations = true,
      auto_integrations = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        notify = true,
        mini = {
          enabled = true,
          indentscope_color = '',
        },
      },
    },

    config = function(_, opts)
      require('catppuccin').setup(opts) -- calling setup is optional
      -- vim.cmd [[colorscheme vscode]]
      vim.cmd [[colorscheme jellybeans-hc]]
      vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#241b20', underline = false })
    end,
  },
  {
    'thesimonho/kanagawa-paper.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    'wtfox/jellybeans.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      flat_ui = true,
      italics = true,
      bold = true,
    }, -- Optional
  },
  {
    'ankushbhagats/pastel.nvim',
    lazy = false, -- disable lazy loading
    priority = 1000, -- load immediately at startup
    opts = {}, -- your configuration comes here
    config = true, -- call setup function with provided opts
  },
}
