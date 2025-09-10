local map = vim.keymap.set

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

-- Close Nameless Buffers
map('n', '<leader>bu', function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(buf) == 1 and vim.api.nvim_buf_get_name(buf) == '' then
      require('mini.bufremove').delete(buf, false)
    end
  end
end, { desc = 'Close Nameless Buffers' })
