return {
  -- dir = '~/Projects/gtranslate',
  'DawieMalmsteel/gtranslate',
  -- this is for local plugin development
  name = 'gtranslate',
  cmd = { 'Gtrans', 'Atrans', 'Etrans' },
  keys = {
    { '<leader>tt', mode = 'v', desc = 'Google Translate' },
    { '<leader>ta', mode = 'v', desc = 'Gemini AI Translate' },
    { '<leader>te', mode = 'v', desc = 'Gemini Explain' },
  },
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
