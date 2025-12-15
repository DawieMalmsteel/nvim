local M = function()
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesWindowUpdate',
    callback = function(ev)
      local state = MiniFiles.get_explorer_state() or {}

      local win_ids = vim.tbl_map(function(t)
        return t.win_id
      end, state.windows or {})

      local function idx(win_id)
        for i, id in ipairs(win_ids) do
          if id == win_id then
            return i
          end
        end
      end

      local this_win_idx = idx(ev.data.win_id)
      local focused_win_idx = idx(vim.api.nvim_get_current_win())

      -- this_win_idx can be nil sometimes when opening fresh minifiles
      if this_win_idx and focused_win_idx then
        -- idx_offset is 0 for the currently focused window
        local idx_offset = this_win_idx - focused_win_idx

        -- the width of windows based on their distance from the center
        -- i.e. center window is 60, then next over is 20, then the rest are 10.
        -- Can use more resolution if you want like { 60, 30, 20, 15, 10, 5 }
        local widths = { 60, 20, 10 }

        local i = math.abs(idx_offset) + 1 -- because lua is 1-based lol
        local win_config = vim.api.nvim_win_get_config(ev.data.win_id)
        win_config.width = i <= #widths and widths[i] or widths[#widths]

        local offset = 0
        for j = 1, math.abs(idx_offset) do
          local w = widths[j] or widths[#widths]
          -- add an extra +2 each step to account for the border width
          local _offset = 0.5 * (w + win_config.width) + 2
          if idx_offset > 0 then
            offset = offset + _offset
          elseif idx_offset < 0 then
            offset = offset - _offset
          end
        end

        win_config.height = idx_offset == 0 and 25 or 20
        win_config.row = math.floor(0.5 * (vim.o.lines - win_config.height))
        win_config.col = math.floor(0.5 * (vim.o.columns - win_config.width) + offset)
        vim.api.nvim_win_set_config(ev.data.win_id, win_config)
      end
    end,
  })

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
      width_preview = 60, -- 60
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
      if escapedcwd ~= nil then
        escapedcwd = vim.fs.normalize(escapedcwd)
      end

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
    local cwd = vim.fs.root(buf_id, '.git')
    if not cwd then
      return
    end
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
end
return M
