return {
  {
    'folke/snacks.nvim',
    opts = {
      picker = {},
      input = {
        enabled = true,
        backdrop = false,
        position = 'float',
        border = 'rounded',
        title_pos = 'center',
        height = 1,
        width = 60,
        -- relative = 'editor',
        -- noautocmd = true,
        -- row = 2,
        relative = 'cursor',
        row = -3,
        col = 0,
        wo = {
          winhighlight = 'NormalFloat:SnacksInputNormal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle',
          cursorline = false,
        },
        bo = {
          filetype = 'snacks_input',
          buftype = 'prompt',
        },
        --- buffer local variables
        b = {
          completion = false, -- disable blink completions in input
        },
        keys = {
          n_esc = { '<esc>', { 'cmp_close', 'cancel' }, mode = 'n', expr = true },
          i_esc = { '<esc>', { 'cmp_close', 'stopinsert' }, mode = 'i', expr = true },
          i_cr = { '<cr>', { 'cmp_accept', 'confirm' }, mode = { 'i', 'n' }, expr = true },
          i_tab = { '<tab>', { 'cmp_select_next', 'cmp' }, mode = 'i', expr = true },
          i_ctrl_w = { '<c-w>', '<c-s-w>', mode = 'i', expr = true },
          i_up = { '<up>', { 'hist_up' }, mode = { 'i', 'n' } },
          i_down = { '<down>', { 'hist_down' }, mode = { 'i', 'n' } },
          q = 'cancel',
        },
      },
      notifier = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
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

    keys = {
      -- Grep
      {
        '<leader>sb',
        function()
          Snacks.picker.lines()
        end,
        desc = 'Buffer Lines',
      },
      {
        '<leader>sB',
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = 'Grep Open Buffers',
      },
      {
        '<leader>sp',
        function()
          Snacks.picker.lazy()
        end,
        desc = 'Search for Plugin Spec',
      },
      -- search
      {
        '<leader>s"',
        function()
          Snacks.picker.registers()
        end,
        desc = 'Registers',
      },
      {
        '<leader>s/',
        function()
          Snacks.picker.search_history()
        end,
        desc = 'Search History',
      },
      {
        '<leader>sa',
        function()
          Snacks.picker.autocmds()
        end,
        desc = 'Autocmds',
      },
      {
        '<leader>sc',
        function()
          Snacks.picker.command_history()
        end,
        desc = 'Command History',
      },
      {
        '<leader>sC',
        function()
          Snacks.picker.commands()
        end,
        desc = 'Commands',
      },
      {
        '<leader>sd',
        function()
          Snacks.picker.diagnostics()
        end,
        desc = 'Diagnostics',
      },
      {
        '<leader>sD',
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = 'Buffer Diagnostics',
      },
      {
        '<leader>sh',
        function()
          Snacks.picker.help()
        end,
        desc = 'Help Pages',
      },
      {
        '<leader>sH',
        function()
          Snacks.picker.highlights()
        end,
        desc = 'Highlights',
      },
      {
        '<leader>si',
        function()
          Snacks.picker.icons()
        end,
        desc = 'Icons',
      },
      {
        '<leader>sj',
        function()
          Snacks.picker.jumps()
        end,
        desc = 'Jumps',
      },
      {
        '<leader>sk',
        function()
          Snacks.picker.keymaps()
        end,
        desc = 'Keymaps',
      },
      {
        '<leader>sl',
        function()
          Snacks.picker.loclist()
        end,
        desc = 'Location List',
      },
      {
        '<leader>sM',
        function()
          Snacks.picker.man()
        end,
        desc = 'Man Pages',
      },
      {
        '<leader>sm',
        function()
          Snacks.picker.marks()
        end,
        desc = 'Marks',
      },
      -- {
      --   '<leader>sR',
      --   function()
      --     Snacks.picker.resume()
      --   end,
      --   desc = 'Resume',
      -- },
      {
        '<leader>sq',
        function()
          Snacks.picker.qflist()
        end,
        desc = 'Quickfix List',
      },
      {
        '<leader>su',
        function()
          Snacks.picker.undo()
        end,
        desc = 'Undotree',
      },
    },
  },
}
