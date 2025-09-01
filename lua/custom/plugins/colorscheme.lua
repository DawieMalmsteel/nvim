return {
  {
    'polirritmico/monokai-nightasty.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      dark_style_background = 'transparent',
      light_style_background = 'transparent',
      hl_styles = {
        floats = 'transparent',
        sidebars = 'transparent',
      },
      markdown_header_marks = true,
    },
  },
  {
    'zenbones-theme/zenbones.nvim',
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = 'rktjmp/lush.nvim',
    lazy = false,
    priority = 1000,
    -- you can set set configuration options here
    -- config = function()
    --     vim.g.zenbones_darken_comments = 45
    --     vim.cmd.colorscheme('zenbones')
    -- end
  },
  {
    'AlexvZyl/nordic.nvim',
    config = function()
      require('nordic').setup {
        transparent = {
          bg = true,
          float = true,
        },
      }

      -- vim.cmd.colorscheme 'monokai-nightasty'
      -- vim.opt.background = 'light'
      vim.cmd.colorscheme 'zenbones'

      --   vim.cmd [[
      --     highlight TabLine guibg=NONE guifg=#abb2bf
      --     highlight TabLineSel guibg=#61afef guifg=#282c34
      --     highlight TabLineFill guibg=NONE guifg=#5c6370
      --
      --     highlight MiniTablineCurrent guibg=NONE guifg=#61afef
      --     highlight MiniTablineVisible guibg=NONE guifg=#abb2bf
      --     highlight MiniTablineHidden guibg=NONE guifg=#5c6370
      --     highlight MiniTablineModifiedCurrent guibg=NONE guifg=#e5c07b
      --     highlight MiniTablineModifiedVisible guibg=NONE guifg=#e06c75
      --     highlight MiniTablineModifiedHidden guibg=NONE guifg=#e5c07b
      --     highlight MiniTablineTabpagesection guibg=NONE guifg=#98c379
      --     highlight MiniTablineFill guibg=NONE guifg=#5c6370
      --     highlight MiniTablineTrunc guibg=NONE guifg=#5c6370
      --     highlight MiniStarterItemBullet guibg=NONE guifg=#61afef
      --     highlight MiniHipatterns_abb2bf_bg guibg=NONE guifg=#abb2bf
      --     highlight MiniHipatterns_61afef_bg guibg=NONE guifg=#61afef
      --
      --     highlight StatusLine guibg=NONE
      --     highlight StatusLineNC guibg=NONE
      --     highlight StatusLineTerm guibg=NONE
      --     highlight StatusLineTermNC guibg=NONE
      --
      --     highlight CopilotChatHeader guifg=#7C3AED gui=bold
      --     highlight CopilotChatSeparator guifg=#374151
      --
      --     highlight MiniStarterItem guibg=NONE guifg=#d8dee9
      --     highlight MiniStarterFooter guibg=NONE guifg=#81a1c1
      --     highlight MiniStarterHeader guibg=NONE guifg=#88c0d0 gui=bold
      --     highlight MiniStarterInactive guibg=NONE guifg=#4c566a
      --     highlight MiniStarterItemBullet guibg=NONE guifg=#61afef
      --     highlight MiniStarterItemPrefix guibg=NONE guifg=#a3be8c
      --     highlight MiniStarterSection guibg=NONE guifg=#ebcb8b gui=bold
      --     highlight MiniStarterQuery guibg=NONE guifg=#b48ead
      --   ]]
      --
      --   -- Màu chữ (fg) khác nhau, bỏ bg hoàn toàn (NONE)
      --   -- vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormal', { fg = '#cba6f7', bg = 'NONE' })
      --   -- vim.api.nvim_set_hl(0, 'MiniStatuslineModeInsert', { fg = '#a6e3a1', bg = 'NONE' })
      --   -- vim.api.nvim_set_hl(0, 'MiniStatuslineModeVisual', { fg = '#f9e2af', bg = 'NONE' })
      --   -- vim.api.nvim_set_hl(0, 'MiniStatuslineModeCommand', { fg = '#fab387', bg = 'NONE' })
      --   -- vim.api.nvim_set_hl(0, 'MiniStatuslineModeReplace', { fg = '#f38ba8', bg = 'NONE' })
      --   vim.api.nvim_set_hl(0, 'MiniStatuslineModeOther', { fg = '#b4befe', bg = 'NONE' })
      --   vim.api.nvim_set_hl(0, 'MiniStatuslineDevinfo', { fg = '#89b4fa', bg = 'NONE' })
      --   vim.api.nvim_set_hl(0, 'MiniStatuslineDiagnostics', { fg = '#f38ba8', bg = 'NONE' })
      --   vim.api.nvim_set_hl(0, 'MiniStatuslineDiagnosticsError', { fg = '#f38ba8', bg = 'NONE' })
      --   vim.api.nvim_set_hl(0, 'MiniStatuslineDiagnosticsWarn', { fg = '#f9e2af', bg = 'NONE' })
      --   vim.api.nvim_set_hl(0, 'MiniStatuslineDiagnosticsInfo', { fg = '#89b4fa', bg = 'NONE' })
      --   vim.api.nvim_set_hl(0, 'MiniStatuslineDiagnosticsHint', { fg = '#a6e3a1', bg = 'NONE' })
      --   vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { fg = '#cdd6f4', bg = 'NONE' })
      --   vim.api.nvim_set_hl(0, 'MiniStatuslineLocation', { fg = '#f38ba8', bg = 'NONE' })
      --   vim.api.nvim_set_hl(0, 'MiniStatuslineRecording', { fg = '#f38ba8', bg = 'NONE' })
      --   vim.api.nvim_set_hl(0, 'MiniStatuslineInactive', { fg = '#45475a', bg = 'NONE' })
      --   vim.api.nvim_set_hl(0, 'MiniStatuslineProgress', { fg = '#cba6f7', bg = 'NONE' })
      --   vim.api.nvim_set_hl(0, 'MiniStatuslineHarpoon', { fg = '#fab387', bg = 'NONE' })
      --   vim.api.nvim_set_hl(0, 'MiniStatuslineModified', { fg = '#e5c07b', bg = 'NONE' })
    end,
  },
}
