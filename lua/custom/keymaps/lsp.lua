local map = vim.keymap.set

-- LSP keymaps
map('n', 'grd', function()
  local mini_extra = require 'mini.extra'
  mini_extra.pickers.lsp { scope = 'definition' }
end, { desc = '[G]o to [D]efinition' })

map('n', 'gri', function()
  local mini_extra = require 'mini.extra'
  mini_extra.pickers.lsp { scope = 'implementation' }
end, { desc = '[G]oto [I]mplementation' })

map('n', 'grr', function()
  local mini_extra = require 'mini.extra'
  mini_extra.pickers.lsp { scope = 'references' }
end, { desc = '[G]oto [R]eferences' })

map('n', 'grD', function()
  local mini_extra = require 'mini.extra'
  mini_extra.pickers.lsp { scope = 'declaration' }
end, { desc = '[G]oto [D]eclaration' })

map('n', 'gO', function()
  local mini_extra = require 'mini.extra'
  mini_extra.pickers.lsp { scope = 'document_symbol' }
end, { desc = 'Open Document Symbols' })

map('n', 'gW', function()
  local mini_extra = require 'mini.extra'
  mini_extra.pickers.lsp { scope = 'workspace_symbol' }
end, { desc = 'Open Workspace Symbols' })

map('n', 'grt', function()
  local mini_extra = require 'mini.extra'
  mini_extra.pickers.lsp { scope = 'type_definition' }
end, { desc = '[G]oto [T]ype Definition' })

map('n', 'grN', function()
  local Snacks = require 'snacks'
  Snacks.rename.rename_file()
end, { desc = 'Rename current file with mini.files' })
