local map = vim.keymap.set

map({ 'n', 'v' }, '<leader>mr', '<plug>SnipRun', { silent = true, desc = 'Run code block' })
map('n', '<leader>mc', '<CMD>SnipClose<CR>', { silent = true, desc = 'Close code block' })
map('n', '<leader>mC', '<cmd>SnipReplMemoryClean<cr>', { silent = true, desc = 'REPL memory clean' })
