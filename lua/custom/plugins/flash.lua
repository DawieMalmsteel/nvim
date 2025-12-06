return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  vscode = true,
  opts = {},
  keys = {
    {
      'S',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump()
      end,
      desc = 'Flash',
    },
    {
      'R',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').treesitter()
      end,
      desc = 'Flash Treesitter',
    },
  },
}
