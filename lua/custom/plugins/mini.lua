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

    require 'custom.mini.core'
  end,
}
