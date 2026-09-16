local pack = require 'custom.pack'

-- [[ colorful-menu.nvim ]]
-- Blink.cmp menu labels with per-item highlighting. This merges extra
-- `completion.menu.draw` settings into the blink.cmp config, so it runs after
-- the blink.cmp setup in lua/custom/plugins/blink.lua.
pack.add { pack.gh 'xzbdmw/colorful-menu.nvim' }

require('blink.cmp').setup {
  completion = {
    menu = {
      draw = {
        -- We don't need label_description now because label and label_description are already
        -- combined together in label by colorful-menu.nvim.
        columns = { { 'kind_icon' }, { 'label', gap = 1 } },
        components = {
          label = {
            text = function(ctx)
              return require('colorful-menu').blink_components_text(ctx)
            end,
            highlight = function(ctx)
              return require('colorful-menu').blink_components_highlight(ctx)
            end,
          },
        },
      },
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
