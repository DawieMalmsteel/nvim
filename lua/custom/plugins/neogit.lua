return {
  'NeogitOrg/neogit',
  lazy = true,
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
  },
  cmd = 'Neogit',
  keys = {
    { '<leader>G', '<cmd>Neogit<cr>', desc = 'Show Neogit UI' },
  },
}
