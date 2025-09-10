local map = vim.keymap.set

-- Diagnostic keymaps
map('n', '<leader>x', vim.diagnostic.setloclist, { desc = 'Diagnostic Quickfix list' })

map('n', '<C-x>', function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable()
  end
end, { desc = 'Toggle diagnostics (Ctrl+x)' })

-- Di chuyển diagnostic: dùng jump với float
map('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous diagnostic' })

map('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next diagnostic' })

-- Diagnostic mức độ error tiếp theo
map('n', ']e', function()
  vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR, float = true }
end, { desc = 'Next Error' })

-- Diagnostic mức độ error trước đó
map('n', '[e', function()
  vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR, float = true }
end, { desc = 'Prev Error' })

-- Diagnostic mức độ warning tiếp theo
map('n', ']w', function()
  vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.WARN, float = true }
end, { desc = 'Next Warning' })

-- Diagnostic mức độ warning trước đó
map('n', '[w', function()
  vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.WARN, float = true }
end, { desc = 'Prev Warning' })
