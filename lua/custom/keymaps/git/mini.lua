local map = vim.keymap.set

map('n', '<leader>gh', function()
  vim.cmd('cd ' .. vim.fn.expand '%:p:h')
  vim.cmd 'Pick git_hunks'
end, { desc = 'Open git hunks (cwd to file dir)' })

map('n', '<leader>gf', function()
  vim.cmd('cd ' .. vim.fn.expand '%:p:h')
  vim.cmd 'Pick git_files'
end, { desc = 'Open git files (cwd to file dir)' })

map('n', '<leader>gc', function()
  vim.cmd('cd ' .. vim.fn.expand '%:p:h')
  vim.cmd 'Pick git_commits'
end, { desc = 'Open git commits (cwd to file dir)' })

map('n', '<leader>go', function()
  vim.cmd('cd ' .. vim.fn.expand '%:p:h')
  require('mini.diff').toggle_overlay(0)
end, { desc = 'Toggle mini.diff overlay (cwd to file dir)' })
