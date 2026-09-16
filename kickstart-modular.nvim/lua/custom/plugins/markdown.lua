local pack = require 'custom.pack'

-- [[ render-markdown.nvim ]]
pack.add { pack.gh 'MeanderingProgrammer/render-markdown.nvim' }

require('render-markdown').setup {
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
      return '' .. (''):rep(ctx.level)
    end,
  },
}

-- [[ Disabled plugins from the lazy.nvim config ]]
-- pack.add { pack.gh 'ice345/markdown-table-wrap.nvim' }
-- require('markdown-table-wrap').setup {}
--
-- "iamcco/markdown-preview.nvim" (disabled):
--   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" }
--   build downloads the app via vim.fn["mkdp#util#install"]()
--   keys: <leader>cp -> <cmd>MarkdownPreviewToggle<cr> (ft markdown)
--   config: vim.cmd([[do FileType]])

-- vim: ts=2 sts=2 sw=2 et
