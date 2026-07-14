vim.opt_local.conceallevel = 2

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
      date_format = '%Y-%m-%d-%a',
      time_format = '%H:%M',
    },
    note_id_func = function(title)
      if title == nil or vim.trim(title) == '' then
        return tostring(os.time())
      end

      return vim.trim(title):gsub('[/\\:*?"<>|]', '-')
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
      '<cr>',
      '<cmd>Obsidian follow_link<cr>',
      desc = 'follow link',
    },
    {
      '<backspace>',
      '<cmd>Obsidian backlinks<cr>',
      desc = 'backlinks',
    },
    {
      '<m-cr>',
      '<cmd>Obsidian backlinks<cr>',
      desc = 'backlinks',
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
  },
}
