return {
  dir = '~/Projects/gtranslate',
  -- this is for local plugin development
  name = 'gtranslate',
  config = function()
    require('gtranslate').setup {
      target_lang = 'vi',
    }

    -- Dịch nhanh bằng Google
    vim.keymap.set('v', '<leader>tt', ":'<,'>Gtrans<CR>", { desc = 'Dịch Google' })
    -- Dịch chuẩn bằng AI
    vim.keymap.set('v', '<leader>ta', ":'<,'>Atrans<CR>", { desc = 'Dịch Gemini AI' })
  end,
}
