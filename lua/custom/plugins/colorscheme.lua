return {
  {
    'tiagovla/tokyodark.nvim',
    lazy = false,
    opts = {
      transparent_background = true,
    },
    config = function(_, opts)
      require('tokyodark').setup(opts) -- calling setup is optional
      -- vim.cmd [[colorscheme tokyodark]]
      -- vim.cmd [[colorscheme tokyonight-night]]
      vim.cmd [[colorscheme catppuccin]]
      -- vim.cmd [[colorscheme night-owl]]
    end,
  },
  'oxfist/night-owl.nvim',
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {
      flavour = 'mocha', -- latte, frappe, macchiato, mocha
      background = { -- :h background
        light = 'latte',
        dark = 'mocha',
      },
      transparent_background = false,
      float = {
        transparent = false, -- enable transparent floating windows
        solid = true, -- use solid styling for floating windows, see |winborder|
      },
      show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
      term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
      dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = 'dark',
        percentage = 0.25, -- percentage of the shade to apply to the inactive window
      },
      no_italic = false, -- Force no italic
      no_bold = false, -- Force no bold
      no_underline = false, -- Force no underline
      styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = {}, -- Change the style of comments
        conditionals = { 'italic' },
        loops = { 'italic' },
        functions = { 'italic' },
        keywords = { 'italic' },
        strings = { 'italic' },
        variables = { 'italic' },
        numbers = { 'italic' },
        booleans = { 'italic' },
        properties = { 'italic' },
        types = { 'italic' },
        operators = { 'italic' },
        miscs = { 'italic' }, -- Uncomment to turn off hard-coded styles
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
          background = false,
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
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
    },
  },
}
