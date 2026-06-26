return {
  {
    'AvengeMedia/base46',
    lazy = true,
    opts = {
      transparency = false,
    },
  },
  {
    'oskarnurm/koda.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('koda').setup { transparent = true }
      -- vim.cmd 'colorscheme base46-monochrome'
      -- vim.cmd 'colorscheme  base46-ayu_dark'
      -- vim.cmd 'colorscheme  base46-tokyodark'
      vim.cmd 'set background=light'
      vim.cmd 'colorscheme  flexoki'
      -- vim.cmd 'colorscheme koda-dark'
    end,
  },
{ 'kepano/flexoki-neovim', as = 'flexoki' },
  {
    'marekh19/meowsoot.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme 'meowsoot'
    end,
  },
}
