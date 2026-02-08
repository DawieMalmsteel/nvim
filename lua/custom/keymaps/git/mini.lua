local map = vim.keymap.set

map('n', '<leader>gh', function()
  vim.cmd('cd ' .. vim.fn.expand '%:p:h')
  vim.cmd 'Pick git_hunks'
end, { desc = 'hunks' })

map('n', '<leader>gO', function()
  vim.cmd('cd ' .. vim.fn.expand '%:p:h')
  vim.cmd 'Pick git_commits'
end, { desc = 'commits' })

map('n', '<leader>go', function()
  vim.cmd('cd ' .. vim.fn.expand '%:p:h')
  require('mini.diff').toggle_overlay(0)
end, { desc = 'overlay' })

map('n', '<leader>gc', function()
  vim.cmd 'Git commit'
end, { desc = 'commit' })

map('n', '<leader>gC', function()
  vim.cmd 'Git commit --amend'
end, { desc = 'commit amend' })

map('n', '<leader>ga', function()
  vim.cmd 'Git add %'
end, { desc = 'add' })

map('n', '<leader>gA', function()
  vim.cmd 'Git add .'
end, { desc = 'add all' })

map('n', '<leader>gr', function()
  vim.cmd 'Git reset'
end, { desc = 'reset' })

map('n', '<leader>gP', function()
  vim.cmd 'Git push'
end, { desc = 'push' })

map('n', '<leader>gM', function()
  vim.cmd 'Pick git_hunks'
end, { desc = 'hunks all' })

map('n', '<leader>gm', function()
  vim.cmd 'Pick git_hunks path="%"'
end, { desc = 'hunks %' })
