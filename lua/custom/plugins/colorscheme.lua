return {
  -- {
  --   'navarasu/onedark.nvim',
  --   opts = {
  --     transparent = true,
  --     on_highlights = function(hlgroup, color)
  --       hlgroup.NormalFloat = { bg = color.none, fg = color.fg }
  --     end,
  --   },
  -- },
  -- {
  --   'folke/tokyonight.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     transparent = true,
  --   },
  -- },
  -- {
  --   'AlexvZyl/nordic.nvim',
  -- },
  -- {
  --   'glepnir/zephyr-nvim',
  --   requires = { 'nvim-treesitter/nvim-treesitter', opt = true },
  -- },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1001,
    opts = {
      transparent_background = false,
    },
  },
  { 'sainnhe/gruvbox-material' },
  { 'rebelot/kanagawa.nvim' },

  {
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      }

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      -- vim.cmd.colorscheme 'catppuccin'
      vim.cmd.colorscheme 'gruvbox-material'
      -- vim.cmd.colorscheme 'kanagawa'
    end,
  },
}
