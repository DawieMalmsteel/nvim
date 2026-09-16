local pack = require 'custom.pack'

-- [[ todo-comments.nvim ]]
pack.add {
  pack.gh 'folke/todo-comments.nvim',
  pack.gh 'nvim-lua/plenary.nvim',
}

require('todo-comments').setup {
  signs = false,
  keywords = {
    FIX = {
      icon = ' ', -- icon used for the sign, and in search results
      color = '#F5C2E7', -- can be a hex color, or a named color (see below)
      alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' }, -- a set of other keywords that all map to this FIX keywords
      -- signs = false, -- configure signs for some keywords individually
    },
    TODO = { icon = '󰄵 ', color = 'info' },
    HACK = { icon = ' ', color = 'warning' },
    WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
    ERROR = { icon = ' ', color = 'error', alt = { 'ERROR' } },
    PERF = { icon = '󰔟 ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE', 'PERF' } },
    NOTE = { icon = '󰦪 ', color = 'hint', alt = { 'INFO' } },
    TEST = { icon = '󰊖 ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
  },
}

-- vim: ts=2 sts=2 sw=2 et
