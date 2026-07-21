local M = function()
  -- MiniBracketed Keybindings:
  -- [B` `[b` `]b` `]B` - Buffer
  -- [C` `[c` `]c` `]C` - Comment block
  -- [X` `[x` `]x` `]X` - Conflict marker
  -- [D` `[d` `]d` `]D` - Diagnostic
  -- [F` `[f` `]f` `]F` - File on disk
  -- [I` `[i` `]i` `]I` - Indent change
  -- [J` `[j` `]j` `]J` - Jump inside current buffer
  -- [L` `[l` `]l` `]L` - Location from location-list
  -- [O` `[o` `]o` `]O` - Old files
  -- [Q` `[q` `]q` `]Q` - Quickfix entry
  -- [T` `[t` `]t` `]T` - Tree-sitter node and parents
  -- [U` `[u` `]u` `]U` - Undo states
  -- [W` `[w` `]w` `]W` - Window in current tab
  -- [Y` `[y` `]y` `]Y` - Yank selection replacing latest put region
  require('mini.bracketed').setup()
end

return M
