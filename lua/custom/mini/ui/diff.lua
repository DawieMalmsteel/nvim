local M = function()
  require('mini.diff').setup {
    view = {
      style = 'sign',
    },
    mappings = {
      goto_first = '[G',
      goto_prev = '[g',
      goto_next = ']g',
      goto_last = ']G',
    },
  }
end
return M
