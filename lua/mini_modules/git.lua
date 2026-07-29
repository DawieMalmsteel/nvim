local M = function()
  require('mini.git').setup {
    signs = {
      add = { text = '┃' },
      change = { text = '┃' },
      delete = { text = '▁' },
    },
  }
end
return M
