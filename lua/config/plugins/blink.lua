return {
  'saghen/blink.cmp',
  event = 'VimEnter',
  version = '1.*',
  dependencies = {
    'giuxtaposition/blink-cmp-copilot',
    'rafamadriz/friendly-snippets',
    'folke/lazydev.nvim',
    {
      'saghen/blink.compat',
      optional = true, -- make optional so it's only enabled if any extras need it
      opts = {},
    },
  },
  opts = {
    keymap = {
      preset = 'enter',
      ['<C-y>'] = { 'select_and_accept' },
      ['<Tab>'] = {
        'snippet_forward',
        function() -- sidekick next edit suggestion
          return require('sidekick').nes_jump_or_apply()
        end,
        function() -- if you are using Neovim's native inline completions
          return vim.lsp.inline_completion.get()
        end,
        'fallback',
      },
    },
    appearance = { nerd_font_variant = 'mono' },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 0 },
      ghost_text = { enabled = vim.g.ai_cmp },
    },
    snippets = { preset = 'mini_snippets' },
    cmdline = {
      keymap = { preset = 'inherit' },
      completion = {
        menu = { auto_show = true },
        completion = { ghost_text = { enabled = true } },
      },
    },
    sources = {
      compat = {},
      default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev', 'copilot' },
      providers = {
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        copilot = {
          name = 'copilot',
          module = 'blink-cmp-copilot',
          score_offset = 100,
          async = true,
          transform_items = function(_, items)
            local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
            local kind_idx = #CompletionItemKind + 1
            CompletionItemKind[kind_idx] = 'Copilot'
            for _, item in ipairs(items) do
              item.kind = kind_idx
            end
            return items
          end,
        },
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
    fuzzy = { implementation = 'prefer_rust' },
    signature = { enabled = true },
  },
  ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
  config = function(_, opts)
    -- setup compat sources
    local enabled = opts.sources.default
    for _, source in ipairs(opts.sources.compat or {}) do
      opts.sources.providers[source] = vim.tbl_deep_extend('force', { name = source, module = 'blink.compat.source' }, opts.sources.providers[source] or {})
      if type(enabled) == 'table' and not vim.tbl_contains(enabled, source) then
        table.insert(enabled, source)
      end
    end

    -- add ai_accept to <Tab> key
    if not opts.keymap['<Tab>'] then
      if opts.keymap.preset == 'super-tab' then -- super-tab
        opts.keymap['<Tab>'] = {
          require('blink.cmp.keymap.presets').get('super-tab')['<Tab>'][1],
          'fallback',
        }
      else -- other presets
        opts.keymap['<Tab>'] = {
          'fallback',
        }
      end
    end

    -- Unset custom prop to pass blink.cmp validation
    opts.sources.compat = nil

    -- check if we need to override symbol kinds
    for _, provider in pairs(opts.sources.providers or {}) do
      ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
      if provider.kind then
        local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
        local kind_idx = #CompletionItemKind + 1

        CompletionItemKind[kind_idx] = provider.kind
        ---@diagnostic disable-next-line: no-unknown
        CompletionItemKind[provider.kind] = kind_idx

        ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
        local transform_items = provider.transform_items
        ---@param ctx blink.cmp.Context
        ---@param items blink.cmp.CompletionItem[]
        provider.transform_items = function(ctx, items)
          items = transform_items and transform_items(ctx, items) or items
          for _, item in ipairs(items) do
            item.kind = kind_idx or item.kind
            item.kind_icon = item.kind_icon or nil
          end
          return items
        end

        -- Unset custom prop to pass blink.cmp validation
        provider.kind = nil
      end
    end

    require('blink.cmp').setup(opts)
  end,
}
