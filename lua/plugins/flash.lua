return {
  'folke/flash.nvim',
  opts = {
    modes = {
      char = {
        enabled = true,
      },
    },
  },
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
    {
      'f',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump {
          search = { mode = 'search', max_length = 0 },
          label = { after = { 0, 0 } },
          pattern = '^',
        }
      end,
      desc = 'Flash f',
    },
    {
      'F',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump {
          search = { mode = 'search', max_length = 0 },
          label = { after = { 0, 0 } },
          pattern = '^',
        }
      end,
      desc = 'Flash F',
    },
    {
      't',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump {
          search = { mode = 'search', max_length = 0 },
          label = { after = { 0, 0 } },
          pattern = '.',
        }
      end,
      desc = 'Flash t',
    },
    {
      'T',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump {
          search = { mode = 'search', max_length = 0 },
          label = { after = { 0, 0 } },
          pattern = '.',
        }
      end,
      desc = 'Flash T',
    },
  },
}
