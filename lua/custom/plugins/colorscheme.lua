return {
  {
    'tiagovla/tokyodark.nvim',
    lazy = false,
    opts = {
      transparent_background = false,
    },
    config = function(_, opts)
      require('tokyodark').setup(opts) -- calling setup is optional
      -- vim.cmd [[colorscheme tokyodark]]
      vim.cmd [[colorscheme nightfly]]
    end,
  },
  { 'bluz71/vim-nightfly-colors', name = 'nightfly', lazy = false, priority = 1000 },
  {
    -- 'sainnhe/sonokai',
    -- lazy = false,
    -- priority = 1000,
    -- config = function()
    --   -- Optionally configure and load the colorscheme
    --   -- directly inside the plugin declaration.
    --   vim.g.sonokai_enable_italic = true
    --   vim.g.sonokai_style = 'andromeda'
    --   -- vim.g.sonokai_transparent_background = 2
    --   -- vim.cmd.colorscheme 'sonokai'
    -- end,
  },
  {
    -- 'catppuccin/nvim',
    -- name = 'catppuccin',
    -- priority = 1000,
    -- opts = {
    --   flavour = 'mocha', -- latte, frappe, macchiato, mocha
    --   transparent_background = false, -- disables setting the background color.
    --   float = {
    --     transparent = false, -- enable transparent floating windows
    --     solid = true, -- use solid styling for floating windows, see |winborder|
    --   },
    -- },
  },
  {
    -- 'projekt0n/github-nvim-theme',
    -- name = 'github-theme',
    -- lazy = false, -- make sure we load this during startup if it is your main colorscheme
    -- priority = 1000, -- make sure to load this before all the other start plugins
    -- config = function()
    --   require('github-theme').setup {
    --     options = { transparent = true },
    --   }
    --
    --   -- vim.cmd 'colorscheme github_dark_tritanopia'
    -- end,
  },
  {
    -- 'folke/tokyonight.nvim',
    -- lazy = false,
    -- priority = 1000,
    -- opts = {
    --   transparent = true,
    -- },
  },
  {
    -- 'AlexvZyl/nordic.nvim',
    -- config = function()
    --   require('nordic').setup {
    --     transparent = {
    --       bg = true,
    --       float = true,
    --     },
    --   }
    --   -- vim.cmd [[colorscheme tokyonight-moon]]
    -- end,
  },
}
