local map = vim.keymap.set

-- map('n', '<leader>sb', function()
--   local Snacks = require 'snacks'
--   Snacks.picker.lines()
-- end, { desc = 'Buffer Lines' })

-- map('n', '<leader>sB', function()
--   local Snacks = require 'snacks'
--   Snacks.picker.grep_buffers()
-- end, { desc = 'Grep Open Buffers' })

-- map('n', '<leader>sp', function()
--   local Snacks = require 'snacks'
--   Snacks.picker.lazy()
-- end, { desc = 'Search for Plugin Spec' })

-- map('n', '<leader>s"', function()
--   local Snacks = require 'snacks'
--   Snacks.picker.registers()
-- end, { desc = 'Registers' })

-- map('n', '<leader>sa', function()
--   local Snacks = require 'snacks'
--   Snacks.picker.autocmds()
-- end, { desc = 'Autocmds' })

-- map('n', '<leader>sc', function()
--   local Snacks = require 'snacks'
--   Snacks.picker.command_history()
-- end, { desc = 'Command History' })

-- map('n', '<leader>sh', function()
--   local Snacks = require 'snacks'
--   Snacks.picker.help()
-- end, { desc = 'Help Pages' })

-- map('n', '<leader>sH', function()
--   local Snacks = require 'snacks'
--   Snacks.picker.highlights()
-- end, { desc = 'Highlights' })

-- map('n', '<leader>sl', function()
--   local Snacks = require 'snacks'
--   Snacks.picker.loclist()
-- end, { desc = 'Location List' })

-- map('n', '<leader>sq', function()
--   local Snacks = require 'snacks'
--   Snacks.picker.qflist()
-- end, { desc = 'Quickfix List' })

map('n', '<leader>s/', function()
  local Snacks = require 'snacks'
  Snacks.picker.search_history()
end, { desc = 'Search History' })

map('n', '<leader>sc', function()
  local Snacks = require 'snacks'
  Snacks.picker.commands()
end, { desc = 'Commands' })

map('n', '<leader>sD', function()
  local Snacks = require 'snacks'
  Snacks.picker.diagnostics()
end, { desc = 'Diagnostics' })

map('n', '<leader>sd', function()
  local Snacks = require 'snacks'
  Snacks.picker.diagnostics_buffer()
end, { desc = 'Buffer Diagnostics' })

map('n', '<leader>si', function()
  local Snacks = require 'snacks'
  Snacks.picker.icons()
end, { desc = 'Icons' })

map('n', '<leader>sj', function()
  local Snacks = require 'snacks'
  Snacks.picker.jumps()
end, { desc = 'Jumps' })

map('n', '<leader>sk', function()
  local Snacks = require 'snacks'
  Snacks.picker.keymaps()
end, { desc = 'Keymaps' })

map('n', '<leader>sM', function()
  local Snacks = require 'snacks'
  Snacks.picker.man()
end, { desc = 'Man Pages' })

map('n', '<leader>sm', function()
  local Snacks = require 'snacks'
  Snacks.picker.marks()
end, { desc = 'Marks' })

map('n', '<leader>sR', function()
  local Snacks = require 'snacks'
  Snacks.picker.resume()
end, { desc = 'Resume' })

map('n', '<leader>su', function()
  local Snacks = require 'snacks'
  Snacks.picker.undo()
end, { desc = 'Undotree' })

map('n', '<leader>ss', function()
  local Snacks = require 'snacks'
  Snacks.picker.lsp_symbols()
end, { desc = 'LSP Symbols' })

map('n', '<leader>sS', function()
  local Snacks = require 'snacks'
  Snacks.picker.lsp_workspace_symbols()
end, { desc = 'LSP Workspace Symbols' })
