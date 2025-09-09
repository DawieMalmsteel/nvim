local core = require 'custom.keymaps.core'
local map = core.map
local file_dir = core.file_dir

-- Command history (Snacks picker)
map('n', '<leader>;', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.command_history()
  end
end, { desc = 'Command History' })

-- Files (Snacks Pick)
map('n', '<leader>ff', function()
  vim.cmd('cd ' .. (vim.env.PWD or vim.fn.getcwd()))
  vim.cmd 'Pick files'
end, { desc = 'Find Files (cwd)' })

map('n', '<leader>fr', function()
  local Snacks = core.sr 'snacks'
  if Snacks and Snacks.picker.recent then
    Snacks.picker.recent { live = true }
  else
    local pick = core.sr 'mini.pick'
    if pick then
      pick.builtin.files(nil, { source = { cwd = file_dir() } })
    end
  end
end, { desc = 'Recent Files' })

-- Buffers lines / grep buffers
map('n', '<leader>sb', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.lines()
  end
end, { desc = 'Buffer Lines' })

map('n', '<leader>sB', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.grep_buffers()
  end
end, { desc = 'Grep Open Buffers' })

-- Live grep (Snacks)
map('n', '<leader>fg', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.grep { prompt = 'Search> ', live = true }
  end
end, { desc = 'Live Grep' })

-- mini.pick grep current word
map('n', '<leader>sw', function()
  require('mini.pick').builtin.grep { pattern = vim.fn.expand '<cword>' }
end, { desc = 'Search current word' })

-- Buffer lines fuzzy
map('n', '<leader>/', "<CMD>Pick buf_lines scope='current'<CR>", { desc = 'Search buffer lines' })

-- Grep (Pick) global
map('n', '<leader>sG', function()
  vim.cmd('cd ' .. (vim.env.PWD or vim.fn.getcwd()))
  vim.cmd 'Pick grep_live'
end, { desc = 'Grep (cwd)' })

-- Grep (mini.pick) theo dir của file
map('n', '<leader>sg', function()
  local f = vim.api.nvim_buf_get_name(0)
  local dir = (f ~= '' and vim.fn.filereadable(f) == 1) and vim.fn.fnamemodify(f, ':h') or vim.fn.getcwd()
  require('mini.pick').builtin.grep_live(nil, { source = { cwd = dir } })
end, { desc = 'Grep (file dir or cwd)' })

-- Resume
map('n', '<leader>sr', '<CMD>Pick resume<CR>', { desc = 'Resume Pick' })
map('n', '<leader>sR', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.resume()
  end
end, { desc = 'Resume (Snacks)' })

-- History + registers + keymaps...
map('n', '<leader>s"', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.registers()
  end
end, { desc = 'Registers' })

map('n', '<leader>s/', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.search_history()
  end
end, { desc = 'Search History' })

map('n', '<leader>sa', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.autocmds()
  end
end, { desc = 'Autocmds' })

map('n', '<leader>sc', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.command_history()
  end
end, { desc = 'Command History' })

map('n', '<leader>sC', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.commands()
  end
end, { desc = 'Commands' })

map('n', '<leader>sd', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.diagnostics()
  end
end, { desc = 'Diagnostics' })

map('n', '<leader>sD', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.diagnostics_buffer()
  end
end, { desc = 'Buffer Diagnostics' })

map('n', '<leader>sh', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.help()
  else
    vim.cmd 'Pick help'
  end
end, { desc = 'Help' })

map('n', '<leader>sH', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.highlights()
  end
end, { desc = 'Highlights' })

map('n', '<leader>si', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.icons()
  end
end, { desc = 'Icons' })

map('n', '<leader>sj', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.jumps()
  end
end, { desc = 'Jumps' })

map('n', '<leader>sk', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.keymaps()
  end
end, { desc = 'Keymaps' })

map('n', '<leader>sl', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.loclist()
  end
end, { desc = 'Location List' })

map('n', '<leader>sM', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.man()
  end
end, { desc = 'Man Pages' })

map('n', '<leader>sm', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.marks()
  end
end, { desc = 'Marks' })

map('n', '<leader>sq', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.qflist()
  end
end, { desc = 'Quickfix List' })

map('n', '<leader>su', function()
  local Snacks = core.sr 'snacks'
  if Snacks then
    Snacks.picker.undo()
  end
end, { desc = 'Undo tree' })

-- <leader><leader> nhanh mở file theo dir hiện tại
map('n', '<leader><leader>', function()
  local f = vim.api.nvim_buf_get_name(0)
  local dir = (f ~= '' and vim.fn.filereadable(f) == 1) and vim.fn.fnamemodify(f, ':h') or vim.fn.getcwd()
  require('mini.pick').builtin.files(nil, { source = { cwd = dir } })
end, { desc = 'Files (buffer dir)' })
