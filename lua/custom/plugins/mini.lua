return { -- Collection of various small independent plugins/modules
  'nvim-mini/mini.nvim',
  config = function()
    -- require('mini.trailspace').setup {}
    -- require('mini.jump2d').setup {}

    -- require('mini.animate').setup {
    --   cursor = {
    --     enable = false, -- Bật hiệu ứng di chuyển con trỏ
    --   },
    -- }

    require('mini.extra').setup()
    require('mini.misc').setup()

    MiniMisc.setup_auto_root()

    MiniMisc.setup_restore_cursor()

    MiniMisc.setup_termbg_sync()

    require 'custom.mini.core'
  end,
}
