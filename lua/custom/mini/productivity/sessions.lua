local M = function()
  -- Sessions (mini.sessions) configured per docs (improved)
  local sessions = require 'mini.sessions'

  -- Ensure session directory exists
  local session_dir = vim.fn.stdpath 'data' .. '/sessions'
  vim.fn.mkdir(session_dir, 'p')

  -- Tighten sessionoptions (adjust if needed)
  vim.opt.sessionoptions = 'buffers,curdir,folds,help,tabpages,winpos,winsize,terminal'

  sessions.setup {
    autoread = false, -- explicit restore
    autowrite = true, -- save when switching / leaving
    directory = session_dir,
    file = 'Session.vim',
    force = { read = false, write = true, delete = false },
    verbose = { read = true, write = true, delete = true },
    hooks = {
      pre = {
        write = function(_)
          -- Close floating windows before saving
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local cfg = vim.api.nvim_win_get_config(win)
            if cfg.relative ~= '' then
              pcall(vim.api.nvim_win_close, win, true)
            end
          end
          -- Skip if only an empty no-name buffer
          local listed = vim.fn.getbufinfo { buflisted = 1 }
          if #listed == 1 and listed[1].name == '' and listed[1].changed == 0 then
            return
          end
        end,
      },
      post = {
        read = function(data)
          _G.__last_session = data.name
        end,
        write = function(data)
          _G.__last_session = data.name
        end,
      },
    },
  }

  local map = vim.keymap.set

  -- Helper: sanitized name from CWD for a global session
  local function cwd_session_name()
    return (vim.loop.cwd():gsub('[%/%\\:]', '%%')) .. '.vim'
  end

  -- Restore (default: local if exists else latest) with unsaved check
  map('n', '<leader>qs', function()
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[b].modified then
        if vim.fn.confirm('Unsaved buffers detected. Continue loading session?', '&Yes\n&No', 2) ~= 1 then
          return
        end
        break
      end
    end
    local ok, err = pcall(sessions.read, nil, {})
    if not ok then
      vim.notify('Session read failed: ' .. err, vim.log.levels.WARN)
    end
  end, { desc = 'Session: restore (default)' })

  -- Select & read
  map('n', '<leader>qS', function()
    sessions.select 'read'
  end, { desc = 'Session: select/read' })

  -- Write global session (cwd-based name)
  map('n', '<leader>qw', function()
    sessions.write(cwd_session_name(), { force = true })
  end, { desc = 'Session: write (cwd global)' })

  -- Write (update) currently active session (if any) without forcing new name
  map('n', '<leader>qv', function()
    sessions.write(nil, { force = true, verbose = true })
  end, { desc = 'Session: update current' })

  -- Write local session (Session.vim in project)
  map('n', '<leader>qW', function()
    sessions.write(sessions.config.file, { force = true })
  end, { desc = 'Session: write (local)' })

  -- Prompt for custom name (default suggestion)
  map('n', '<leader>qN', function()
    local suggestion = vim.fn.fnamemodify(vim.loop.cwd() or vim.fn.getcwd(), ':t') .. '.vim'
    vim.ui.input({ prompt = 'Session name: ', default = suggestion }, function(input)
      if input and input ~= '' then
        sessions.write(input, { force = false })
      end
    end)
  end, { desc = 'Session: write (named)' })

  -- Restore last (tracked via hooks)
  map('n', '<leader>ql', function()
    if _G.__last_session then
      pcall(sessions.read, _G.__last_session, {})
    else
      vim.notify('No last session', vim.log.levels.WARN)
    end
  end, { desc = 'Session: restore last' })

  -- Delete (picker)
  map('n', '<leader>qD', function()
    sessions.select 'delete'
  end, { desc = 'Session: delete (select)' })

  -- Toggle autowrite (this not work)
  -- map('n', '<leader>qt', function()
  --   sessions.config.autowrite = not sessions.config.autowrite
  --   vim.notify('Session autowrite: ' .. (sessions.config.autowrite and 'ON' or 'OFF'))
  -- end, { desc = 'Session: toggle autowrite' })
end
return M
