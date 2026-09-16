local pack = require 'custom.pack'

-- [[ Autocomplete Engine ]]
--
-- Ported from lazy.nvim: `event = 'InsertEnter'` is dropped, plugins load
-- eagerly. `snippets.preset = 'mini_snippets'` comes from mini.nvim, so
-- mini.nvim is set up before this module in lua/plugins.lua.
pack.add {
  { src = pack.gh 'saghen/blink.cmp', version = vim.version.range '1.*' },
  pack.gh 'fang2hou/blink-copilot',
  pack.gh 'rafamadriz/friendly-snippets',
  pack.gh 'marcoSven/blink-cmp-yanky',
  -- pack.gh 'Kaiser-Yang/blink-cmp-git',
  -- pack.gh 'kristijanhusak/vim-dadbod-completion',
}

require('blink.cmp').setup {
  keymap = {
    preset = 'enter',
    ['<C-y>'] = { 'select_and_accept' },
  },
  appearance = {
    nerd_font_variant = 'mono',
    kind_icons = {
      Copilot = '',
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
  completion = {
    documentation = { auto_show = false, auto_show_delay_ms = 0 },
    ghost_text = { enabled = false },
    list = {
      selection = {
        preselect = true,
        auto_insert = false,
      },
    },
  },
  snippets = { preset = 'mini_snippets' },
  cmdline = {
    keymap = {
      ['<C-y>'] = { 'select_and_accept' },
    },
    completion = {
      menu = { auto_show = true },
      ghost_text = { enabled = false },
    },
  },
  sources = {
    -- compat = {},
    default = { 'lsp', 'snippets', 'path', 'buffer', 'copilot', 'yank', 'lazydev' }, --copilot, 'dadbod', 'avante', 'ripgrep''git',
    providers = {
      lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
      -- dadbod_grip = { name = 'Grip SQL', module = 'dadbod-grip.completion.blink' },
      copilot = {
        name = 'copilot',
        module = 'blink-copilot',
        async = true,
      },
      git = {
        module = 'blink-cmp-git',
        name = 'Git',
        opts = {},
      },
      yank = {
        name = 'yank',
        module = 'blink-yanky',
        opts = {
          minLength = 3,
          insert = true,
          onlyCurrentFiletype = false,
          trigger_characters = { '"' },
          kind_icon = '󰅍',
        },
      },
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
}

-- vim: ts=2 sts=2 sw=2 et
