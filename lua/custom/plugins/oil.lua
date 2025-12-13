return {
  'stevearc/oil.nvim',
  opts = {
    keymaps = {
      ['<tab>'] = { 'actions.parent', mode = 'n' },
    },
  },
  lazy = false,
  keys = {
    { '<leader>e', '<cmd>Oil<CR>', desc = 'Oil', mode = { 'n' } },
  },
}
