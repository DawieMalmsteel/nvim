return {
  'folke/trouble.nvim',
  version = '*', -- ensure latest (v3)
  cmd = 'Trouble',
  opts = {
    modes = {
      preview_float = {
        mode = 'diagnostics',
        preview = {
          type = 'float',
          relative = 'editor',
          border = 'rounded',
          title = 'Preview',
          title_pos = 'center',
          -- position = { -1, -0.5 },
          size = { width = 0.4, height = 0.3 },
          zindex = 200,
        },
      },
    },
  }, -- for default options, refer to the configuration section for custom setup.
  keys = {
    {
      '<leader>xx',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Diagnostics (Trouble)',
    },
    {
      '<leader>xX',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = 'Buffer Diagnostics (Trouble)',
    },
    {
      '<leader>cs',
      '<cmd>Trouble symbols toggle focus=false<cr>',
      desc = 'Symbols (Trouble)',
    },
    {
      '<leader>cl',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = 'LSP Definitions / references / ... (Trouble)',
    },
    {
      '<leader>xL',
      '<cmd>Trouble loclist toggle<cr>',
      desc = 'Location List (Trouble)',
    },
    {
      '<leader>xQ',
      '<cmd>Trouble qflist toggle<cr>',
      desc = 'Quickfix List (Trouble)',
    },
    {
      '<leader>xp',
      '<cmd>Trouble preview_float toggle<cr>',
      desc = 'Diagnostics Float Preview (Trouble)',
    },
  },
}
