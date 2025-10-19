-- Misc settings & GUI specific tweaks

vim.treesitter.language.register('markdown', 'minifiles')
vim.opt.termguicolors = true
vim.g.python3_host_prog = '/usr/bin/python3'
-- vim.o.shell = 'bash' -- for markdown-org integrations
vim.o.shell = 'fish' -- for chad terminal integrations
