local M = function()
  require('mini.surround').setup {
    highlight_duration = 1000,
    mappings = {
      add = 'sa', -- Add surrounding in Normal and Visual modes
      delete = 'sd', -- Delete surrounding
      find = 'sf', -- Find surrounding (to the right)
      find_left = 'sF', -- Find surrounding (to the left)
      highlight = 'sh', -- Highlight surrounding
      replace = 'sr', -- Replace surrounding
      update_n_lines = 'sn', -- Update `n_lines`

      -- default
      -- suffix_last = 'l', -- Suffix to search with "prev" method
      -- suffix_next = 'n', -- Suffix to search with "next" method
    },
  }
end

return M
