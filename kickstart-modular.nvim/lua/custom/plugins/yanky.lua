local pack = require 'custom.pack'

-- [[ yanky.nvim ]] Better Yank/Paste
pack.add { pack.gh 'gbprod/yanky.nvim' }

require('yanky').setup {
  highlight = { timer = 150 },
}

vim.keymap.set({ 'n', 'x' }, '<leader>p', function()
  local Snacks = require 'snacks'
  Snacks.picker.yanky()
end, { desc = 'Open Yank History' })

-- stylua: ignore
local keys = {
  { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank Text" },
  { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' }, desc = 'Put Text After Cursor' },
  { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'Put Text Before Cursor' },
  { 'gp', '<Plug>(YankyGPutAfter)', mode = { 'n', 'x' }, desc = 'Put Text After Selection' },
  { 'gP', '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' }, desc = 'Put Text Before Selection' },
  { ']p', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'Put Indented After Cursor (Linewise)' },
  { '[p', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'Put Indented Before Cursor (Linewise)' },
  { ']P', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'Put Indented After Cursor (Linewise)' },
  { '[P', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'Put Indented Before Cursor (Linewise)' },
  { '>p', '<Plug>(YankyPutIndentAfterShiftRight)', desc = 'Put and Indent Right' },
  { '<p', '<Plug>(YankyPutIndentAfterShiftLeft)', desc = 'Put and Indent Left' },
  { '>P', '<Plug>(YankyPutIndentBeforeShiftRight)', desc = 'Put Before and Indent Right' },
  { '<P', '<Plug>(YankyPutIndentBeforeShiftLeft)', desc = 'Put Before and Indent Left' },
  { '=p', '<Plug>(YankyPutAfterFilter)', desc = 'Put After Applying a Filter' },
  { '=P', '<Plug>(YankyPutBeforeFilter)', desc = 'Put Before Applying a Filter' },
}

for _, key in ipairs(keys) do
  vim.keymap.set(key.mode or 'n', key[1], key[2], { desc = key.desc })
end

-- vim: ts=2 sts=2 sw=2 et
