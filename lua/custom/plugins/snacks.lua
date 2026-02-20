return {
  {
    'folke/snacks.nvim',
    opts = {
      picker = {
        ui_select = true,
        layout = {
          select = {
            layout = 'ivy',
          },
          layout = {
            box = 'horizontal',
            backdrop = false,
            width = 0.8,
            height = 0.9,
            border = 'none',
            {
              box = 'vertical',
              { win = 'input', height = 1, border = true, title = '{title} {live} {flags}', title_pos = 'center' },
              { win = 'list', title = ' Results ', title_pos = 'center', border = true },
            },
            {
              win = 'preview',
              title = '{preview:Preview}',
              width = 0.5,
              border = true,
              title_pos = 'center',
            },
          },
        },
        previewers = {
          git = {
            native = true,
            args = { '-c', 'delta.line-numbers=false', '-c', 'delta.side-by-side=false' },
          },
        },
      },
      terminal = {
        win = {
          position = 'float',
        },
      },
      statuscolumn = {
        enabled = true,
        left = {
          'mark',
          'git',
        },
        right = {
          'sign',
          'fold',
        },
      }, -- ERROR:this make error with default nvim statuscolumn, disable it
      image = { enabled = true, doc = { inline = false } },
      -- Centered floating input
      input = {
        enabled = true,
        win = {
          relative = 'editor',
          style = 'minimal',
          border = 'rounded',
          width = 100,
          height = 1,
          row = math.floor((vim.o.lines - 1) / 2.2),
          -- center vertically
          col = math.floor((vim.o.columns - 100) / 2), -- center horizontally
          title = ' Input ',
        },
      },
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = false },
      scroll = { enabled = false },
      words = { enabled = true },
      zen = { enabled = true },
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
          enabled = false,
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
        preset = {
          pick = nil,
          keys = {},

          -- header = [[
          -- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡀⠀
          -- ⢀⣀⣀⡀⠀⣀⡀⠀⡀⠀⠀⣀⠀⠀⠀⣀⠀⠀⢠⡘⣇⣤⣄⠀⢀⡤⣄⢀⣼⣤⡄⠈⣹⠟⠀
          -- ⠀⠿⠁⠻⠐⢧⡽⠃⠳⠿⢷⠏⠀⠀⠀⠸⠾⠷⠟⠀⠟⠁⠻⠀⠿⠶⠻⠄⠸⠇⠀⠀⣡⠀⠀
          -- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          --         @NeoVim của Dwcks 🦀        ]],
          header = [[
                    |  \ \ | |/ /
                    |  |\ `' ' /
                    |  ;'aorta \      / , pulmonary
                    | ;    _,   |    / / ,  arteries
           superior | |   (  `-.;_,-' '-' ,
          vena cava | `,   `-._       _,-'_
                    |,-`.    `.)    ,<_,-'_, pulmonary
                   ,'    `.   /   ,'  `;-' _,  veins
                  ;        `./   /`,    \-'
                  | right   /   |  ;\   |\
                  | atrium ;_,._|_,  `, ' \
                  |        \    \ `       `,
                  `      __ `    \   left  ;,
                   \   ,'  `      \,  ventricle
                    \_(            ;,      ;;
                    |  \           `;,     ;;
           inferior |  |`.          `;;,   ;'
          vena cava |  |  `-.        ;;;;,;'
                    |  |    |`-.._  ,;;;;;'
                    |  |    |   | ``';;;'
                            aorta                   ]],
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
              -- action = ':lua MiniSessions.read(nil, {})',
              action = ':lua require("persistence").load()',
            },
            { pane = 2, icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
            { pane = 2, icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
            { pane = 2, icon = ' ', title = 'Keymaps', section = 'keys', indent = 2, padding = 1, layout = 'vertical' },
            { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
            { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
            { section = 'startup' },
          },
        },
      },
    },
    keys = {
      {
        'grI',
        function()
          Snacks.picker.lsp_incoming_calls()
        end,
        desc = 'C[a]lls Incoming',
      },
      {
        'grO',
        function()
          Snacks.picker.lsp_outgoing_calls()
        end,
        desc = 'C[a]lls Outgoing',
      },
    },
  },
}
