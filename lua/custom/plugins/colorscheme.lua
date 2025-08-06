return {
  -- { 'sainnhe/gruvbox-material' },
  { 'rebelot/kanagawa.nvim' },
  {
    'AlexvZyl/nordic.nvim',
    config = function()
      require('nordic').setup {
        transparent = {
          bg = true,
          float = true,
        },
      }
      vim.cmd.colorscheme 'kanagawa'

      vim.cmd [[
        highlight TabLine guibg=NONE guifg=#abb2bf
        highlight TabLineSel guibg=#61afef guifg=#282c34
        highlight TabLineFill guibg=NONE guifg=#5c6370

        highlight MiniTablineCurrent guibg=NONE guifg=#98c379
        highlight MiniTablineVisible guibg=NONE guifg=#abb2bf
        highlight MiniTablineHidden guibg=NONE guifg=#5c6370
        highlight MiniTablineModifiedCurrent guibg=NONE guifg=#e06c75
        highlight MiniTablineModifiedVisible guibg=NONE guifg=#e5c07b
        highlight MiniTablineModifiedHidden guibg=NONE guifg=#e5c07b
        highlight MiniTablineTabpagesection guibg=NONE guifg=#61afef
        highlight MiniTablineFill guibg=NONE guifg=#5c6370
        highlight MiniTablineTrunc guibg=NONE guifg=#5c6370
        highlight MiniStarterItemBullet guibg=NONE guifg=#61afef
        highlight MiniHipatterns_abb2bf_bg guibg=NONE guifg=#abb2bf
        highlight MiniHipatterns_61afef_bg guibg=NONE guifg=#61afef

        highlight StatusLine guibg=NONE
        highlight StatusLineNC guibg=NONE
        highlight StatusLineTerm guibg=NONE
        highlight StatusLineTermNC guibg=NONE

        highlight CopilotChatHeader guifg=#7C3AED gui=bold
        highlight CopilotChatSeparator guifg=#374151

        highlight MiniStarterItem guibg=NONE guifg=#d8dee9
        highlight MiniStarterFooter guibg=NONE guifg=#81a1c1
        highlight MiniStarterHeader guibg=NONE guifg=#88c0d0 gui=bold
        highlight MiniStarterInactive guibg=NONE guifg=#4c566a
        highlight MiniStarterItemBullet guibg=NONE guifg=#61afef
        highlight MiniStarterItemPrefix guibg=NONE guifg=#a3be8c
        highlight MiniStarterSection guibg=NONE guifg=#ebcb8b gui=bold
        highlight MiniStarterQuery guibg=NONE guifg=#b48ead
      ]]
    end,
  },
}
