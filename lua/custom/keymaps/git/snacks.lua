local map = vim.keymap.set

-- Snacks git keymaps
map('n', '<leader>gl', function()
  local Snacks = require 'snacks'
  Snacks.lazygit.log { cwd = vim.fn.expand '%:p:h' }
end, { desc = 'Lazygit Logs' })

map('n', '<leader>gG', function()
  local Snacks = require 'snacks'
  Snacks.lazygit { cwd = vim.fn.expand '%:p:h' }
end, { desc = 'Lazygit' })

map('n', '<leader>gB', function()
  local Snacks = require 'snacks'
  Snacks.picker.git_branches { layout = 'select', cwd = vim.fn.expand '%:p:h' }
end, { desc = 'Pick and Change Git Branches' })

map('n', '<leader>gS', function()
  Snacks.picker.git_stash { cwd = vim.fn.expand '%:p:h' }
end, { desc = 'Stash' })

map('n', '<leader>gs', function()
  Snacks.picker.git_status { cwd = vim.fn.expand '%:p:h' }
end, { desc = 'Status' })

map('n', '<leader>gd', function()
  Snacks.picker.git_diff { cwd = vim.fn.expand '%:p:h' }
end, { desc = 'diff' })

map('n', '<leader>gF', function()
  Snacks.picker.git_log_file { cwd = vim.fn.expand '%:p:h' }
end, { desc = 'Log %' })

map('n', '<leader>gb', function()
  local picker = require 'snacks.picker'
  picker.git_branches()
end, { desc = 'Branches' })

map('n', '<leader>gL', function()
  local picker = require 'snacks.picker'
  picker.git_log_line()
end, { desc = 'Log Line' })

map('n', '<leader>go', function()
  vim.cmd('cd ' .. vim.fn.expand '%:p:h')
  require('mini.diff').toggle_overlay(0)
end, { desc = 'overlay' })
