return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()
    require('mini.tabline').setup()
    require('mini.indentscope').setup()
    require('mini.extra').setup()
    require('mini.visits').setup()
    require('mini.icons').setup()
    require('mini.clue').setup()
    require('mini.starter').setup {
      header = [[
     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡀     ⠀
     ⢀⣀⣀⡀⠀⣀⡀⠀⡀⠀⠀⣀⠀⠀⠀⣀⠀⠀⢠⡘⣇⣤⣄⠀⢀⡤⣄⢀⣼⣤⡄⠈⣹⠟     ⠀
     ⠀⠿⠁⠻⠐⢧⡽⠃⠳⠿⢷⠏⠀⠀⠀⠸⠾⠷⠟⠀⠟⠁⠻⠀⠿⠶⠻⠄⠸⠇⠀⠀⣡⠀     ⠀
     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ⠀
             @NeoVim của Dwcks 🦀             ]],
      items = {
        { name = 'Find File 🔍 (f)', action = ':lua MiniPick.builtin.files()', section = 'Keymaps' },
        { name = 'New File 📝 (n)', action = ':ene | startinsert', section = 'Keymaps' },
        { name = 'Grep 🔎 (g)', action = ':lua MiniPick.builtin.grep_live()', section = 'Keymaps' },
        {
          name = 'Recent Files 🕑 (r)',
          action = ':Pick oldfiles',
          section = 'Keymaps',
        },
        {
          name = 'Config ⚙️ (c)',
          action = function()
            require('mini.pick').builtin.files(nil, { source = { cwd = vim.fn.stdpath 'config' } })
          end,
          section = 'Keymaps',
        },
        { name = 'Lazy 💤 (L)', action = ':Lazy', section = 'Keymaps' },
        { name = 'Quit 🚪 (q)', action = ':qa', section = 'Keymaps' },
        {
          name = 'Projects 🗂️ (p)',
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
              source = {
                name = 'Projects',
                items = projects,
              },
              action = function(path)
                vim.cmd('tabnew ' .. path)
              end,
            }
          end,
          section = 'Keymaps',
        },
      },
      footer = [[
─────────────────────────────────────────────
🔎 Type query to filter   ⌫ <BS>: delete
⎋ <Esc>: reset query     🔒 <C-c>: close
⬆️ <Up>/<Down>: move     🆗 <CR>: select
🔽 <C-n>/<C-p>: move     🔀 <M-j>/<M-k>: move
─────────────────────────────────────────────
]],
    }

    -- require('mini.clue').setup {
    --   triggers = {
    --     -- Normal mode
    --     { mode = 'n', keys = '<leader>' },
    --     { mode = 'n', keys = 'g' },
    --     { mode = 'n', keys = 'z' },
    --     { mode = 'n', keys = ']' },
    --     { mode = 'n', keys = '[' },
    --     { mode = 'n', keys = 'm' }, -- marks
    --     { mode = 'n', keys = "'" }, -- marks
    --     { mode = 'n', keys = '`' }, -- marks
    --     { mode = 'n', keys = '"' }, -- registers
    --     { mode = 'i', keys = '<C-r>' }, -- registers trong insert mode
    --     -- Visual mode
    --     { mode = 'v', keys = '<leader>' },
    --     { mode = 'v', keys = 'g' },
    --     { mode = 'v', keys = 'z' },
    --     { mode = 'v', keys = ']' },
    --     { mode = 'v', keys = '[' },
    --   },
    --   clues = {
    --     -- Bạn có thể thêm mô tả cho các nhóm/phím chính
    --     require('mini.clue').gen_clues.builtin_completion(),
    --     require('mini.clue').gen_clues.g(),
    --     require('mini.clue').gen_clues.marks(),
    --     require('mini.clue').gen_clues.registers(),
    --     require('mini.clue').gen_clues.windows(),
    --     require('mini.clue').gen_clues.z(),
    --     -- Thêm mô tả cho các prefix custom của bạn
    --     { mode = 'n', keys = '<leader>s', desc = 'Search' },
    --     { mode = 'n', keys = '<leader>t', desc = 'Toggle' },
    --     { mode = 'n', keys = '<leader>h', desc = 'Git [H]unk' },
    --     { mode = 'v', keys = '<leader>h', desc = 'Git [H]unk' },
    --   },
    --   window = { delay = 0 },
    -- }

    require('mini.diff').setup {
      view = {
        style = 'sign',
      },
      mappings = {
        goto_first = '[G',
        goto_prev = '[g',
        goto_next = ']g',
        goto_last = ']G',
      },
    }
    require('mini.notify').setup() -- TODO: add keybindings for notifications

    require('mini.fuzzy').setup()

    -- Mini Pick  TODO: add keybindings for pick
    local pick = require 'mini.pick'

    pick.setup {
      -- Delays (in ms; should be at least 1)
      delay = {
        -- Delay between forcing asynchronous behavior
        async = 10,
        -- Delay between computation start and visual feedback about it
        busy = 50,
      },

      -- Keys for performing actions. See `:h MiniPick-actions`.
      mappings = {
        caret_left = '<Left>',
        caret_right = '<Right>',

        choose = '<CR>',
        choose_in_split = '<C-s>',
        choose_in_tabpage = '<C-t>',
        choose_in_vsplit = '<C-v>',
        choose_marked = '<C-CR>',

        delete_char = '<BS>',
        delete_char_right = '<Del>',
        delete_left = '<C-u>',
        delete_word = '<C-w>',

        mark = '<C-x>',
        mark_all = '<C-a>',

        move_down = '<C-n>',
        move_start = '<C-g>',
        move_up = '<C-p>',

        paste = '<C-r>',

        refine = '<C-Space>',
        refine_marked = '<M-Space>',

        scroll_down = '<C-f>',
        scroll_left = '<C-h>',
        scroll_right = '<C-l>',
        scroll_up = '<C-b>',

        stop = '<Esc>',

        toggle_info = '<S-Tab>',
        toggle_preview = '<Tab>',
      },

      -- General options
      options = {
        -- Whether to show content from bottom to top
        content_from_bottom = false,

        -- Whether to cache matches (more speed and memory on repeated prompts)
        use_cache = false,
      },

      -- Source definition. See `:h MiniPick-source`.
      source = {
        items = nil,
        name = nil,
        cwd = nil,

        match = nil,
        show = nil,
        preview = nil,

        choose = nil,
        choose_marked = nil,
      },

      -- Window related options
      window = {
        -- Float window config (table or callable returning it)
        config = function()
          local height = math.floor(0.7 * vim.o.lines) -- 70% of window height
          local width = math.floor(0.8 * vim.o.columns) -- 80% of window width
          local row = math.floor((vim.o.lines - height) / 2) -- Center vertically
          local col = math.floor((vim.o.columns - width) / 2) -- Center horizontally

          return {
            anchor = 'NW',
            height = height,
            width = width,
            row = row,
            col = col,
            border = 'single', -- Optional: single border for better visibility
          }
        end,

        -- String to use as caret in prompt
        prompt_caret = '▏',

        -- String to use as prefix in prompt
        prompt_prefix = '> ',
      },
    }

    -- Mini Snippets
    local mini_snippets = require 'mini.snippets'
    mini_snippets.setup {
      snippets = { mini_snippets.gen_loader.from_lang() },
      mappings = {
        -- Expand snippet at cursor position. Created globally in Insert mode.
        expand = '<C-a>',

        -- Interact with default `expand.insert` session.
        -- Created for the duration of active session(s)
        jump_next = '<C-l>',
        jump_prev = '<C-h>',
        stop = '<C-c>',
      },
    }

    require('mini.sessions').setup() -- TODO: add keybindings for sessions

    require('mini.files').setup {
      windows = {
        -- Maximum number of windows to show side by side
        max_number = math.huge,
        -- Whether to show preview of file/directory under cursor
        preview = true,
        -- Width of focused window
        width_focus = 50,
        -- Width of non-focused window
        width_nofocus = 15,
        -- Width of preview window
        width_preview = 25,
      },
    }

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'
    local icons = require 'mini.icons'

    statusline.setup {
      use_icons = vim.g.have_nerd_font, -- Use Nerd Font icons if available
      content = {
        active = function()
          local git = statusline.section_git { trunc_width = 75 }
          local location = statusline.section_location { trunc_width = 75 }

          -- Custom diagnostics section with lualine symbols and distinct colors
          local section_diagnostics = function()
            local symbols = {
              error = ' ',
              warn = ' ',
              info = ' ',
              hint = vim.g.have_nerd_font and '󰌶 ' or '💡 ',
            }
            local status = { error = 0, warn = 0, info = 0, hint = 0 }
            local levels = vim.diagnostic.severity

            -- Get diagnostic counts
            for _, severity in ipairs { levels.ERROR, levels.WARN, levels.INFO, levels.HINT } do
              local count = #vim.diagnostic.get(0, { severity = severity })
              if severity == levels.ERROR then
                status.error = count
              elseif severity == levels.WARN then
                status.warn = count
              elseif severity == levels.INFO then
                status.info = count
              elseif severity == levels.HINT then
                status.hint = count
              end
            end

            -- Build diagnostics string with distinct highlight groups
            local result = {}
            if status.error > 0 then
              table.insert(result, string.format('%%#MiniStatuslineDiagnosticsError#%s%d', symbols.error, status.error))
            end
            if status.warn > 0 then
              table.insert(result, string.format('%%#MiniStatuslineDiagnosticsWarn#%s%d', symbols.warn, status.warn))
            end
            if status.info > 0 then
              table.insert(result, string.format('%%#MiniStatuslineDiagnosticsInfo#%s%d', symbols.info, status.info))
            end
            if status.hint > 0 then
              table.insert(result, string.format('%%#MiniStatuslineDiagnosticsHint#%s%d', symbols.hint, status.hint))
            end
            return table.concat(result, ' ')
          end

          -- Custom progress section
          local section_progress = function()
            local line = vim.fn.line '.'
            local total_lines = vim.fn.line '$'
            if total_lines == 0 then
              return '0%'
            end
            local percentage = math.floor((line / total_lines) * 100)
            return string.format('%d%%', percentage)
          end

          -- Custom filetype section with colored icon using mini.icons
          local section_filetype = function()
            local ft = vim.bo.filetype
            if ft == '' then
              return ''
            end
            local filename = vim.fn.expand '%:t'
            local icon_data = icons.get('file', filename) or { icon = '', hl = 'MiniIconsDefault' }
            local icon = icon_data.icon or ''
            local hl_group = 'MiniStatuslineFiletype' .. ft:gsub('[^%w]', '_') -- Unique highlight group per filetype
            -- Use mini.icons highlight group color or fallback to default
            local color = icon_data.hl and vim.api.nvim_get_hl(0, { name = icon_data.hl }).fg or '#cdd6f4'
            vim.api.nvim_set_hl(0, hl_group, { fg = color, bg = 'NONE' })
            return string.format('%%#%s#%s', hl_group, icon)
          end

          -- Custom mode section
          local mode_info = {
            n = { name = 'NORMAL', icon = '', color = '#cba6f7', hl = 'MiniStatuslineModeNormal' },
            i = { name = 'INSERT', icon = '', color = '#a6e3a1', hl = 'MiniStatuslineModeInsert' },
            v = { name = 'VISUAL', icon = '✂️', color = '#f9e2af', hl = 'MiniStatuslineModeVisual' },
            V = { name = 'V-LINE', icon = '', color = '#f9e2af', hl = 'MiniStatuslineModeVisual' },
            [''] = { name = 'V-BLOCK', icon = '', color = '#f9e2af', hl = 'MiniStatuslineModeVisual' },
            c = { name = 'COMMAND', icon = '', color = '#fab387', hl = 'MiniStatuslineModeCommand' },
            R = { name = 'REPLACE', icon = '', color = '#f38ba8', hl = 'MiniStatuslineModeReplace' },
            t = { name = 'TERMINAL', icon = '', color = '#cba6f7', hl = 'MiniStatuslineModeNormal' },
          }

          -- Handle mode
          local current_mode = vim.fn.mode()
          local mode_data = mode_info[current_mode] or { name = current_mode:upper(), icon = '', color = '#cba6f7', hl = 'MiniStatuslineModeNormal' }

          -- Custom filename with modified/readonly symbols and dynamic color
          local filename_section = function()
            local name = vim.fn.expand '%:~' -- Use ~ for home directory
            if name == '' then
              return '[No Name]'
            end
            local modified = vim.bo.modified and '●' or ''
            local readonly = vim.bo.readonly and '🔒' or ''
            local hl_group = vim.bo.modified and 'MiniStatuslineFilenameModified' or 'MiniStatuslineFilename'
            return string.format('%%#%s#%s%s%s', hl_group, name, modified, readonly)
          end

          -- Custom recording macro section
          local recording = function()
            local reg = vim.fn.reg_recording()
            if reg == '' then
              return ''
            end
            return string.format('%%#MiniStatuslineRecording#⏺️ Recording @%s', reg)
          end

          -- Define highlight groups
          vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormal', { fg = '#cba6f7', bg = 'NONE' })
          vim.api.nvim_set_hl(0, 'MiniStatuslineModeInsert', { fg = '#a6e3a1', bg = 'NONE' })
          vim.api.nvim_set_hl(0, 'MiniStatuslineModeVisual', { fg = '#f9e2af', bg = 'NONE' })
          vim.api.nvim_set_hl(0, 'MiniStatuslineModeReplace', { fg = '#f38ba8', bg = 'NONE' })
          vim.api.nvim_set_hl(0, 'MiniStatuslineModeCommand', { fg = '#fab387', bg = 'NONE' })
          vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { fg = '#cdd6f4', bg = 'NONE' })
          vim.api.nvim_set_hl(0, 'MiniStatuslineFilenameModified', { fg = '#fab387', bg = 'NONE' })
          vim.api.nvim_set_hl(0, 'MiniStatuslineRecording', { fg = '#f38ba8', bg = 'NONE' })
          vim.api.nvim_set_hl(0, 'MiniStatuslineGit', { fg = '#89b4fa', bg = 'NONE' })
          vim.api.nvim_set_hl(0, 'MiniStatuslineDiagnosticsError', { fg = '#f38ba8', bg = 'NONE' })
          vim.api.nvim_set_hl(0, 'MiniStatuslineDiagnosticsWarn', { fg = '#f9e2af', bg = 'NONE' })
          vim.api.nvim_set_hl(0, 'MiniStatuslineDiagnosticsInfo', { fg = '#89b4fa', bg = 'NONE' })
          vim.api.nvim_set_hl(0, 'MiniStatuslineDiagnosticsHint', { fg = '#a6e3a1', bg = 'NONE' })
          vim.api.nvim_set_hl(0, 'MiniStatuslineProgress', { fg = '#a6e3a1', bg = 'NONE' })
          vim.api.nvim_set_hl(0, 'MiniStatuslineLocation', { fg = '#cdd6f4', bg = 'NONE' })
          vim.api.nvim_set_hl(0, 'MiniIconsDefault', { fg = '#cdd6f4', bg = 'NONE' }) -- Fallback highlight group

          -- Construct the statusline with space separators
          return table.concat {
            string.format('%%#%s#%s %s', mode_data.hl, mode_data.icon, mode_data.name),
            ' ',
            string.format('%%#MiniStatuslineGit#%s', git),
            ' ',
            section_diagnostics(),
            ' ',
            filename_section(),
            ' ',
            section_filetype(),
            '%<', -- Truncate point
            '%=', -- Align right
            recording(),
            recording() ~= '' and ' ' or '', -- Only show space if recording is active
            string.format('%%#MiniStatuslineProgress#📏 %s', section_progress()),
            ' ',
            string.format('%%#MiniStatuslineLocation#📍 %s', location),
          }
        end,
        inactive = function()
          local location = statusline.section_location { trunc_width = 75 }

          -- Custom filename section for inactive windows
          local filename_section = function()
            local name = vim.fn.expand '%:~' -- Use ~ for home directory
            if name == '' then
              return '[No Name]'
            end
            local modified = vim.bo.modified and '●' or ''
            local readonly = vim.bo.readonly and '🔒' or ''
            local hl_group = vim.bo.modified and 'MiniStatuslineFilenameModified' or 'MiniStatuslineInactive'
            return string.format('%%#%s#%s%s%s', hl_group, name, modified, readonly)
          end

          vim.api.nvim_set_hl(0, 'MiniStatuslineInactive', { fg = '#45475a', bg = 'NONE' })
          vim.api.nvim_set_hl(0, 'MiniStatuslineFilenameModified', { fg = '#fab387', bg = 'NONE' })

          return table.concat {
            filename_section(),
            '%<', -- Truncate point
            '%=', -- Align right
            string.format('%%#MiniStatuslineInactive#📍 %s', location),
          }
        end,
      },
    }

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
