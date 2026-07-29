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

local activity_group = vim.api.nvim_create_augroup('ObsidianDailyActivity', { clear = true })
local vault_root = vim.fn.fnamemodify(vim.fn.expand '~/funthings/notes', ':p'):gsub('/$', '')
local ignored_activity_folders = {
  Dailies = true,
  Templates = true,
  categories = true,
  Tags = true,
  Status = true,
}

local function daily_template_lines(day, timestamp)
  local template_path = vault_root .. '/Templates/Daily.md'
  if vim.fn.filereadable(template_path) == 1 then
    local lines = vim.fn.readfile(template_path)
    for index, line in ipairs(lines) do
      lines[index] = line:gsub('{{date:DD%-MM%-YYYY}}', day):gsub('{{date}}', timestamp)
    end
    return lines
  end

  return {
    '---',
    'categories: [daily]',
    'tags: []',
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

local function append_daily_activity(file_path)
  local absolute_path = vim.fn.fnamemodify(file_path, ':p')
  local relative_path = absolute_path:sub(#vault_root + 2)
  local folder = relative_path:match '^([^/]+)'

  if not absolute_path:match '%.md$' or ignored_activity_folders[folder] then
    return
  end

  local day = os.date '%d-%m-%Y'
  local timestamp = os.date '%Y-%m-%dT%H:%M:%S'
  local daily_path = vault_root .. '/Dailies/' .. day .. '.md'
  local note_name = vim.fn.fnamemodify(absolute_path, ':t:r')
  local lines

  if vim.fn.filereadable(daily_path) == 1 then
    lines = vim.fn.readfile(daily_path)
  else
    vim.fn.mkdir(vault_root .. '/Dailies', 'p')
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
    activity_heading = #lines - 1
  end

  table.insert(lines, activity_heading + 1, '- ' .. os.date '%H:%M' .. ' ' .. link)
  vim.fn.writefile(lines, daily_path)
end

vim.api.nvim_create_autocmd('BufWritePost', {
  group = activity_group,
  callback = function(args)
    append_daily_activity(args.file)
  end,
})

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
        name = 'work',
        path = '~/funthings/notes/',
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
      sort = {
        'categories',
        'tags',
        'status',
        'created_day',
        'updated_day',
        'created',
        'authors',
        'author',
        'rating',
        'started',
        'finished',
        'source',
      },
      func = function(note)
        local metadata = vim.deepcopy(note.metadata or {})
        local today = os.date '%Y-%m-%dT%H:%M:%S'

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

        metadata.created_day = normalize_day(metadata.created_day) or today
        metadata.updated_day = today

        -- Keep the tags property present even when it is empty.
        metadata.tags = note.tags or {}

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
    -- {
    --   '<m-cr>',
    --   '<cmd>Obsidian backlinks<cr>',
    --   desc = 'backlinks',
    -- },
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
