local M = function()
  -- Add/delete/replace surroundings (brackets, quotes, etc.)

  -- Keymap descriptions
  local map = vim.keymap.set
  map({ 'n', 'v' }, 'gsa', '', { desc = 'Add Surrounding' })
  map('n', 'gsd', '', { desc = 'Delete Surrounding' })
  map('n', 'gsf', '', { desc = 'Find Right Surrounding' })
  map('n', 'gsF', '', { desc = 'Find Left Surrounding' })
  map('n', 'gsh', '', { desc = 'Highlight Surrounding' })
  map('n', 'gsr', '', { desc = 'Replace Surrounding' })
  map('n', 'gsn', '', { desc = 'Update `MiniSurround.config.n_lines`' })

  require('mini.surround').setup {
    highlight_duration = 100,
    mappings = {
      add = 'gsa', -- Add surrounding in Normal and Visual modes
      delete = 'gsd', -- Delete surrounding
      find = 'gsf', -- Find surrounding (to the right)
      find_left = 'gsF', -- Find surrounding (to the left)
      highlight = 'gsh', -- Highlight surrounding
      replace = 'gsr', -- Replace surrounding
      update_n_lines = 'gsn', -- Update `n_lines`
    },
  }
end

return M
