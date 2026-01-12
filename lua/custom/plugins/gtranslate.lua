return {
  -- dir = '~/Projects/gtranslate',
  'DawieMalmsteel/gtranslate',
  -- this is for local plugin development
  name = 'gtranslate',
  config = function()
    require('gtranslate').setup {
      target_lang = 'vi',
      gemini_model = 'gemini-2.0-flash',
    }

    -- Dịch nhanh bằng Google
    vim.keymap.set('v', '<leader>tt', ":'<,'>Gtrans<CR>", { desc = 'Google Translate' })
    -- Dịch chuẩn bằng AI
    vim.keymap.set('v', '<leader>ta', ":'<,'>Atrans<CR>", { desc = 'Gemini AI Translate' })
    vim.keymap.set('v', '<leader>te', ":'<,'>Etrans<CR>", { desc = 'Gemini Explain' })
  end,
}
