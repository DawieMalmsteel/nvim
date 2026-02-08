require 'config.options'
require 'config.autocmds'
require 'config.lazy'
require 'config.misc'
require 'config.neovide'
require 'config.colors_cmd'
-- require 'config.keyboard_input'
-- User keymaps (kept separate as before)
require 'custom.keymaps'
require 'custom.cli'
vim.cmd [[colorscheme catppuccin]]
