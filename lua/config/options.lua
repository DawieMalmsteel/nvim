-- Core options & globals
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.cmdheight = 0

vim.o.mouse = 'a'

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldenable = true
vim.o.foldlevel = 99

vim.o.showmode = false
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = false
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 8
vim.o.confirm = true
-- vim.o.showtabline = 2
-- function _G.MyTabline()
--   local s = ''
--   for i = 1, vim.fn.tabpagenr '$' do
--     local winnr = vim.fn.tabpagewinnr(i)
--     local buflist = vim.fn.tabpagebuflist(i)
--     local bufnr = buflist[winnr]
--     local bufname = vim.fn.bufname(bufnr)
--
--     -- Chỗ thay đổi quan trọng: dùng fnamemodify để lấy full relative path
--     local path = bufname ~= '' and vim.fn.fnamemodify(bufname, ':.') or '[No Name]'
--
--     if i == vim.fn.tabpagenr() then
--       s = s .. '%#TabLineSel#'
--     else
--       s = s .. '%#TabLine#'
--     end
--
--     s = s .. ' ' .. i .. ': ' .. path .. ' '
--   end
--   s = s .. '%#TabLineFill#'
--   return s
-- end
--
-- vim.o.tabline = '%!v:lua.MyTabline()'
