local map = vim.keymap.set

local notes_dir = vim.fn.stdpath 'config' .. '/notes'

map('n', '<leader>N', function()
  if vim.fn.isdirectory(notes_dir) == 0 then
    vim.fn.mkdir(notes_dir, 'p')
  end
  require('mini.files').open(notes_dir, true)
end, { desc = 'Open notes folder', silent = true })
