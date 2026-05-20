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

map('n', '<leader>bn', function()
  vim.cmd.enew()
end, { desc = 'Open New File' })

-- Open a split window on the right (20% width)
vim.keymap.set('n', '<leader>bv', function()
  local main_win = vim.api.nvim_get_current_win()
  
  -- Mở cửa sổ mới cố định ở bên phải
  vim.cmd('rightbelow vnew')
  local right_win = vim.api.nvim_get_current_win()
  local right_buf = vim.api.nvim_win_get_buf(right_win)
  
  -- Thiết lập độ rộng bằng 20% tổng màn hình
  vim.api.nvim_win_set_width(right_win, math.floor(vim.o.columns * 0.2))
  
  -- Ẩn các thành phần giao diện để biến cửa sổ này thành khoảng trống
  vim.wo[right_win].number = false
  vim.wo[right_win].relativenumber = false
  vim.wo[right_win].signcolumn = 'no'
  vim.wo[right_win].statusline = ' '
  vim.wo[right_win].winbar = ''
  
  -- Thiết lập buffer trống, tự xóa khi đóng
  vim.bo[right_buf].buftype = 'nofile'
  vim.bo[right_buf].bufhidden = 'wipe'
  vim.bo[right_buf].filetype = 'nofile'
  
  -- Đưa con trỏ quay lại cửa sổ chính bên trái
  vim.api.nvim_set_current_win(main_win)
end, { desc = 'Create 20% Right Padding' })

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
