local map = vim.keymap.set

map('n', '<leader>N', ":lua require('mini.files').open(vim.fn.stdpath('config') .. '/notes', true)<CR>", { desc = 'Open notes folder' })
