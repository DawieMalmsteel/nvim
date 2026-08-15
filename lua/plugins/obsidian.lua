-- Obsidian.nvim: plugin config + custom logic (daily activity log).
--
-- Structure:
--   1. Constants, vault paths, vim-wired activity `deps`
--   2. rename_linked_note keymap helper
--   3. Activity log autocmd: append "HH:MM [[note]]" to Dailies/<day>.md on save.
--      All logic lives in lua/obsidian/activity.lua (pure + injectable); this
--      file only supplies the real vim/filesystem/time binding (`deps`).
--   4. Plugin spec (opts + keys)

local VAULT = '~/funthings/notes'
local VAULT_ROOT = vim.fn.fnamemodify(vim.fn.expand(VAULT), ':p'):gsub('/$', '')
local DAILY_DIR = VAULT_ROOT .. '/Dailies'
local DAILY_TEMPLATE = VAULT_ROOT .. '/Templates/Daily.md'
local ISO_TIMESTAMP = '%Y-%m-%dT%H:%M:%S'
local DAY_FORMAT = '%d-%m-%Y'
local TIME_FORMAT = '%H:%M'
local IGNORED_ACTIVITY_FOLDERS = {
  Dailies = true,
  Templates = true,
  bases = true,
}

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
-- Activity log
-- ============================================================

-- Return the bufnr of an open, loaded buffer whose file path equals `path`, or nil.
local function buffer_for(path)
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':p')
      if name == path then
        return bufnr
      end
    end
  end
end

-- vim-backed implementation of the `deps` table consumed by activity.append.
-- Buffer-aware so unsaved edits in an open daily note are both seen (dedup)
-- and kept on write, and the buffer never goes stale.
local deps = {
  root = VAULT_ROOT,
  daily_dir = DAILY_DIR,
  day_format = DAY_FORMAT,
  iso_format = ISO_TIMESTAMP,
  time_format = TIME_FORMAT,
  ignored = IGNORED_ACTIVITY_FOLDERS,
  read_daily = function(path)
    local bufnr = buffer_for(path)
    if bufnr then
      return vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    end
    if vim.fn.filereadable(path) == 1 then
      return vim.fn.readfile(path)
    end
  end,
  write_daily = function(path, lines)
    local bufnr = buffer_for(path)
    if bufnr then
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd 'write'
      end)
    else
      vim.fn.writefile(lines, path)
    end
  end,
  read_template = function()
    if vim.fn.filereadable(DAILY_TEMPLATE) == 1 then
      return vim.fn.readfile(DAILY_TEMPLATE)
    end
  end,
  ensure_daily_dir = function()
    vim.fn.mkdir(DAILY_DIR, 'p')
  end,
}

local activity_group = vim.api.nvim_create_augroup('ObsidianDailyActivity', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  group = activity_group,
  callback = function(args)
    activity.append(deps, vim.fn.fnamemodify(args.file, ':p'), os.date)
  end,
})

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
      date_format = 'YYYY-MM-DDTHH:mm:ss',
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
      date_format = 'DD-MM-YYYY',
      template = 'Daily.md',
    },

    -- Keep frontmatter portable and maintain only fields that are useful to the vault.
    -- In particular, do not inject id/aliases into every note.
    frontmatter = {
      enabled = true,
      sort = FRONTMATTER_SORT,
      func = function(note)
        local metadata = vim.deepcopy(note.metadata or {})

        metadata.created_day = activity.normalize_day(metadata.created_day) or os.date(ISO_TIMESTAMP)
        metadata.updated_day = os.date(ISO_TIMESTAMP)

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
  },
}
