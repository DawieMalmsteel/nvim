return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    views = {
      cmdline_popup = {
        border = {
          style = 'none',
          padding = { 1, 2 },
        },
        position = {
          row = 15,
          col = '50%',
        },
        size = {
          width = 60,
          height = 'auto',
        },
        win_options = {
          winhighlight = { NormalFloat = 'NormalFloat' },
        },
      },
      popupmenu = {
        relative = 'editor',
        position = {
          row = 3,
          col = '50%',
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = 'none',
          padding = { 1, 2 },
        },
      },
    },

    -- hide the search count message
    -- routes = {
    --   {
    --     filter = {
    --       event = 'msg_show',
    --       kind = 'search_count',
    --     },
    --     opts = { skip = true },
    --   },
    -- },

    cmdline = {
      format = {
        replace = {
          conceal = false,
          pattern = '^:s/',
          icon = ' ',
          lang = 'regex',
          view = 'cmdline',
        },
        replace_all = {
          conceal = false,
          pattern = '^:%%s/',
          icon = ' 󰬳',
          lang = 'regex',
          view = 'cmdline',
        },
      },
    },
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
}
