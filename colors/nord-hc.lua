-- Nord High Contrast Colorscheme
-- Standalone implementation using authentic Nord palette
-- with high contrast modifications
-- Based on NordStone approach: simple, clean, no dependencies

if vim.g.colors_name == "nord-hc" then
  return
end

vim.cmd("highlight clear")

if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

-- Enable true color
vim.opt.termguicolors = true

-- ============================================================================
-- NORD PALETTE (Authentic Colors)
-- ============================================================================

local palette = {
  -- Nord Polar Night (Backgrounds)
  nord0 = "#2e3440",       -- Default background
  nord1 = "#3b4252",       -- Lighter background
  nord2 = "#434c5e",       -- Even lighter background
  nord3 = "#4c566a",       -- Comments/UI

  -- Nord Snow Storm (Foregrounds)
  nord4 = "#d8dee9",       -- Main foreground
  nord5 = "#e5e9f0",       -- Lighter foreground
  nord6 = "#eceff4",       -- Brightest foreground

  -- Nord Frost (Blues/Teals)
  nord7 = "#8fbcbb",       -- Teal (types)
  nord8 = "#88c0d0",       -- Cyan (functions)
  nord9 = "#81a1c1",       -- Blue (keywords)
  nord10 = "#5e81ac",      -- Dark blue

  -- Nord Aurora (Colors)
  nord11 = "#bf616a",      -- Red (errors)
  nord12 = "#d08770",      -- Orange
  nord13 = "#ebcb8b",      -- Yellow
  nord14 = "#a3be8c",      -- Green (strings)
  nord15 = "#b48ead",      -- Purple (numbers)

  -- High Contrast Customization
  hc_bg = "#0d0f14",       -- Very dark background (darker than nord0)
  hc_fg = "#e8f0f8",       -- Bright foreground (brighter than nord6)
  hc_fg_dim = "#c0c8d0",   -- Dimmed foreground for secondary text

  -- Nord variants for UI
  nord3_600 = "#616e88",   -- Comments (darker)
  nord1_bright = "#4a5568", -- UI backgrounds

  -- Special colors
  none = "NONE",
}

-- ============================================================================
-- HIGHLIGHT HELPER FUNCTION
-- ============================================================================

local function hl(group, fg, bg, attr)
  attr = attr or {}
  local hl_def = {}

  if fg then hl_def.fg = fg end
  if bg then hl_def.bg = bg end

  if attr.bold then hl_def.bold = true end
  if attr.italic then hl_def.italic = true end
  if attr.underline then hl_def.underline = true end
  if attr.undercurl then hl_def.undercurl = true end
  if attr.reverse then hl_def.reverse = true end

  vim.api.nvim_set_hl(0, group, hl_def)
end

-- ============================================================================
-- EDITOR UI HIGHLIGHTS
-- ============================================================================

hl("Normal", palette.hc_fg, palette.hc_bg)
hl("NormalNC", palette.hc_fg_dim, palette.hc_bg)
hl("NormalFloat", palette.hc_fg, palette.nord1_bright)
hl("FloatBorder", palette.nord3, palette.nord1_bright)

-- Cursor and selection
hl("Cursor", palette.hc_bg, palette.hc_fg)
hl("CursorLine", nil, palette.nord1_bright)
hl("CursorLineNr", palette.nord8, palette.nord1_bright, { bold = true })
hl("LineNr", palette.nord3_600, nil)

-- Selection and search
hl("Visual", nil, palette.nord1_bright)
hl("VisualNOS", nil, palette.nord1_bright)
hl("Search", palette.hc_bg, palette.nord13, { bold = true })
hl("IncSearch", palette.hc_bg, palette.nord13, { bold = true })
hl("CurSearch", palette.hc_bg, palette.nord11, { bold = true })

-- UI elements
hl("Pmenu", palette.hc_fg, palette.nord1_bright)
hl("PmenuSel", palette.hc_bg, palette.nord8, { bold = true })
hl("PmenuSbar", nil, palette.nord2)
hl("PmenuThumb", nil, palette.nord3)

hl("Folded", palette.nord3, palette.nord1_bright)
hl("FoldColumn", palette.nord3_600, nil)
hl("SignColumn", nil, nil)

-- Status line
hl("StatusLine", palette.hc_fg, palette.nord1_bright)
hl("StatusLineNC", palette.nord3_600, palette.nord0)
hl("VertSplit", palette.nord3, nil)
hl("WinSeparator", palette.nord3, nil)

-- Tab line
hl("TabLine", palette.nord3_600, palette.nord0)
hl("TabLineSel", palette.hc_fg, palette.nord8)
hl("TabLineFill", nil, palette.nord0)

-- Command line
hl("WildMenu", palette.hc_bg, palette.nord8)
hl("MsgArea", palette.hc_fg, nil)
hl("MsgSeparator", palette.nord3, palette.hc_bg)

-- ============================================================================
-- SYNTAX HIGHLIGHTING - KEYWORDS & STATEMENTS
-- ============================================================================

hl("Keyword", palette.nord9, nil, { bold = true })
hl("Statement", palette.nord9, nil, { bold = true })
hl("Conditional", palette.nord9, nil, { bold = true })
hl("Repeat", palette.nord9, nil, { bold = true })
hl("Label", palette.nord9, nil)
hl("Operator", palette.nord8, nil)
hl("Exception", palette.nord11, nil, { bold = true })

-- ============================================================================
-- SYNTAX HIGHLIGHTING - COMMENTS & STRINGS
-- ============================================================================

hl("Comment", palette.nord3_600, nil, { italic = true })
hl("String", palette.nord14, nil)
hl("StringDelimiter", palette.nord14, nil)
hl("Character", palette.nord14, nil)

-- ============================================================================
-- SYNTAX HIGHLIGHTING - NUMBERS, IDENTIFIERS, TYPES
-- ============================================================================

hl("Number", palette.nord15, nil)
hl("Float", palette.nord15, nil)
hl("Boolean", palette.nord15, nil, { bold = true })
hl("Constant", palette.nord13, nil, { bold = true })
hl("Define", palette.nord13, nil)
hl("Macro", palette.nord13, nil)

hl("Identifier", palette.hc_fg, nil)
hl("Function", palette.nord8, nil, { bold = true })
hl("Type", palette.nord8, nil, { bold = true })
hl("StorageClass", palette.nord9, nil, { bold = true })
hl("Structure", palette.nord8, nil, { bold = true })
hl("Typedef", palette.nord8, nil, { bold = true })

-- ============================================================================
-- SYNTAX HIGHLIGHTING - SPECIAL & DECORATORS
-- ============================================================================

hl("Special", palette.nord12, nil)
hl("SpecialChar", palette.nord12, nil)
hl("SpecialComment", palette.nord3_600, nil, { italic = true })
hl("Tag", palette.nord9, nil, { bold = true })
hl("Delimiter", palette.hc_fg, nil)
hl("PreProc", palette.nord13, nil)
hl("Include", palette.nord13, nil)
hl("Import", palette.nord13, nil)
hl("Repeat", palette.nord9, nil, { bold = true })

-- ============================================================================
-- SYNTAX HIGHLIGHTING - ERRORS & WARNINGS
-- ============================================================================

hl("Error", palette.nord11, palette.hc_bg, { bold = true })
hl("ErrorMsg", palette.nord11, nil, { bold = true })
hl("WarningMsg", palette.nord13, nil, { bold = true })
hl("ModeMsg", palette.nord8, nil, { bold = true })
hl("Question", palette.nord14, nil)

-- ============================================================================
-- DIAGNOSTICS
-- ============================================================================

hl("DiagnosticError", palette.nord11, nil)
hl("DiagnosticWarn", palette.nord13, nil)
hl("DiagnosticInfo", palette.nord8, nil)
hl("DiagnosticHint", palette.nord7, nil)
hl("DiagnosticOk", palette.nord14, nil)

hl("DiagnosticVirtualTextError", palette.nord11, nil, { italic = true })
hl("DiagnosticVirtualTextWarn", palette.nord13, nil, { italic = true })
hl("DiagnosticVirtualTextInfo", palette.nord8, nil, { italic = true })
hl("DiagnosticVirtualTextHint", palette.nord7, nil, { italic = true })
hl("DiagnosticVirtualTextOk", palette.nord14, nil, { italic = true })

hl("DiagnosticUnderlineError", nil, nil, { undercurl = true })
hl("DiagnosticUnderlineWarn", nil, nil, { undercurl = true })
hl("DiagnosticUnderlineInfo", nil, nil, { undercurl = true })
hl("DiagnosticUnderlineHint", nil, nil, { undercurl = true })

-- ============================================================================
-- TREE-SITTER (Language-specific highlights)
-- ============================================================================

-- Most tree-sitter highlights link to standard syntax groups, so they inherit
-- But some specific ones can be customized:
hl("@keyword", palette.nord9, nil, { bold = true })
hl("@keyword.function", palette.nord9, nil, { bold = true })
hl("@keyword.return", palette.nord9, nil, { bold = true })
hl("@function", palette.nord8, nil, { bold = true })
hl("@function.builtin", palette.nord8, nil)
hl("@function.call", palette.nord8, nil)
hl("@method", palette.nord8, nil, { bold = true })
hl("@method.call", palette.nord8, nil)
hl("@variable", palette.hc_fg, nil)
hl("@variable.builtin", palette.nord9, nil, { bold = true })
hl("@type", palette.nord8, nil)
hl("@type.builtin", palette.nord8, nil)
hl("@string", palette.nord14, nil)
hl("@string.regex", palette.nord14, nil)
hl("@string.escape", palette.nord12, nil)
hl("@number", palette.nord15, nil)
hl("@boolean", palette.nord15, nil, { bold = true })
hl("@constant", palette.nord13, nil, { bold = true })
hl("@constant.builtin", palette.nord13, nil)
hl("@attribute", palette.nord13, nil)
hl("@comment", palette.nord3_600, nil, { italic = true })
hl("@punctuation", palette.hc_fg, nil)
hl("@operator", palette.nord8, nil)

-- ============================================================================
-- LSP HIGHLIGHTS
-- ============================================================================

hl("LspReferenceText", nil, palette.nord1_bright)
hl("LspReferenceRead", nil, palette.nord1_bright)
hl("LspReferenceWrite", nil, palette.nord1_bright)

hl("LspSignatureActiveParameter", nil, palette.nord1_bright, { bold = true })
hl("LspInlayHint", palette.nord3_600, palette.nord1_bright, { italic = true })

-- ============================================================================
-- GIT SIGNS
-- ============================================================================

hl("GitSignsAdd", palette.nord14, nil)
hl("GitSignsChange", palette.nord8, nil)
hl("GitSignsDelete", palette.nord11, nil)
hl("GitSignsAddNr", palette.nord14, nil)
hl("GitSignsChangeNr", palette.nord8, nil)
hl("GitSignsDeleteNr", palette.nord11, nil)

-- ============================================================================
-- DIFF HIGHLIGHTS
-- ============================================================================

hl("DiffAdd", palette.nord14, palette.nord0, { bold = true })
hl("DiffChange", palette.nord8, palette.nord0)
hl("DiffDelete", palette.nord11, palette.nord0, { bold = true })
hl("DiffText", palette.nord13, palette.nord1_bright, { bold = true })

-- ============================================================================
-- SPELL CHECKING
-- ============================================================================

hl("SpellBad", palette.nord11, nil, { undercurl = true })
hl("SpellCap", palette.nord8, nil, { undercurl = true })
hl("SpellLocal", palette.nord7, nil, { undercurl = true })
hl("SpellRare", palette.nord13, nil, { undercurl = true })

-- ============================================================================
-- TERMINAL COLORS
-- ============================================================================

vim.g.terminal_color_0 = palette.nord1
vim.g.terminal_color_1 = palette.nord11
vim.g.terminal_color_2 = palette.nord14
vim.g.terminal_color_3 = palette.nord13
vim.g.terminal_color_4 = palette.nord9
vim.g.terminal_color_5 = palette.nord15
vim.g.terminal_color_6 = palette.nord8
vim.g.terminal_color_7 = palette.nord5

vim.g.terminal_color_8 = palette.nord3
vim.g.terminal_color_9 = palette.nord11
vim.g.terminal_color_10 = palette.nord14
vim.g.terminal_color_11 = palette.nord13
vim.g.terminal_color_12 = palette.nord9
vim.g.terminal_color_13 = palette.nord15
vim.g.terminal_color_14 = palette.nord7
vim.g.terminal_color_15 = palette.nord6

-- ============================================================================
-- Set colors_name to indicate theme is loaded
-- ============================================================================

vim.g.colors_name = "nord-hc"
