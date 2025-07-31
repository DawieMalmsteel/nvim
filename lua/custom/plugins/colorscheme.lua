return {
  {
    'AlexvZyl/nordic.nvim',
    config = function()
      require('nordic').setup {
        transparent = {
          bg = false,
          float = false,
        },
      }
      vim.cmd.colorscheme 'nordic'
    end,
  },
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
  --   'glepnir/zephyr-nvim',
  --   requires = { 'nvim-treesitter/nvim-treesitter', opt = true },
  -- },
  -- {
  --   'catppuccin/nvim',
  --   name = 'catppuccin',
  --   priority = 1001,
  --   opts = {
  --     transparent_background = false,
  --   },
  -- },
  -- { 'sainnhe/gruvbox-material' },
  -- { 'rebelot/kanagawa.nvim' },
  -- {
  --   'folke/tokyonight.nvim',
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   config = function()
  --     ---@diagnostic disable-next-line: missing-fields
  --     require('tokyonight').setup {
  --       styles = {
  --         comments = { italic = false }, -- Disable italics in comments
  --       },
  --     }
  --
  --     -- Load the colorscheme here.
  --     -- Like many other themes, this one has different styles, and you could load
  --     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  --     -- vim.cmd.colorscheme 'catppuccin'
  --     -- vim.cmd.colorscheme 'kanagawa'
  --   end,
  -- },
}
