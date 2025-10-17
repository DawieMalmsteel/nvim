local map = vim.keymap.set

map('n', '<leader>gh', function()
  vim.cmd('cd ' .. vim.fn.expand '%:p:h')
  vim.cmd 'Pick git_hunks'
end, { desc = 'Open git hunks (cwd to file dir)' })

map('n', '<leader>gf', function()
  vim.cmd('cd ' .. vim.fn.expand '%:p:h')
  vim.cmd 'Pick git_files'
end, { desc = 'Open git files (cwd to file dir)' })

map('n', '<leader>gO', function()
  vim.cmd('cd ' .. vim.fn.expand '%:p:h')
  vim.cmd 'Pick git_commits'
end, { desc = 'Open git commits (cwd to file dir)' })

map('n', '<leader>go', function()
  vim.cmd('cd ' .. vim.fn.expand '%:p:h')
  require('mini.diff').toggle_overlay(0)
end, { desc = 'Toggle mini.diff overlay (cwd to file dir)' })

map('n', '<leader>gc', function()
  vim.cmd 'Git commit'
end, { desc = 'Git commit' })

map('n', '<leader>gC', function()
  vim.cmd 'Git commit --amend'
end, { desc = 'Git commit amend' })

map('n', '<leader>gD', function()
  vim.cmd 'Git diff -- %'
end, { desc = 'Git diff buffer' })

map('n', '<leader>ga', function()
  vim.cmd 'Git add %'
end, { desc = 'Git add file' })

map('n', '<leader>gA', function()
  vim.cmd 'Git add .'
end, { desc = 'Git add all files in cwd' })

map('n', '<leader>gr', function()
  vim.cmd 'Git reset'
end, { desc = 'Git reset' })

map('n', '<leader>gP', function()
  vim.cmd 'Git push'
end, { desc = 'Git push' })
