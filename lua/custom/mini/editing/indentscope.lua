local M = function()
  require('mini.indentscope').setup {
    mappings = {
      object_scope = 'ii', -- Select the inner scope of the current block
      object_scope_with_border = 'ai', -- Select the entire scope including its borders
      goto_top = '[i', -- Jump to the top border line of the current scope
      goto_bottom = ']i', -- Jump to the bottom border line of the current scope
    },
    symbol = ' ', -- │
    options = { try_as_border = true },
    draw = {
      delay = 20,
    },
  }
end
return M
