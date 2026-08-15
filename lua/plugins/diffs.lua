return {
  'barrettruth/diffs.nvim',
  cmd = 'Diff',
  config = function()
    -- diffs.nvim reads its options from `vim.g.diffs` at require time.
    vim.g.diffs = {
      integrations = {
        fugitive = true,
        neogit = true,
        neojj = true,
        gitsigns = true,
      },
    }
  end,
  keys = {
    {
      '<leader>go',
      '<cmd>Diff<cr>',
      desc = 'Diff current file',
    },
  },
}
