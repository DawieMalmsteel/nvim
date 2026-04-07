local function set(name, opts)
  opts = opts or {}
  if opts.bg == nil then
    opts.bg = 'NONE'
  end
  pcall(vim.api.nvim_set_hl, 0, name, opts)
end

-- -------------------------
-- MiniTabline (All)
-- -------------------------
set('MiniTablineCurrent', { fg = '#7aa2f7' })
set('MiniTablineVisible', { fg = '#7e8294' })
set('MiniTablineHidden', { fg = '#3b4261' })

set('MiniTablineModifiedCurrent', { fg = '#e0af68' })
set('MiniTablineModifiedVisible', { fg = '#f7768e' })
set('MiniTablineModifiedHidden', { fg = '#e0af68' })

set('MiniTablineTabpagesection', { fg = '#9ece6a' })
set('MiniTablineFill', { fg = '#3b4261' })
set('MiniTablineTrunc', { fg = '#3b4261' })

-- -------------------------
-- MiniStarter & MiniHipatterns
-- -------------------------
set('MiniStarterItemBullet', { fg = '#7aa2f7' })
set('MiniHipatterns_abb2bf_bg', { fg = '#7e8294' })
set('MiniHipatterns_61afef_bg', { fg = '#7aa2f7' })

-- -------------------------
-- StatusLine
-- -------------------------
set('StatusLine', { fg = nil })
set('StatusLineNC', { fg = nil })

-- MiniStatusline groups
set('MiniStatuslineModeOther', { fg = '#bb9af7' })
set('MiniStatuslineDevinfo', { fg = '#7dcfff' })

set('MiniStatuslineDiagnostics', { fg = '#f7768e' })
set('MiniStatuslineDiagnosticsError', { fg = '#f7768e' })
set('MiniStatuslineDiagnosticsWarn', { fg = '#e0af68' })
set('MiniStatuslineDiagnosticsInfo', { fg = '#7dcfff' })
set('MiniStatuslineDiagnosticsHint', { fg = '#a6e22e' })

set('MiniStatuslineFilename', { fg = '#f5e0dc' })
set('MiniStatuslineLocation', { fg = '#f7768e' })
set('MiniStatuslineRecording', { fg = '#f7768e' })
set('MiniStatuslineProgress', { fg = '#bb9af7' })
set('MiniStatuslineHarpoon', { fg = '#9ece6a' })
set('MiniStatuslineModified', { fg = '#e0af68' })

set('MiniStatuslineInactive', { fg = '#545c7e' })
set('MiniStatuslineInactiveTab', { fg = '#7e8294' })

-- -------------------------
-- TabLine
-- -------------------------
set('TabLine', { fg = '#7e8294' })
set('TabLineSel', { fg = '#1a1b26', bg = '#7aa2f7' }) -- Selected tab
set('TabLineFill', { fg = '#3b4261' })

-- transparent background
-- vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'MiniMapNormal', { bg = '#7aa2f7' })
-- vim.api.nvim_set_hl(0, 'ColorColumn', { bg = 'none' })
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
--
-- -- transparent background for neotree
-- vim.api.nvim_set_hl(0, 'NeoTreeNormal', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NeoTreeVertSplit', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NeoTreeWinSeparator', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NeoTreeEndOfBuffer', { bg = 'none' })
--
-- -- transparent background for nvim-tree
-- vim.api.nvim_set_hl(0, 'NvimTreeNormal', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NvimTreeVertSplit', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NvimTreeEndOfBuffer', { bg = 'none' })
--
-- -- transparent notify background
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
