local core = require 'custom.keymaps.core'
local map = core.map

-- Toggle diagnostics
map('n', '<leader>td', core.toggle_diagnostics, { desc = 'Toggle diagnostics' })
map('n', '<C-x>', core.toggle_diagnostics, { desc = 'Toggle diagnostics' })

-- Quickfix / loclist
map('n', '<leader>x', vim.diagnostic.setloclist, { desc = 'Diagnostics → Loclist' })
map('n', '<leader>cq', vim.diagnostic.setqflist, { desc = 'Diagnostics → Quickfix' })

-- Float line diagnostics
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })

-- Điều hướng
map('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Prev Diagnostic' })
map('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Next Diagnostic' })

map('n', ']e', function()
  vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR, float = true }
end, { desc = 'Next Error' })
map('n', '[e', function()
  vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR, float = true }
end, { desc = 'Prev Error' })

map('n', ']w', function()
  vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.WARN, float = true }
end, { desc = 'Next Warning' })
map('n', '[w', function()
  vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.WARN, float = true }
end, { desc = 'Prev Warning' })
