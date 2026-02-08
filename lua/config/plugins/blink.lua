return {
  'saghen/blink.cmp',
  event = 'VimEnter',
  version = '1.*',
  -- specs = { 'Kaiser-Yang/blink-cmp-avante' },
  dependencies = {
    -- 'giuxtaposition/blink-cmp-copilot',
    'rafamadriz/friendly-snippets',
    'folke/lazydev.nvim',
    -- 'kristijanhusak/vim-dadbod-completion',
    {
      'saghen/blink.compat',
      optional = true, -- make optional so it's only enabled if any extras need it
      opts = {},
    },
    {
      -- 'mikavilpas/blink-ripgrep.nvim',
      -- version = '*', -- use the latest stable version
    },
  },
  opts = {
    keymap = {
      preset = 'enter',
      ['<C-y>'] = { 'select_and_accept' },
    },
    appearance = { nerd_font_variant = 'mono' },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 0 },
      ghost_text = { enabled = vim.g.ai_cmp },
    },
    snippets = { preset = 'mini_snippets' },
    cmdline = {
      keymap = { preset = 'default' },
      completion = {
        menu = { auto_show = true },
        ghost_text = { enabled = true },
      },
    },
    sources = {
      compat = {},
      default = { 'lsp', 'snippets', 'path', 'buffer', 'lazydev' }, --copilot, 'dadbod', 'avante', 'ripgrep'
      providers = {
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        -- ripgrep = {
        --   module = 'blink-ripgrep',
        --   name = 'Ripgrep',
        --   -- see the full configuration below for all available options
        --   ---@module "blink-ripgrep"
        --   ---@type blink-ripgrep.Options
        --   opts = {},
        -- },
        -- avante = { module = 'blink-cmp-avante', name = 'Avante' },
        -- dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink },
        -- copilot = {
        --   name = 'copilot',
        --   module = 'blink-cmp-copilot',
        --   score_offset = 100,
        --   async = true,
        --   transform_items = function(_, items)
        --     local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
        --     local kind_idx = #CompletionItemKind + 1
        --     CompletionItemKind[kind_idx] = 'Copilot'
        --     for _, item in ipairs(items) do
        --       item.kind = kind_idx
        --     end
        --     return items
        --   end,
        -- },
      },
      appearance = {
        kind_icons = {
          Copilot = '',
          Text = '󰉿',
          Method = '󰊕',
          Function = '󰊕',
          Constructor = '󰒓',
          Field = '󰜢',
          Variable = '󰆦',
          Property = '󰖷',
          Class = '󱡠',
          Interface = '󱡠',
          Struct = '󱡠',
          Module = '󰅩',
          Unit = '󰪚',
          Value = '󰦨',
          Enum = '󰦨',
          EnumMember = '󰦨',
          Keyword = '󰻾',
          Constant = '󰏿',
          Snippet = '󱄽',
          Color = '󰏘',
          File = '󰈔',
          Reference = '󰬲',
          Folder = '󰉋',
          Event = '󱐋',
          Operator = '󰪚',
          TypeParameter = '󰬛',
        },
      },
    },
    fuzzy = {
      implementation = 'rust',
      -- sorts = {
      --   'exact',
      --   'label', -- Primary sort: by label if still tied
      --   'sort_text', -- Secondary sort: by sortText field if scores are equal
      --   'score', -- Tertiary sort: by fuzzy matching score
      -- },
    },
    signature = { enabled = true },
  },
}
