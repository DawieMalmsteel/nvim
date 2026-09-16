local pack = require 'custom.pack'

-- [[ gtranslate ]]
-- (the old `dir = '~/Projects/gtranslate'` local-dev override stays commented)
pack.add { pack.gh 'DawieMalmsteel/gtranslate' }

require('gtranslate').setup {
  target_lang = 'vi',
  gemini_model = 'gemini-2.0-flash',
}

-- Dịch nhanh bằng Google
vim.keymap.set('v', '<leader>tt', ":'<,'>Gtrans<CR>", { desc = 'Google Translate' })
-- Dịch chuẩn bằng AI
vim.keymap.set('v', '<leader>ta', ":'<,'>Atrans<CR>", { desc = 'Gemini AI Translate' })
vim.keymap.set('v', '<leader>te', ":'<,'>Etrans<CR>", { desc = 'Gemini Explain' })

-- vim: ts=2 sts=2 sw=2 et
