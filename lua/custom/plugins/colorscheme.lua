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
        transparent = false, -- set to true for transparent background
      }
      vim.cmd 'colorscheme nightingale'
    end,
  },
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
