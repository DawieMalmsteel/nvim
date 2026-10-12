-- Obsidian.nvim: plugin config.
--
-- Structure:
--   1. Constants
--   2. rename_linked_note keymap helper
--   3. Plugin spec (opts + keys)

local VAULT = '~/funthings/notes'
local TIMESTAMP_FORMAT = '%Y-%m-%d %H:%M'

local activity = require 'obsidian.activity'

-- Property order for every frontmatter rewrite.
local FRONTMATTER_SORT = {
  'tags',
  'status',
  'book',
  'created_day',
  'updated_day',
  'authors',
  'author',
  'rating',
  'started',
  'finished',
  'source',
}

local function rename_linked_note()
  local api = require 'obsidian.api'
  local link = api.cursor_link()

  if link == nil then
    vim.notify('Obsidian: con trỏ không nằm trên link, đã hủy rename để tránh đổi tên note hiện tại', vim.log.levels.WARN)
    return
  end

  vim.lsp.buf.rename(nil, {
    name = 'obsidian-ls',
    bufnr = 0,
  })
end

-- ============================================================
-- Plugin spec
-- ============================================================

return {
  'obsidian-nvim/obsidian.nvim',
  version = '*', -- use latest release, remove to use latest commit
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    picker = {
      name = 'snacks.picker',
    },
    legacy_commands = false, -- this will be removed in 4.0.0
    workspaces = {
      {
        name = 'notes',
        path = VAULT,
      },
    },
    templates = {
      folder = 'Templates',
      date_format = 'YYYY-MM-DD HH:mm',
      time_format = 'HH:mm',
      substitutions = {},
    },

    -- `:Obsidian new` starts from this portable, neutral template.
    -- Use `new_from_template` for book/concept/daily-specific schemas.
    note = {
      template = 'Note.md',
    },

    daily_notes = {
      folder = 'Dailies',
      date_format = 'YYYY-MM-DD',
      template = 'Daily.md',
    },

    -- Keep frontmatter portable and maintain only fields that are useful to the vault.
    -- In particular, do not inject id/aliases into every note.
    frontmatter = {
      enabled = true,
      sort = FRONTMATTER_SORT,
      func = function(note)
        local metadata = vim.deepcopy(note.metadata or {})

        metadata.created_day = activity.normalize_day(metadata.created_day) or os.date(TIMESTAMP_FORMAT)
        metadata.updated_day = os.date(TIMESTAMP_FORMAT)

        -- NOTE: Frontmatter.parse strips validated keys (tags/aliases/id) out
        -- of note.metadata into note.tags / note.aliases. Reading them from
        -- metadata would silently drop them on every frontmatter rewrite
        -- (save, rename, ...). Merge them back from the note instead.
        if note.tags and #note.tags > 0 then
          metadata.tags = vim.deepcopy(note.tags)
        end

        -- Keep the tags property present even when it is empty.
        metadata.tags = metadata.tags or {}

        return metadata
      end,
    },
    note_id_func = function(title)
      if title == nil or vim.trim(title) == '' then
        return tostring(os.time())
      end

      local id = vim.trim(title):gsub('[/\\:*?"<>|]', ' ')
      return id
    end,

    ui = {
      enable = false,
    },
  },

  keys = {
    {
      '<C-p>',
      '<cmd>Obsidian quick_switch<cr>',
      desc = 'Quick Switch',
    },
    {
      '<m-cr>',
      '<cmd>Obsidian follow_link<cr>',
      desc = 'follow link',
    },
    {
      '<backspace>',
      '<cmd>Obsidian backlinks<cr>',
      ft = { 'markdown' },
      desc = 'backlinks',
    },
    {
      '<c-n>',
      '<cmd>Obsidian new<cr>',
      desc = 'obsidian new note',
    },
    {
      '<m-p>',
      '<cmd>Obsidian paste_img<cr>',
      desc = 'paste image',
    },
    {
      '<leader>rn',
      rename_linked_note,
      desc = 'Rename linked note',
    },
    {
      '<leader>od',
      '<cmd>Obsidian dailies<cr>',
      desc = 'Open daily notes',
    },
    {
      '<leader>ot',
      '<cmd>Obsidian tags<cr>',
      desc = 'Open tags',
    },
  },
}
