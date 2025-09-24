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
    end,
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
    config = function()
      require('nordic').setup {
        transparent = {
          bg = true,
          float = true,
        },
      }
      vim.cmd [[colorscheme tokyonight-night]]
    end,
  },
}
