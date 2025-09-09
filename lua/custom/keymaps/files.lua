local core = require 'custom.keymaps.core'
local map = core.map
local file_dir = core.file_dir

-- Mini.files mở theo file hiện tại hoặc cwd
map('n', '<leader>e', function()
  local current = vim.api.nvim_buf_get_name(0)
  if current == '' or current:match '^ministarter://' or current:match '^oil://' or vim.fn.filereadable(current) ~= 1 then
    require('mini.files').open(vim.fn.getcwd(), true)
  else
    require('mini.files').open(current, true)
  end
end, { desc = 'mini.files (file dir hoặc cwd)' })

map('n', '<leader>fm', function()
  require('mini.files').open((vim.loop or vim.uv).cwd(), true)
end, { desc = 'mini.files (cwd)' })

-- Nvim config
map('n', '<leader>fC', function()
  require('mini.pick').builtin.files(nil, { source = { cwd = vim.fn.stdpath 'config' } })
end, { desc = 'Files (config)' })
map('n', '<leader>fc', function()
  require('mini.pick').builtin.files(nil, { source = { cwd = vim.fn.stdpath 'config' } })
end, { desc = 'Files (config)' })

-- Notes
map('n', '<leader>N', function()
  require('mini.files').open(vim.fn.stdpath 'config' .. '/notes', true)
end, { desc = 'Open notes folder' })

-- Registers / marks (Snacks Pick)
map('n', '<leader>fR', '<CMD>Pick registers<CR>', { desc = 'Registers (Pick)' })
map('n', '<leader>fM', '<CMD>Pick marks<CR>', { desc = 'Marks (Pick)' })

-- Buffers nhanh (Snacks)
map('n', '<leader>fb', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.buffers()
  end
end, { desc = 'Buffers (Snacks)' })

-- Buffers (tất cả)
map('n', '<leader>fF', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.buffers { hidden = true, nofile = true }
  end
end, { desc = 'Buffers (all)' })

-- Rename file (Snacks rename)
map('n', 'grN', function()
  local Snacks = core.sr 'snacks'
  if Snacks and Snacks.rename then
    Snacks.rename.rename_file()
  else
    vim.notify('Snacks rename không khả dụng', vim.log.levels.WARN)
  end
end, { desc = 'Rename current file' })

-- Git files / commits / branches dùng cwd file
map('n', '<leader>gf', function()
  vim.cmd('cd ' .. file_dir())
  vim.cmd 'Pick git_files'
end, { desc = 'Git files (file dir)' })

map('n', '<leader>gc', function()
  vim.cmd('cd ' .. file_dir())
  vim.cmd 'Pick git_commits'
end, { desc = 'Git commits (file dir)' })

-- Diff overlay
map('n', '<leader>go', function()
  vim.cmd('cd ' .. file_dir())
  local diff = core.sr 'mini.diff'
  if diff then
    diff.toggle_overlay(0)
  end
end, { desc = 'mini.diff overlay (file dir)' })
