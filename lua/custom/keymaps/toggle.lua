local map = vim.keymap.set

map('n', '<leader>D', '<CMD>DBUIToggle<CR>', { desc = 'Toggle DB' })

map('n', '<leader>td', function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable()
  end
end, { desc = 'Toggle diagnostics (Ctrl+x)' })

map('n', '<leader>tm', ':RenderMarkdown toggle<CR>', { desc = 'Toggle Markdown Preview' })

map('n', '<leader>ti', ':InlineFoldToggle<CR>', { desc = 'Toggle Inline Fold Toggle ' })

map('n', '<leader>tc', '<CMD>TSContext toggle<CR>', { desc = 'Toggle Treesitter Context' })

-- Toggle dashboard
map('n', '<leader>tD', function()
  Snacks.dashboard()
end, { desc = 'Toggle Dashboard' })
