-- Obsidian.nvim: plugin config + custom logic (daily activity log).
--
-- Structure:
--   1. Constants & shared helpers (normalize_day, FRONTMATTER_SORT)
--   2. rename_linked_note keymap helper
--   3. Activity log: append "HH:MM [[note]]" to Dailies/<day>.md on save
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

--- Normalize "YYYY-MM-DD" to "YYYY-MM-DDTHH:MM:SS"; pass ISO timestamps through.
local function normalize_day(value)
  if type(value) == 'string' then
    if value:match '^%d%d%d%d%-%d%d%-%d%dT%d%d:%d%d:%d%d$' then
      return value
    end

    local year, month, day = value:match '^(%d%d%d%d)%-(%d%d)%-(%d%d)$'
    if year then
      return string.format('%s-%s-%sT00:00:00', year, month, day)
    end
  end
  return value
end

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

local function daily_template_lines(day, timestamp)
  if vim.fn.filereadable(DAILY_TEMPLATE) == 1 then
    local lines = vim.fn.readfile(DAILY_TEMPLATE)
    for index, line in ipairs(lines) do
      lines[index] = line:gsub('{{date:DD%-MM%-YYYY}}', day):gsub('{{date}}', timestamp)
    end
    return lines
  end

  return {
    '---',
    'tags: [daily]',
    'created_day: ' .. timestamp,
    'updated_day: ' .. timestamp,
    '---',
    '',
    '# ' .. day,
    '',
    '## Activity',
    '',
  }
end

--- Read the daily note. If it is open in a buffer, read from the buffer so
--- unsaved edits are preserved (and seen by dedup); otherwise read from disk.
local function read_daily(daily_path)
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':p')
      if name == daily_path then
        return vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      end
    end
  end
  return vim.fn.readfile(daily_path)
end

--- Write lines to the daily note. If the note is open in a buffer, update the
--- buffer in place (keeping any unsaved edits) and write through it so the
--- buffer never goes stale; otherwise write to disk directly.
local function write_daily(lines, daily_path)
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':p')
      if name == daily_path then
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
        vim.api.nvim_buf_call(bufnr, function()
          vim.cmd 'write'
        end)
        return
      end
    end
  end
  vim.fn.writefile(lines, daily_path)
end

local function append_daily_activity(file_path)
  local absolute_path = vim.fn.fnamemodify(file_path, ':p')

  -- Only handle markdown files inside the vault.
  if not absolute_path:match '%.md$' or absolute_path:sub(1, #VAULT_ROOT) ~= VAULT_ROOT then
    return
  end

  local relative_path = absolute_path:sub(#VAULT_ROOT + 2)
  local folder = relative_path:match '^([^/]+)'

  if IGNORED_ACTIVITY_FOLDERS[folder] then
    return
  end

  local day = os.date(DAY_FORMAT)
  local timestamp = os.date(ISO_TIMESTAMP)
  local daily_path = DAILY_DIR .. '/' .. day .. '.md'
  local note_name = vim.fn.fnamemodify(absolute_path, ':t:r')
  local lines

  if vim.fn.filereadable(daily_path) == 1 then
    lines = read_daily(daily_path)
  else
    vim.fn.mkdir(DAILY_DIR, 'p')
    lines = daily_template_lines(day, timestamp)
  end

  local link = '[[' .. note_name .. ']]'
  for _, line in ipairs(lines) do
    if line:find(link, 1, true) then
      return
    end
  end

  local activity_heading
  for index, line in ipairs(lines) do
    if line == '## Activity' then
      activity_heading = index
      break
    end
  end

  if activity_heading == nil then
    lines[#lines + 1] = ''
    lines[#lines + 1] = '## Activity'
    activity_heading = #lines
  end

  table.insert(lines, activity_heading + 1, '- ' .. os.date(TIME_FORMAT) .. ' ' .. link)
  write_daily(lines, daily_path)
end

local activity_group = vim.api.nvim_create_augroup('ObsidianDailyActivity', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  group = activity_group,
  callback = function(args)
    append_daily_activity(args.file)
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

        metadata.created_day = normalize_day(metadata.created_day) or os.date(ISO_TIMESTAMP)
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
