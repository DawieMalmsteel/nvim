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

map('n', '<leader>ts', function()
  if vim.g.ministatusline_disable then
    vim.g.ministatusline_disable = nil
    vim.notify('Mini statusline: ON', vim.log.levels.INFO)
  else
    vim.g.ministatusline_disable = true
    vim.notify('Mini statusline: OFF', vim.log.levels.INFO)
  end
  vim.cmd.redrawstatus()
end, { desc = 'Toggle Mini Statusline' })

-- Toggle mini.tabline (also hide actual tabline UI)
map('n', '<leader>tt', function()
  if vim.g.minitabline_disable then
    vim.g.minitabline_disable = nil
    local prev = vim.g.__showtabline_before_mini_toggle
    vim.o.showtabline = (prev and prev >= 0) and prev or 1
    vim.notify('Mini tabline: ON', vim.log.levels.INFO)
  else
    vim.g.minitabline_disable = true
    vim.g.__showtabline_before_mini_toggle = vim.o.showtabline
    vim.o.showtabline = 0
    vim.notify('Mini tabline: OFF', vim.log.levels.INFO)
  end
  vim.cmd 'redraw!'
end, { desc = 'Toggle Mini Tabline' })
