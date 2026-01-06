local M = function()
  require('mini.misc').setup()

  MiniMisc.setup_auto_root()

  MiniMisc.setup_restore_cursor()

  MiniMisc.setup_termbg_sync()

  local map = vim.keymap.set

  map('n', '<leader>zz', function()
    local Mini = require 'mini.misc'
    Mini.zoom()
  end, { desc = 'Toggle Zoom Mode' })

  map('n', '<leader>zr', function()
    local Mini = require 'mini.misc'
    Mini.resize_window()
  end, { desc = 'Resize window' })
end
return M
