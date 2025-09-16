return {
  {
    'folke/snacks.nvim',
    opts = {
      picker = {
        previewers = {
          git = {
            native = true,
            args = { '-c', 'delta.line-numbers=false', '-c', 'delta.side-by-side=false' },
          },
        },
      },
      statuscolumn = { enabled = true },
      image = { enabled = true },
      -- Centered floating input
      input = {
        enabled = true,
        win = {
          relative = 'editor',
          style = 'minimal',
          border = 'rounded',
          width = 60,
          height = 1,
          row = math.floor((vim.o.lines - 1) / 2.2),
          -- center vertically
          col = math.floor((vim.o.columns - 60) / 2), -- center horizontally
          title = ' Input ',
        },
      },
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = false },
      scroll = { enabled = false },
      words = { enabled = true },
      indent = {
        enabled = false,
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
          keys = {},

          -- header = [[
          -- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡀⠀
          -- ⢀⣀⣀⡀⠀⣀⡀⠀⡀⠀⠀⣀⠀⠀⠀⣀⠀⠀⢠⡘⣇⣤⣄⠀⢀⡤⣄⢀⣼⣤⡄⠈⣹⠟⠀
          -- ⠀⠿⠁⠻⠐⢧⡽⠃⠳⠿⢷⠏⠀⠀⠀⠸⠾⠷⠟⠀⠟⠁⠻⠀⠿⠶⠻⠄⠸⠇⠀⠀⣡⠀⠀
          -- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          --         @NeoVim của Dwcks 🦀        ]],
          -- header = [[
          --           |  \ \ | |/ /
          --           |  |\ `' ' /
          --           |  ;'aorta \      / , pulmonary
          --           | ;    _,   |    / / ,  arteries
          --  superior | |   (  `-.;_,-' '-' ,
          -- vena cava | `,   `-._       _,-'_
          --           |,-`.    `.)    ,<_,-'_, pulmonary
          --          ,'    `.   /   ,'  `;-' _,  veins
          --         ;        `./   /`,    \-'
          --         | right   /   |  ;\   |\
          --         | atrium ;_,._|_,  `, ' \
          --         |        \    \ `       `,
          --         `      __ `    \   left  ;,
          --          \   ,'  `      \,  ventricle
          --           \_(            ;,      ;;
          --           |  \           `;,     ;;
          --  inferior |  |`.          `;;,   ;'
          -- vena cava |  |  `-.        ;;;;,;'
          --           |  |    |`-.._  ,;;;;;'
          --           |  |    |   | ``';;;'
          --                   aorta                   ]],
          header = [[]],
        },

        sections = {
          {
            { section = 'header' },
            { pane = 2, icon = ' ', key = 'f', desc = 'Find File', action = ':Pick files' },
            { pane = 2, icon = '', key = 'n', desc = 'New File', action = ':ene | startinsert' },
            { pane = 2, icon = ' ', key = 'g', desc = 'Find Text', action = ':Pick grep_live' },
            { pane = 2, icon = ' ', key = 'r', desc = 'Recent Files', action = ':Pick oldfiles' },
            {
              pane = 2,
              icon = ' ',
              key = 'c',
              desc = 'Config',
              action = ":lua require('mini.pick').builtin.files(nil, { source = { cwd = vim.fn.stdpath 'config' } })",
            },
            {
              pane = 2,
              icon = '',
              key = 's',
              desc = 'Session restore (mini)',
              action = ':lua MiniSessions.read(nil, {})',
            },
            { pane = 2, icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
            { pane = 2, icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
            { pane = 2, icon = ' ', title = 'Keymaps', section = 'keys', indent = 2, padding = 1, layout = 'vertical' },
            { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
            { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
            {
              pane = 2,
              icon = ' ',
              title = 'Git Status',
              section = 'terminal',
              enabled = function()
                return Snacks.git.get_root() ~= nil
              end,
              cmd = 'git status --short --branch --renames',
              height = 5,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            },
            { section = 'startup' },
          },
        },
      },
    },
  },
}
