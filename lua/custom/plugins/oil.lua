return {
  'stevearc/oil.nvim',
  opts = {
    keymaps = {
      ['<tab>'] = { 'actions.parent', mode = 'n' },
    },
    view_options = {
      show_hidden = true,
    },
  },
  lazy = false,
  keys = {
    { '<leader>e', '<cmd>Oil<CR>', desc = 'Oil', mode = { 'n' } },
  },
}
