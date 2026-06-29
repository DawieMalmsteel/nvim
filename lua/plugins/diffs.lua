vim.g.diffs = {
  integrations = {
    fugitive = true,
    neogit = true,
    neojj = true,
    gitsigns = true,
  },
}

return {
  'barrettruth/diffs.nvim',
  keys = {
    {
      '<leader>go',
      '<cmd>Diff<cr>',
      desc = 'Diff current file',
    },
  },
}
