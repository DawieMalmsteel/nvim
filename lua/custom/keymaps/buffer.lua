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

map('n', '<leader>bS', function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end, { desc = 'New Scratch Buffer' })

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
