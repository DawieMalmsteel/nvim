return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    -- NOTE: The log_level is in `opts.opts`
    -- opts = {
    --   log_level = 'DEBUG', -- or "TRACE"
    -- },
  },
  cmd = { 'CodeCompanion', 'CodeCompanionActions', 'CodeCompanionToggle', 'CodeCompanionAdd', 'CodeCompanionChat' },
  keys = {
    {
      '<leader>aa',
      '<cmd>CodeCompanionChat Toggle<CR>',
      desc = 'CodeCompanion chat',
      mode = { 'n', 'v' },
    },
    {
      '<leader>ae',
      '<cmd>CodeCompanion<CR>',
      desc = 'CodeCompanion inline',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aA',
      '<cmd>CodeCompanionActions<CR>',
      desc = 'Code Companion actions',
      mode = { 'n', 'v' },
    },
    {
      '<leader>ac',
      '<cmd>CodeCompanionCmd<CR>',
      desc = 'CodeCompanion command',
      mode = { 'n', 'v' },
    },
  },
}
