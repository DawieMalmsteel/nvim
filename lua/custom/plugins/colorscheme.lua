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
      vim.cmd [[colorscheme tokyonight-storm]]
      vim.g.nightflyTransparent = true
      -- vim.cmd [[colorscheme nightfly]]
    end,
  },
  { 'bluz71/vim-nightfly-colors', name = 'nightfly', lazy = false, priority = 1000 },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
    },
  },
}
