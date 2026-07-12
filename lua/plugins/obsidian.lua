vim.opt_local.conceallevel = 2
return {
  'obsidian-nvim/obsidian.nvim',
  version = '*', -- use latest release, remove to use latest commit
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false, -- this will be removed in 4.0.0
    workspaces = {
      {
        name = 'work',
        path = '~/funthings/',
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
}
