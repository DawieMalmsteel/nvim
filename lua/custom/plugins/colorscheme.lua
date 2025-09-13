return {
  -- {
  --   'polirritmico/monokai-nightasty.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     dark_style_background = 'transparent',
  --     light_style_background = 'transparent',
  --     hl_styles = {
  --       floats = 'transparent',
  --       sidebars = 'transparent',
  --     },
  --     markdown_header_marks = true,
  --   },
  -- },
  {
    'tiagovla/tokyodark.nvim',
    lazy = false,
    opts = {
      transparent_background = false,
    },
    config = function(_, opts)
      require('tokyodark').setup(opts) -- calling setup is optional
      vim.cmd [[colorscheme tokyodark]]
    end,
  },
  -- {
  --   'AlexvZyl/nordic.nvim',
  --   config = function()
  --     require('nordic').setup {
  --       transparent = {
  --         bg = true,
  --         float = true,
  --       },
  --     }
  --
  --     -- vim.cmd.colorscheme 'nordic'
  --     -- vim.cmd.colorscheme 'tokyodark'
  --     -- vim.opt.background = 'light'
  --     -- vim.cmd.colorscheme 'randomhue'
  --
  --     vim.cmd [[
  --          highlight TabLine guibg=NONE guifg=#7e8294
  --          highlight TabLineSel guibg=#7aa2f7 guifg=#1a1b26
  --          highlight TabLineFill guibg=NONE guifg=#3b4261
  --
  --          highlight MiniTablineCurrent guibg=NONE guifg=#7aa2f7
  --          highlight MiniTablineVisible guibg=NONE guifg=#7e8294
  --          highlight MiniTablineHidden guibg=NONE guifg=#3b4261
  --
  --          highlight MiniTablineModifiedCurrent guibg=NONE guifg=#e0af68
  --          highlight MiniTablineModifiedVisible guibg=NONE guifg=#f7768e
  --          highlight MiniTablineModifiedHidden guibg=NONE guifg=#e0af68
  --          highlight MiniTablineTabpagesection guibg=NONE guifg=#9ece6a
  --          highlight MiniTablineFill guibg=NONE guifg=#3b4261
  --          highlight MiniTablineTrunc guibg=NONE guifg=#3b4261
  --          highlight MiniStarterItemBullet guibg=NONE guifg=#7aa2f7
  --          highlight MiniHipatterns_abb2bf_bg guibg=NONE guifg=#7e8294
  --          highlight MiniHipatterns_61afef_bg guibg=NONE guifg=#7aa2f7
  --
  --          highlight StatusLine guibg=NONE
  --          highlight StatusLineNC guibg=NONE
  --          highlight StatusLineTerm guibg=NONE
  --          highlight StatusLineTermNC guibg=NONE
  --
  --          highlight MiniStarterItem guibg=NONE guifg=#c0caf5
  --          highlight MiniStarterFooter guibg=NONE guifg=#7dcfff
  --          highlight MiniStarterHeader guibg=NONE guifg=#7aa2f7 gui=bold
  --          highlight MiniStarterInactive guibg=NONE guifg=#545c7e
  --          highlight MiniStarterItemBullet guibg=NONE guifg=#7aa2f7
  --          highlight MiniStarterItemPrefix guibg=NONE guifg=#9ece6a
  --          highlight MiniStarterSection guibg=NONE guifg=#e0af68 gui=bold
  --          highlight MiniStarterQuery guibg=NONE guifg=#bb9af7
  --
  --          highlight MiniStatuslineModeOther guifg=#bb9af7 guibg=NONE
  --          highlight MiniStatuslineDevinfo guifg=#7dcfff guibg=NONE
  --          highlight MiniStatuslineDiagnostics guifg=#f7768e guibg=NONE
  --          highlight MiniStatuslineDiagnosticsError guifg=#f7768e guibg=NONE
  --          highlight MiniStatuslineDiagnosticsWarn guifg=#e0af68 guibg=NONE
  --          highlight MiniStatuslineDiagnosticsInfo guifg=#7dcfff guibg=NONE
  --          highlight MiniStatuslineDiagnosticsHint guifg=#9ece6a guibg=NONE
  --          highlight MiniStatuslineFilename guifg=#c0caf5 guibg=NONE
  --          highlight MiniStatuslineLocation guifg=#f7768e guibg=NONE
  --          highlight MiniStatuslineRecording guifg=#f7768e guibg=NONE
  --          highlight MiniStatuslineInactive guifg=#545c7e guibg=NONE
  --          highlight MiniStatuslineProgress guifg=#bb9af7 guibg=NONE
  --          highlight MiniStatuslineHarpoon guifg=#e0af68 guibg=NONE
  --          highlight MiniStatuslineModified guifg=#e0af68 guibg=NONE
  --        ]]
  --   end,
  -- },
}
