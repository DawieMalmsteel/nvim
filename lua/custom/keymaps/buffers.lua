local core = require 'custom.keymaps.core'
local map = core.map

-- Điều hướng buffer
map('n', 'H', '<CMD>execute "silent! bprevious " . v:count1<CR>', { desc = 'Previous Buffer' })
map('n', 'L', '<CMD>execute "silent! bnext " . v:count1<CR>', { desc = 'Next Buffer' })

-- Đóng buffer hiện tại
map('n', '<leader>bd', function()
  local Snacks = core.sr 'snacks'
  if Snacks and Snacks.bufdelete then
    Snacks.bufdelete()
  else
    vim.cmd 'bd'
  end
end, { desc = 'Delete Buffer' })
map('n', '<leader>qb', function()
  local Snacks = core.sr 'snacks'
  if Snacks and Snacks.bufdelete then
    Snacks.bufdelete()
  else
    vim.cmd 'bd'
  end
end, { desc = 'Delete Buffer' })

-- Đóng buffer + window
map('n', '<leader>qB', '<CMD>bw<CR>', { desc = 'Quit Buffer Window' })

-- Đóng window giữ buffer
map('n', '<leader>qd', '<C-w>q', { desc = 'Close Window keep buffer' })

-- Quit all
map('n', '<leader>qq', '<CMD>qa<CR>', { desc = 'Quit All' })
map('n', '<leader>qQ', '<CMD>qa!<CR>', { desc = 'Quit All (force)' })

-- Đóng hidden buffers
local function close_hidden()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(buf) == 1 and vim.fn.bufwinnr(buf) == -1 then
      local ok, mod = pcall(require, 'mini.bufremove')
      if ok then
        mod.delete(buf, false)
      else
        pcall(vim.api.nvim_buf_delete, buf, {})
      end
    end
  end
end
map('n', '<leader>bh', close_hidden, { desc = 'Close Hidden Buffers' })

-- Đóng buffer không tên
local function close_nameless()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(buf) == 1 and vim.api.nvim_buf_get_name(buf) == '' then
      local ok, mod = pcall(require, 'mini.bufremove')
      if ok then
        mod.delete(buf, false)
      else
        pcall(vim.api.nvim_buf_delete, buf, {})
      end
    end
  end
end
map('n', '<leader>bu', close_nameless, { desc = 'Close Nameless Buffers' })
