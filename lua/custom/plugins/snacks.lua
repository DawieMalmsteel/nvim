return {
  {
    'folke/snacks.nvim',
    opts = {
      picker = {},
      statuscolumn = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      words = { enabled = true },
      indent = {
        enabled = true,
        scope = {
          enabled = true, -- enable highlighting the current scope
          priority = 200,
          char = '│',
          underline = true, -- underline the start of the scope
          only_current = true, -- only show scope in the current window
        },
        chunk = {
          enabled = true,
          only_current = true,
          char = {
            corner_top = '╭',
            corner_bottom = '╰',
            horizontal = '─',
            vertical = '│',
            arrow = '>',
          },
        },
      },
      dashboard = {
        enabled = true, -- disable the dashboard by default
        width = 80,
        row = nil, -- dashboard position. nil for center
        col = nil, -- dashboard position. nil for center
        pane_gap = 4, -- empty columns between vertical panes
        autokeys = '1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', -- autokey sequence
        -- These settings are used by some built-in sections
        preset = {
          -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
          ---@type fun(cmd:string, opts:table)|nil
          pick = nil,
          -- Used by the `keys` section to show keymaps.
          -- Set your custom keymaps here.
          -- When using a function, the `items` argument are the default keymaps.
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = ' ', key = 'f', desc = 'Find File', action = ':Pick files' },
            { icon = '', key = 'n', desc = 'New File', action = ':ene | startinsert' },
            { icon = ' ', key = 'g', desc = 'Find Text', action = ':Pick grep_live' },
            { icon = ' ', key = 'r', desc = 'Recent Files', action = ':Pick oldfiles' },
            {
              icon = ' ',
              key = 'c',
              desc = 'Config',
              action = ":lua require('mini.pick').builtin.files(nil, { source = { cwd = vim.fn.stdpath 'config' } })",
            },
            {
              icon = '',
              key = 's',
              desc = 'Session load latest',
              action = ":lua require('mini.sessions').read(nil, { force = true })",
            },
            {
              icon = ' ',
              key = 'p',
              desc = 'Projects',
              action = function()
                local roots = { '~/Projects', '~/Projects-to-plays', '~/Playground' }
                local projects = {}
                for _, dir in ipairs(roots) do
                  local abs_dir = vim.fn.expand(dir)
                  local handle = vim.loop.fs_scandir(abs_dir)
                  if handle then
                    while true do
                      local name, t = vim.loop.fs_scandir_next(handle)
                      if not name then
                        break
                      end
                      if t == 'directory' then
                        table.insert(projects, abs_dir .. '/' .. name)
                      end
                    end
                  end
                end
                require('mini.pick').start {
                  source = { name = 'Projects', items = projects },
                  action = function(path)
                    vim.cmd('tabnew ' .. path)
                  end,
                }
              end,
            },
            { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
            { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
          },

          header = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡀⠀
⢀⣀⣀⡀⠀⣀⡀⠀⡀⠀⠀⣀⠀⠀⠀⣀⠀⠀⢠⡘⣇⣤⣄⠀⢀⡤⣄⢀⣼⣤⡄⠈⣹⠟⠀
⠀⠿⠁⠻⠐⢧⡽⠃⠳⠿⢷⠏⠀⠀⠀⠸⠾⠷⠟⠀⠟⠁⠻⠀⠿⠶⠻⠄⠸⠇⠀⠀⣡⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
        @NeoVim của Dwcks 🦀        ]],
        },

        sections = {
          {
            { section = 'header' },
            { icon = ' ', title = 'Keymaps', section = 'keys', indent = 2, padding = 1, layout = 'vertical' },
            -- { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
            { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
            { section = 'startup' },
          },
        },
      },
    },
  },
}
