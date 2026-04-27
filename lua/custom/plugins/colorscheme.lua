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
}
