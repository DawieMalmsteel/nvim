local M = function()
  -- Add/delete/replace surroundings (brackets, quotes, etc.)

  -- Keymap descriptions
  local map = vim.keymap.set
  map({ 'n', 'v' }, 'sa', '', { desc = 'Add Surrounding' })
  map('n', 'sd', '', { desc = 'Delete Surrounding' })
  map('n', 'sf', '', { desc = 'Find Right Surrounding' })
  map('n', 'sF', '', { desc = 'Find Left Surrounding' })
  map('n', 'sh', '', { desc = 'Highlight Surrounding' })
  map('n', 'sr', '', { desc = 'Replace Surrounding' })
  map('n', 'sn', '', { desc = 'Update `MiniSurround.config.n_lines`' })

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
