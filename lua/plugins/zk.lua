return {
  'zk-org/zk-nvim',
  name = 'zk',
  ft = 'markdown',
  opts = {
    picker = 'snacks_picker',
    lsp = {
      config = {
        name = 'zk',
        cmd = { 'zk', 'lsp' },
        filetypes = { 'markdown' },
      },
      auto_attach = {
        enabled = true,
      },
    },
  },
}
