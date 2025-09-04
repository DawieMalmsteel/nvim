-- TODO: Split code into multiple files for better organization and maintainability
-- TODO: Add more plugins or modules as needed
return { -- Collection of various small independent plugins/modules
  'nvim-mini/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }
    -- require('mini.trailspace').setup {}
    -- require('mini.jump2d').setup {}

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()
    -- require('mini.animate').setup {
    --   cursor = {
    --     enable = false, -- Bật hiệu ứng di chuyển con trỏ
    --   },
    -- }
    local buffer_positions = {}

    -- Hàm cập nhật danh sách buffer và vị trí
    local function update_buffer_positions()
      local listed_buffers = vim.tbl_filter(function(buf)
        return vim.bo[buf.bufnr].buflisted
      end, vim.fn.getbufinfo())

      buffer_positions = {}
      for i, buf in ipairs(listed_buffers) do
        buffer_positions[buf.bufnr] = i
      end
    end

    -- Cập nhật danh sách buffer khi có sự kiện liên quan
    vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete', 'BufEnter' }, {
      callback = update_buffer_positions,
    })

    -- Gọi cập nhật lần đầu khi khởi động
    update_buffer_positions()

    require('mini.tabline').setup {
      format = function(buf_id, label)
        local current_buf = vim.api.nvim_get_current_buf()

        -- Lấy vị trí của buffer hiện tại và buffer đang xử lý
        local current_index = buffer_positions[current_buf]
        local buf_index = buffer_positions[buf_id]

        -- Nếu là buffer hiện tại, chỉ hiển thị nhãn mặc định (bao gồm icon)
        if buf_id == current_buf then
          -- return ' [' .. MiniTabline.default_format(buf_id, label) .. '] '
          return MiniTabline.default_format(buf_id, label)
        else
          -- Tính số tương đối dựa trên vị trí trong danh sách
          local relative_number = math.abs((buf_index or 0) - (current_index or 0))

          -- Rút gọn nhãn (chỉ lấy 5 ký tự đầu tiên)
          local short_label = label:sub(1, 5)

          -- Kết hợp số tương đối và nhãn rút gọn
          return ' ' .. relative_number .. ':' .. short_label .. ' '
        end
      end,
    }

    require('mini.hipatterns').setup {
      tailwind = {
        enabled = true,
        ft = {
          'astro',
          'css',
          'heex',
          'html',
          'html-eex',
          'javascript',
          'javascriptreact',
          'rust',
          'svelte',
          'typescript',
          'typescriptreact',
          'vue',
        },
        -- full: the whole css class will be highlighted
        -- compact: only the color will be highlighted
        style = 'full',
      },
      highlighters = {
        hex_color = require('mini.hipatterns').gen_highlighter.hex_color { priority = 2000 },
        shorthand = {
          pattern = '()#%x%x%x()%f[^%x%w]',
          group = function(_, _, data)
            ---@type string
            local match = data.full_match
            local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
            local hex_color = '#' .. r .. r .. g .. g .. b .. b

            return MiniHipatterns.compute_hex_color_group(hex_color, 'bg')
          end,
          extmark_opts = { priority = 2000 },
        },
      },
    }

    local mini_map = require 'mini.map'
    mini_map.setup {
      symbols = {
        encode = mini_map.gen_encode_symbols.dot '4x2',
      },
      integrations = {
        mini_map.gen_integration.builtin_search(),
        mini_map.gen_integration.diagnostic {
          error = 'DiagnosticFloatingError',
          warn = 'DiagnosticFloatingWarn',
          info = 'DiagnosticFloatingInfo',
          hint = 'DiagnosticFloatingHint',
        },
        mini_map.gen_integration.diff(),
        mini_map.gen_integration.gitsigns(),
      },
      window = {
        side = 'right',
        width = 10,
        winblend = 80, -- Độ trong suốt, 80 là hợp lý (100 là tàng hình)
        show_integration_count = true,
      },
    }
    require('mini.extra').setup()
    require('mini.visits').setup()
    require('mini.icons').setup()
    require('mini.git').setup()
    require('mini.bufremove').setup()
    require('mini.cursorword').setup()
    require('mini.statusline').setup()
    -- require('mini.hues').setup { background = '#19213a', foreground = '#c0c8cc' }

    -- local function mode_nx(keys)
    --   return { mode = 'n', keys = keys }, { mode = 'x', keys = keys }
    -- end
    --
    -- local clue = require 'mini.clue'
    -- clue.setup {
    --   triggers = {
    --     -- Leader triggers
    --     mode_nx '<leader>',
    --
    --     -- Built-in completion
    --     { mode = 'i', keys = '<c-x>' },
    --
    --     -- `g` key
    --     mode_nx 'g',
    --
    --     mode_nx 'd',
    --
    --     -- Marks
    --     mode_nx "'",
    --     mode_nx '`',
    --
    --     -- Registers
    --     mode_nx '"',
    --     { mode = 'i', keys = '<c-r>' },
    --     { mode = 'c', keys = '<c-r>' },
    --
    --     -- Window commands
    --     { mode = 'n', keys = '<c-w>' },
    --
    --     -- bracketed commands
    --     { mode = 'n', keys = '[' },
    --     { mode = 'n', keys = ']' },
    --
    --     -- `z` key
    --     mode_nx 'z',
    --
    --     -- surround
    --     mode_nx 's',
    --
    --     -- text object
    --     { mode = 'x', keys = 'i' },
    --     { mode = 'x', keys = 'a' },
    --     { mode = 'o', keys = 'i' },
    --     { mode = 'o', keys = 'a' },
    --   },
    --
    --   clues = {
    --     -- Enhance this by adding descriptions for <Leader> mapping groups
    --     clue.gen_clues.builtin_completion(),
    --     clue.gen_clues.square_brackets(),
    --     clue.gen_clues.g(),
    --     clue.gen_clues.marks(),
    --     clue.gen_clues.registers { show_contents = true },
    --     clue.gen_clues.windows { submode_resize = true, submode_move = true, submode_navigate = true },
    --     clue.gen_clues.z(),
    --   },
    --   window = {
    --     -- Floating window config
    --     config = {},
    --
    --     -- Delay before showing clue window
    --     delay = 0,
    --
    --     -- Keys to scroll inside the clue window
    --     scroll_down = '<C-d>',
    --     scroll_up = '<C-u>',
    --   },
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

    -- require('mini.notify').setup()

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
        use_cache = true,
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

    -- require('mini.sessions').setup {
    --   file = '',
    -- }

    -- MiniBracketed Keybindings:
    -- [B` `[b` `]b` `]B` - Buffer
    -- [C` `[c` `]c` `]C` - Comment block
    -- [X` `[x` `]x` `]X` - Conflict marker
    -- [D` `[d` `]d` `]D` - Diagnostic
    -- [F` `[f` `]f` `]F` - File on disk
    -- [I` `[i` `]i` `]I` - Indent change
    -- [J` `[j` `]j` `]J` - Jump inside current buffer
    -- [L` `[l` `]l` `]L` - Location from location-list
    -- [O` `[o` `]o` `]O` - Old files
    -- [Q` `[q` `]q` `]Q` - Quickfix entry
    -- [T` `[t` `]t` `]T` - Tree-sitter node and parents
    -- [U` `[u` `]u` `]U` - Undo states
    -- [W` `[w` `]w` `]W` - Window in current tab
    -- [Y` `[y` `]y` `]Y` - Yank selection replacing latest put region
    require('mini.bracketed').setup()

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

    local nsMiniFiles = vim.api.nvim_create_namespace 'mini_files_git'
    local autocmd = vim.api.nvim_create_autocmd
    local _, MiniFiles = pcall(require, 'mini.files')

    -- Cache for git status
    local gitStatusCache = {}
    local cacheTimeout = 2000 -- in milliseconds
    local uv = vim.uv or vim.loop

    local function isSymlink(path)
      local stat = uv.fs_lstat(path)
      return stat and stat.type == 'link'
    end

    ---@type table<string, {symbol: string, hlGroup: string}>
    ---@param status string
    ---@return string symbol, string hlGroup
    local function mapSymbols(status, is_symlink)
      local statusMap = {
    -- stylua: ignore start 
    [" M"] = { symbol = "•", hlGroup  = "MiniDiffSignChange"}, -- Modified in the working directory
    ["M "] = { symbol = "✹", hlGroup  = "MiniDiffSignChange"}, -- modified in index
    ["MM"] = { symbol = "≠", hlGroup  = "MiniDiffSignChange"}, -- modified in both working tree and index
    ["A "] = { symbol = "+", hlGroup  = "MiniDiffSignAdd"   }, -- Added to the staging area, new file
    ["AA"] = { symbol = "≈", hlGroup  = "MiniDiffSignAdd"   }, -- file is added in both working tree and index
    ["D "] = { symbol = "-", hlGroup  = "MiniDiffSignDelete"}, -- Deleted from the staging area
    ["AM"] = { symbol = "⊕", hlGroup  = "MiniDiffSignChange"}, -- added in working tree, modified in index
    ["AD"] = { symbol = "-•", hlGroup = "MiniDiffSignChange"}, -- Added in the index and deleted in the working directory
    ["R "] = { symbol = "→", hlGroup  = "MiniDiffSignChange"}, -- Renamed in the index
    ["U "] = { symbol = "‖", hlGroup  = "MiniDiffSignChange"}, -- Unmerged path
    ["UU"] = { symbol = "⇄", hlGroup  = "MiniDiffSignAdd"   }, -- file is unmerged
    ["UA"] = { symbol = "⊕", hlGroup  = "MiniDiffSignAdd"   }, -- file is unmerged and added in working tree
    ["??"] = { symbol = "?", hlGroup  = "MiniDiffSignDelete"}, -- Untracked files
    ["!!"] = { symbol = "!", hlGroup  = "MiniDiffSignChange"}, -- Ignored files
        -- stylua: ignore end
      }

      local result = statusMap[status] or { symbol = '?', hlGroup = 'NonText' }
      local gitSymbol = result.symbol
      local gitHlGroup = result.hlGroup

      local symlinkSymbol = is_symlink and '↩' or ''

      -- Combine symlink symbol with Git status if both exist
      local combinedSymbol = (symlinkSymbol .. gitSymbol):gsub('^%s+', ''):gsub('%s+$', '')
      -- Change the color of the symlink icon from "MiniDiffSignDelete" to something else
      local combinedHlGroup = is_symlink and 'MiniDiffSignDelete' or gitHlGroup

      return combinedSymbol, combinedHlGroup
    end

    ---@param cwd string
    ---@param callback function
    ---@return nil
    local function fetchGitStatus(cwd, callback)
      local clean_cwd = cwd:gsub('^minifiles://%d+/', '')
      ---@param content table
      local function on_exit(content)
        if content.code == 0 then
          callback(content.stdout)
          -- vim.g.content = content.stdout
        end
      end
      ---@see vim.system
      vim.system({ 'git', 'status', '--ignored', '--porcelain' }, { text = true, cwd = clean_cwd }, on_exit)
    end

    ---@param buf_id integer
    ---@param gitStatusMap table
    ---@return nil
    local function updateMiniWithGit(buf_id, gitStatusMap)
      vim.schedule(function()
        local nlines = vim.api.nvim_buf_line_count(buf_id)
        local cwd = vim.fs.root(buf_id, '.git')
        local escapedcwd = cwd and vim.pesc(cwd)
        escapedcwd = vim.fs.normalize(escapedcwd)

        for i = 1, nlines do
          local entry = MiniFiles.get_fs_entry(buf_id, i)
          if not entry then
            break
          end
          local relativePath = entry.path:gsub('^' .. escapedcwd .. '/', '')
          local status = gitStatusMap[relativePath]

          if status then
            local symbol, hlGroup = mapSymbols(status, isSymlink(entry.path))
            vim.api.nvim_buf_set_extmark(buf_id, nsMiniFiles, i - 1, 0, {
              sign_text = symbol,
              sign_hl_group = hlGroup,
              priority = 2,
            })
            -- This below code is responsible for coloring the text of the items. comment it out if you don't want that
            local line = vim.api.nvim_buf_get_lines(buf_id, i - 1, i, false)[1]
            -- Find the name position accounting for potential icons
            local nameStartCol = line:find(vim.pesc(entry.name)) or 0

            if nameStartCol > 0 then
              vim.api.nvim_buf_set_extmark(buf_id, nsMiniFiles, i - 1, nameStartCol - 1, {
                end_col = nameStartCol + #entry.name - 1,
                hl_group = hlGroup,
              })
            end
          else
          end
        end
      end)
    end

    -- Thanks for the idea of gettings https://github.com/refractalize/oil-git-status.nvim signs for dirs
    ---@param content string
    ---@return table
    local function parseGitStatus(content)
      local gitStatusMap = {}
      -- lua match is faster than vim.split (in my experience )
      for line in content:gmatch '[^\r\n]+' do
        local status, filePath = string.match(line, '^(..)%s+(.*)')
        -- Split the file path into parts
        local parts = {}
        for part in filePath:gmatch '[^/]+' do
          table.insert(parts, part)
        end
        -- Start with the root directory
        local currentKey = ''
        for i, part in ipairs(parts) do
          if i > 1 then
            -- Concatenate parts with a separator to create a unique key
            currentKey = currentKey .. '/' .. part
          else
            currentKey = part
          end
          -- If it's the last part, it's a file, so add it with its status
          if i == #parts then
            gitStatusMap[currentKey] = status
          else
            -- If it's not the last part, it's a directory. Check if it exists, if not, add it.
            if not gitStatusMap[currentKey] then
              gitStatusMap[currentKey] = status
            end
          end
        end
      end
      return gitStatusMap
    end

    ---@param buf_id integer
    ---@return nil
    local function updateGitStatus(buf_id)
      if not vim.fs.root(buf_id, '.git') then
        return
      end
      local cwd = vim.fs.root(buf_id, '.git')
      -- local cwd = vim.fn.expand("%:p:h")
      local currentTime = os.time()

      if gitStatusCache[cwd] and currentTime - gitStatusCache[cwd].time < cacheTimeout then
        updateMiniWithGit(buf_id, gitStatusCache[cwd].statusMap)
      else
        fetchGitStatus(cwd, function(content)
          local gitStatusMap = parseGitStatus(content)
          gitStatusCache[cwd] = {
            time = currentTime,
            statusMap = gitStatusMap,
          }
          updateMiniWithGit(buf_id, gitStatusMap)
        end)
      end
    end

    ---@return nil
    local function clearCache()
      gitStatusCache = {}
    end

    local function augroup(name)
      return vim.api.nvim_create_augroup('MiniFiles_' .. name, { clear = true })
    end

    autocmd('User', {
      group = augroup 'start',
      pattern = 'MiniFilesExplorerOpen',
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        updateGitStatus(bufnr)
      end,
    })

    autocmd('User', {
      group = augroup 'close',
      pattern = 'MiniFilesExplorerClose',
      callback = function()
        clearCache()
      end,
    })

    autocmd('User', {
      group = augroup 'update',
      pattern = 'MiniFilesBufferUpdate',
      callback = function(args)
        local bufnr = args.data.buf_id
        local cwd = vim.fs.root(bufnr, '.git')
        if gitStatusCache[cwd] then
          updateMiniWithGit(bufnr, gitStatusCache[cwd].statusMap)
        end
      end,
    })

    local statusline = require 'mini.statusline'

    statusline.setup {
      use_icons = true, -- Giữ icons nếu có Nerd Font
      content = {
        active = function()
          local mode, mode_hl = statusline.section_mode { trunc_width = 150 }
          local git = statusline.section_git { trunc_width = 75 }
          local diagnostics = function() -- Thay icon diagnostics thành chữ với màu
            if not vim.diagnostic.is_enabled() then
              return ''
            end
            local counts = { E = 0, W = 0, I = 0, H = 0 }
            local severities = vim.diagnostic.severity
            for _, diag in ipairs(vim.diagnostic.get(0)) do
              if diag.severity == severities.ERROR then
                counts.E = counts.E + 1
              elseif diag.severity == severities.WARN then
                counts.W = counts.W + 1
              elseif diag.severity == severities.INFO then
                counts.I = counts.I + 1
              elseif diag.severity == severities.HINT then
                counts.H = counts.H + 1
              end
            end
            local result = {}
            if counts.E > 0 then
              table.insert(result, '%#MiniStatuslineDiagnosticsError# ' .. counts.E)
            end
            if counts.W > 0 then
              table.insert(result, '%#MiniStatuslineDiagnosticsWarn# ' .. counts.W)
            end
            if counts.I > 0 then
              table.insert(result, '%#MiniStatuslineDiagnosticsInfo# ' .. counts.I)
            end
            if counts.H > 0 then
              table.insert(result, '%#MiniStatuslineDiagnosticsHint# ' .. counts.H)
            end
            return table.concat(result, ' ')
          end
          local filename = function()
            -- Custom filename: relative path shortened with ~ for home, dynamic color if modified
            local name = vim.fn.expand '%:~:.'
            if name == '' then
              name = '[No Name]'
            end
            -- Đổi màu toàn bộ filename nếu modified (sử dụng highlight MiniStatuslineModified)
            local hl = vim.bo.modified and '%#MiniStatuslineModified#' or '%#MiniStatuslineFilename#'
            -- Flags cho readonly/modifiable (không cần [+] vì đã đổi màu, giữ gọn)
            local flags = ''
            if vim.bo.modified then
              flags = flags .. ' ' -- Thêm icon Nerd Font cho modified (pencil icon biểu thị chỉnh sửa)
            end
            if vim.bo.readonly then
              flags = flags .. ' [RO]'
            end
            if not vim.bo.modifiable then
              flags = flags .. ' [-]'
            end
            return hl .. name .. flags
          end
          local location = function()
            -- Kết hợp location đầy đủ (với tổng lines và column) + progress bar dọc (sử dụng ký tự tăng dần dọc để gọn và đẹp)
            local current_line = vim.fn.line '.'
            local total_lines = vim.fn.line '$'
            local column = vim.fn.col '.'
            local fraction = math.floor((current_line / total_lines) * 8) -- 0 đến 8 cho các mức
            local vbars = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' } -- Ký tự progress dọc (tăng từ dưới lên)
            local progress_bar = '%#MiniStatuslineProgress#' .. (vbars[math.max(1, math.min(#vbars, fraction or 1))] or '█') -- Chọn ký tự đại diện progress dọc

            return ' ' .. current_line .. '  ' .. column .. ' ' .. progress_bar
            -- return ' ' .. current_line .. '/' .. total_lines .. '  ' .. column .. ' ' .. progress_bar
          end

          -- Thêm recording macro minimal
          local recording = function()
            local reg = vim.fn.reg_recording()
            if reg == '' then
              return ''
            end
            return '%#MiniStatuslineRecording#Recording @' .. reg
          end

          local harpoon_status = function()
            local ok, harpoon = pcall(require, 'harpoon')
            if not ok then
              return ''
            end

            local list = harpoon:list()
            if not list or #list.items == 0 then
              return ''
            end

            local current_file = vim.fn.expand '%:p'
            local harpoon_entries = {}

            for i, item in ipairs(list.items) do
              local file_path = vim.loop.fs_realpath(item.value)
              local file_name = vim.fn.fnamemodify(file_path or '', ':t') or 'N/A' -- Lấy tên file hoặc gán giá trị mặc định
              local short_name = file_name:sub(1, 2) -- Lấy 3 ký tự đầu tiên của tên file
              if file_path == vim.loop.fs_realpath(current_file) then
                table.insert(harpoon_entries, '[' .. i .. ':' .. short_name .. ']') -- Đánh dấu file hiện tại bằng dấu ngoặc vuông
              else
                table.insert(harpoon_entries, i .. ':' .. short_name) -- Hiển thị index và tên file rút gọn
              end
            end

            return table.concat(harpoon_entries, ' ') -- Ngăn cách các file bằng khoảng trắng
          end

          return statusline.combine_groups {
            { hl = mode_hl, strings = { mode } },
            { hl = 'MiniStatuslineDevinfo', strings = { git } },
            { hl = 'MiniStatuslineDiagnostics', strings = { diagnostics() } },
            '%<', -- Left truncate
            { hl = 'MiniStatuslineFilename', strings = { filename() } },
            '%=', -- Right align
            { strings = { recording() } },
            { hl = 'MiniStatuslineHarpoon', strings = { harpoon_status() } }, -- Thêm Harpoon ở giữa
            { hl = 'MiniStatuslineLocation', strings = { location() } },
          }
        end,
        inactive = function()
          return '%#MiniStatuslineInactive#' .. statusline.section_filename {}
        end,
      },
    }
  end,
}
