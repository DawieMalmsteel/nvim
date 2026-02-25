return {
  'NeogitOrg/neogit',
  lazy = true,
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
  },
  cmd = 'Neogit',
  keys = {
    { '<leader>G', '<cmd>Neogit<cr>', desc = 'Show Neogit UI' },
    { '<leader>gg', '<cmd>Neogit kind=floating<cr>', desc = 'Show Neogit UI' },
    { '<leader>gc', '<cmd>Neogit cwd=%:p:h<cr>', desc = 'Show Neogit UI current file' },
  },
}
