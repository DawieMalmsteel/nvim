-- Load plugin modules in order.

-- [[ Kickstart default modules ]]
require 'kickstart.plugins.guess-indent'

-- The remaining kickstart default modules are not loaded: this config ports
-- its own versions of the same plugins into lua/custom/plugins/.
--
-- require 'kickstart.plugins.gitsigns'     -- custom.plugins.gitsigns
-- require 'kickstart.plugins.which-key'    -- custom.plugins.whichkey
-- require 'kickstart.plugins.tokyonight'   -- custom.plugins.colorscheme
-- require 'kickstart.plugins.todo-comments' -- custom.plugins.todo
-- require 'kickstart.plugins.mini'         -- custom.plugins.mini
-- require 'kickstart.plugins.telescope'    -- not used (snacks.picker + fff)
-- require 'kickstart.plugins.lspconfig'    -- custom.plugins.lsp + custom.plugins.mason
-- require 'kickstart.plugins.conform'      -- custom.plugins.formatting
-- require 'kickstart.plugins.blink-cmp'    -- custom.plugins.blink
-- require 'kickstart.plugins.treesitter'   -- custom.plugins.treesitter

-- [[ User plugin modules ]]
-- Order matters where a module reads another plugin's setup state.

require 'custom.plugins.colorscheme'
require 'custom.plugins.mini' -- before blink (snippets preset = mini_snippets)
require 'custom.plugins.lazydev' -- before blink (lazydev provider)
require 'custom.plugins.blink'
require 'custom.plugins.colorful_menu' -- merges extra blink menu draw opts
require 'custom.plugins.snacks'
require 'custom.plugins.treesitter'
require 'custom.plugins.mason'
require 'custom.plugins.lsp'
require 'custom.plugins.tiny-inline-diagnostic' -- after lsp: disables virtual_text
require 'custom.plugins.formatting'
require 'custom.plugins.gitsigns' -- before satellite (gitsigns highlight handler)
require 'custom.plugins.whichkey'
require 'custom.plugins.todo'
require 'custom.plugins.conflict'
require 'custom.plugins.fold'
require 'custom.plugins.inline_fold'
require 'custom.plugins.satellite'
require 'custom.plugins.noice'
require 'custom.plugins.barbar'
require 'custom.plugins.fff' -- before harpoon (harpoon uses fff.find_files_in_dir)
require 'custom.plugins.oil'
require 'custom.plugins.outline'
require 'custom.plugins.persistence'
require 'custom.plugins.schemastore'
require 'custom.plugins.neogit'
require 'custom.plugins.guh' -- before refactoring: guh ships the top-level `async` module
require 'custom.plugins.refactoring'
require 'custom.plugins.grug_far'
require 'custom.plugins.trouble'
require 'custom.plugins.gtranslate'
require 'custom.plugins.sniprun'
require 'custom.plugins.harpoon'
require 'custom.plugins.obsidian'
require 'custom.plugins.markdown'
require 'custom.plugins.rust'
require 'custom.plugins.cargo'
require 'custom.plugins.crates'
require 'custom.plugins.autopairs'
require 'custom.plugins.yanky'
require 'custom.plugins.flash'
require 'custom.plugins.supermaven' -- before bafa (both map <Tab>)
require 'custom.plugins.bafa'
require 'custom.plugins.bloocky'

-- Plugin files from the old config that were/are fully commented out:
--   lua/plugins/dropbar.lua (Bekaboo/dropbar.nvim)
--   lua/plugins/lean.lua (Julian/lean.nvim)

-- vim: ts=2 sts=2 sw=2 et
