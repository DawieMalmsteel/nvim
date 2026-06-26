return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      render_modes = { 'n', 'no', 'c', 't', 'i', 'ic' },
      code = {
        sign = false,
        border = 'thin',
        position = 'left',
        width = 'block',
        above = '▁',
        below = '▔',
        language_left = '█',
        language_right = '█',
        language_border = '▁',
        left_pad = 1,
        right_pad = 1,
      },
      heading = {
        sign = false,
        width = 'block',
        backgrounds = {
          -- choose hlgroups where bg is the color you want your headings to be
          'MiniStatusLineModeVisual',
          'MiniStatusLineModeCommand',
          'MiniStatusLineModeReplace',
          'MiniStatusLineModeNormal',
          'MiniStatusLineModeOther',
          'MiniStatusLineModeInsert',
        },
        left_pad = 1,
        right_pad = 0,
        position = 'right',
        ---@param ctx render.md.heading.Context
        ---@return string?
        icons = function(ctx)
          -- return (''):rep(ctx.level) .. ''
          return '' .. (''):rep(ctx.level)
        end,
      },
    },
    ft = { 'markdown', 'Avante', 'codecompanion' },
  },
  -- {
  --   'ice345/markdown-table-wrap.nvim',
  --   ft = 'markdown',
  --   opts = {},
  -- },
}
