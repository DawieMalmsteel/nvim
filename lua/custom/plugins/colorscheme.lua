return {
  {
    'navarasu/onedark.nvim',
    opts = {
      transparent = true,
      on_highlights = function(hlgroup, color)
        hlgroup.NormalFloat = { bg = color.none, fg = color.fg }
      end,
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
  {
    'AlexvZyl/nordic.nvim',
  },
  {
    'glepnir/zephyr-nvim',
    requires = { 'nvim-treesitter/nvim-treesitter', opt = true },
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1001,
    opts = {
      transparent_background = true,
    },
  },
  -- {
  --   'LazyVim/LazyVim',
  --   opts = {
  --     -- colorscheme = "zephyr",
  --     -- colorscheme = "tokyonight",
  --     colorscheme = 'catppuccin-mocha',
  --   },
  -- },
}
