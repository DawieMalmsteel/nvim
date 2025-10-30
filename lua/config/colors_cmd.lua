vim.cmd [[
           highlight MiniTablineModifiedCurrent guifg=#e0af68
           highlight MiniTablineModifiedVisible guifg=#f7768e
           highlight MiniTablineModifiedHidden guifg=#e0af68
           highlight MiniTablineTabpagesection guifg=#9ece6a
           highlight MiniTablineFill guifg=#3b4261
           highlight MiniTablineTrunc guifg=#3b4261
           highlight MiniStarterItemBullet guifg=#7aa2f7
           highlight MiniHipatterns_abb2bf_bg guifg=#7e8294
           highlight MiniHipatterns_61afef_bg guifg=#7aa2f7

           highlight StatusLine guibg=NONE
           highlight StatusLineNC guibg=NONE

           highlight MiniStatuslineModeOther guifg=#bb9af7 guibg=NONE
           highlight MiniStatuslineDevinfo guifg=#7dcfff guibg=NONE
           highlight MiniStatuslineDiagnostics guifg=#f7768e guibg=NONE
           highlight MiniStatuslineDiagnosticsError guifg=#f7768e guibg=NONE
           highlight MiniStatuslineDiagnosticsWarn guifg=#e0af68 guibg=NONE
           highlight MiniStatuslineDiagnosticsInfo guifg=#7dcfff guibg=NONE
           highlight MiniStatuslineDiagnosticsHint guifg=#a6e22e guibg=NONE
           highlight MiniStatuslineFilename guifg=#f5e0dc guibg=NONE
           highlight MiniStatuslineLocation guifg=#f7768e guibg=NONE
           highlight MiniStatuslineRecording guifg=#f7768e guibg=NONE
           highlight MiniStatuslineInactive guifg=#545c7e guibg=NONE
           highlight MiniStatuslineProgress guifg=#bb9af7 guibg=NONE
           highlight MiniStatuslineHarpoon guifg=#9ece6a guibg=NONE
           highlight MiniStatuslineModified guifg=#e0af68 guibg=NONE
           highlight MiniStatuslineInactiveTab guifg=#7e8294 guibg=NONE
           "highlight MiniStatuslineInactiveTab guifg=#313244 guibg=NONE

           highlight TabLine guibg=NONE guifg=#7e8294
           highlight TabLineSel guibg=#7aa2f7 guifg=#1a1b26
           highlight TabLineFill guibg=NONE guifg=#3b4261

           highlight MiniTablineCurrent guibg=NONE guifg=#7aa2f7
           highlight MiniTablineVisible guibg=NONE guifg=#7e8294
           highlight MiniTablineHidden guibg=NONE guifg=#3b4261

           highlight MiniTablineModifiedCurrent guibg=NONE guifg=#e0af68
           highlight MiniTablineModifiedVisible guibg=NONE guifg=#f7768e
           highlight MiniTablineModifiedHidden guibg=NONE guifg=#e0af68
           highlight MiniTablineTabpagesection guibg=NONE guifg=#9ece6a
           highlight MiniTablineFill guibg=NONE guifg=#3b4261
           highlight MiniTablineTrunc guibg=NONE guifg=#3b4261
         ]]

-- transparent background
-- vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'Terminal', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'FoldColumn', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'Folded', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'WhichKeyFloat', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { bg = 'none' })

-- transparent background for neotree
-- vim.api.nvim_set_hl(0, 'NeoTreeNormal', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NeoTreeVertSplit', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NeoTreeWinSeparator', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NeoTreeEndOfBuffer', { bg = 'none' })

-- transparent background for nvim-tree
-- vim.api.nvim_set_hl(0, 'NvimTreeNormal', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NvimTreeVertSplit', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NvimTreeEndOfBuffer', { bg = 'none' })

-- transparent notify background
-- vim.api.nvim_set_hl(0, 'NotifyINFOBody', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NotifyERRORBody', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NotifyWARNBody', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NotifyTRACEBody', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NotifyDEBUGBody', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NotifyINFOTitle', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NotifyERRORTitle', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NotifyWARNTitle', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NotifyTRACETitle', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NotifyDEBUGTitle', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NotifyINFOBorder', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NotifyERRORBorder', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NotifyWARNBorder', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NotifyTRACEBorder', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NotifyDEBUGBorder', { bg = 'none' })
