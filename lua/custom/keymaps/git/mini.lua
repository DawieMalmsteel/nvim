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

map('n', '<leader>gM', function()
  vim.cmd 'Pick git_hunks'
end, { desc = 'Modified hunks (all)' })

map('n', '<leader>gm', function()
  vim.cmd 'Pick git_hunks path="%"'
end, { desc = 'Modified hunks (buffer)' })

-- local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
-- local git_log_buf_cmd = git_log_cmd .. ' --follow -- %'
--
-- local nmap_leader = function(suffix, rhs, desc)
--   vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc })
-- end
-- local xmap_leader = function(suffix, rhs, desc)
--   vim.keymap.set('x', '<Leader>' .. suffix, rhs, { desc = desc })
-- end
-- nmap_leader('gv', '<Cmd>' .. git_log_cmd .. '<CR>', 'Log')
-- nmap_leader('gV', '<Cmd>' .. git_log_buf_cmd .. '<CR>', 'Log buffer')
-- xmap_leader('gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', 'Show at selection')
