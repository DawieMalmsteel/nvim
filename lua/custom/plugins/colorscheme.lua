return {
  {
    'thesimonho/kanagawa-paper.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    'xeind/nightingale.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('nightingale').setup {
        transparent = true, -- set to true for transparent background
      }
      vim.cmd 'colorscheme nightingale'
    end,
  },
  -- 'sainnhe/everforest',
  -- {
  --   'e-ink-colorscheme/e-ink.nvim',
  --   priority = 1000,
  --   config = function()
  --     require('e-ink').setup()
  --     -- vim.opt.background = 'light'
  --
  --     -- choose light mode or dark mode
  --     -- vim.opt.background = "dark"
  --     -- vim.opt.background = "light"
  --     --
  --     -- or do
  --     -- :set background=dark
  --     -- :set background=light
  --   end,
  -- },
  {
    'wtfox/jellybeans.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
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
