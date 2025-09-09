local core = require 'custom.keymaps.core'
local map = core.map
local git_pick = core.git_pick
local file_dir = core.file_dir

-- Lazygit
map('n', '<leader>gg', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.lazygit { cwd = file_dir() }
  end
end, { desc = 'Lazygit' })

map('n', '<leader>gl', function()
  local Snacks = core.sr 'snacks'
  if Snacks and Snacks.lazygit then
    Snacks.lazygit.log { cwd = file_dir() }
  end
end, { desc = 'Lazygit Logs' })

-- Git pickers (Snacks)
map('n', '<leader>gs', git_pick 'git_status', { desc = 'Git Status' })
map('n', '<leader>gd', git_pick 'git_diff', { desc = 'Git Diff' })
map('n', '<leader>gF', git_pick 'git_log_file', { desc = 'Git Log File' })
map('n', '<leader>gS', git_pick 'git_stash', { desc = 'Git Stash' })
map('n', '<leader>gB', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.git_branches { layout = 'select', cwd = file_dir() }
  end
end, { desc = 'Git Branches (select)' })

map('n', '<leader>gb', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.git_branches()
  end
end, { desc = 'Git Branches' })

map('n', '<leader>gL', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.git_log_line()
  end
end, { desc = 'Git Log Line' })

-- Git hunks (Pick)
map('n', '<leader>gh', function()
  vim.cmd('cd ' .. file_dir())
  vim.cmd 'Pick git_hunks'
end, { desc = 'Git Hunks (file dir)' })
