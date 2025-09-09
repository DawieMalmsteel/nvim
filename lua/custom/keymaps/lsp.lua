local core = require 'custom.keymaps.core'
local map = core.map

-- LSP picker scopes (mini.extra)
local scopes = {
  grd = { 'definition', '[G]oto [D]efinition' },
  gri = { 'implementation', '[G]oto [I]mplementation' },
  grr = { 'references', '[G]oto [R]eferences' },
  grD = { 'declaration', '[G]oto [D]eclaration' },
  gO = { 'document_symbol', 'Document Symbols' },
  gW = { 'workspace_symbol', 'Workspace Symbols' },
  grt = { 'type_definition', '[G]oto [T]ype Definition' },
}

for lhs, spec in pairs(scopes) do
  map('n', lhs, core.lsp_scope(spec[1]), { desc = spec[2] })
end
