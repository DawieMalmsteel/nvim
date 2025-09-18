local map = vim.keymap.set
local TEMP = vim.fn.stdpath 'cache' .. '/temp.md'

map('n', '<leader>bd', function()
  local Snacks = require 'snacks'
  Snacks.bufdelete()
end, { desc = 'Delete Buffer' })

-- Close Hidden Buffers
map('n', '<leader>bh', function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(buf) == 1 and vim.fn.bufwinnr(buf) == -1 then
      require('mini.bufremove').delete(buf, false)
    end
  end
end, { desc = 'Close Others Hidden Buffers' })

-- Delete current file/dir with nicer UI (handles modified, missing, directory)
map('n', '<leader>bX', function()
  local buf = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(buf)
  if path == '' then
    vim.notify('No path for this buffer', vim.log.levels.WARN)
    return
  end
  local uv = vim.uv or vim.loop
  local function stat(p)
    local ok, s = pcall(uv.fs_stat, p)
    if not ok then
      return nil
    end
    return s
  end
  ---@type {type?:string}|nil
  local s = stat(path)
  local exists = s ~= nil
  local is_dir = (s and s.type == 'directory') or false
  local fname = vim.fn.fnamemodify(path, ':t')
  local kind = is_dir and 'directory' or 'file'

  -- If buffer modified ask how to proceed first
  local function continue_after_modified(cb)
    if not vim.bo.modified then
      return cb()
    end
    vim.ui.select({ 'Save & Continue', 'Discard & Continue', 'Cancel' }, { prompt = 'Buffer modified. How proceed?' }, function(choice)
      if choice == 'Save & Continue' then
        vim.cmd.write()
        cb()
      elseif choice == 'Discard & Continue' then
        cb()
      end
    end)
  end

  local function perform_delete()
    if not exists then
      vim.ui.select({ 'Close Buffer', 'Cancel' }, { prompt = 'Path does not exist on disk. Close buffer?' }, function(choice)
        if choice == 'Close Buffer' then
          require('mini.bufremove').delete(buf, true)
          vim.notify('Closed buffer (no file on disk)', vim.log.levels.INFO)
        end
      end)
      return
    end

    local prompt = ('Delete %s "%s"%s'):format(kind, fname, is_dir and ' (recursive)' or '')
    vim.ui.select({ 'Yes', 'No' }, { prompt = prompt }, function(choice)
      if choice ~= 'Yes' then
        return
      end
      -- Important: don't pass nil as 2nd arg; call variant without flags for files.
      local ok, res
      if is_dir then
        ok, res = pcall(vim.fn.delete, path, 'rf')
      else
        ok, res = pcall(vim.fn.delete, path)
      end
      if not ok or res ~= 0 then
        vim.notify(('Failed to delete %s: %s (code=%s)'):format(kind, path, tostring(res)), vim.log.levels.ERROR)
        return
      end
      require('mini.bufremove').delete(buf, true)
      vim.notify(('Deleted %s: %s'):format(kind, path), vim.log.levels.INFO)
    end)
  end

  continue_after_modified(perform_delete)
end, { desc = 'Delete file/dir (UI confirm)' })

-- Open (or create) single temp file
map('n', '<leader>be', function()
  vim.cmd.edit(TEMP)
  vim.bo.bufhidden = 'hide'
  vim.notify('Temp file: ' .. TEMP, vim.log.levels.INFO)
end, { desc = 'Open Temp File' })

-- Delete temp file (and close its buffer if loaded)
map('n', '<leader>bE', function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf) == TEMP then
      require('mini.bufremove').delete(buf, true)
      break
    end
  end
  local ok, err = os.remove(TEMP)
  if ok then
    vim.notify('Deleted temp file', vim.log.levels.INFO)
  else
    vim.notify('Could not delete temp file: ' .. (err or ''), vim.log.levels.WARN)
  end
end, { desc = 'Delete Temp File' })

map('n', '<leader>bn', function()
  local dir = vim.fn.expand '%:p:h' .. '/'
  require('snacks').input({ prompt = 'New file: ', default = dir }, function(path)
    if not path or path == '' or path == dir then
      return
    end
    vim.cmd('edit ' .. vim.fn.fnameescape(path))
  end)
end, { desc = 'New file (curr dir)' })
