vim.loader.enable()
vim.g.nvim_start_time = vim.uv.hrtime()

require 'config.options'
require 'config.autocmds'
require 'config.pack'
require 'config.misc'
require 'config.neovide'
-- require 'config.colors_cmd'
-- require 'config.keyboard_input'
-- User keymaps (kept separate as before)
require 'custom.keymaps'
require 'custom.cli'

-- vim.cmd [[highlight Normal guibg=#0d0f18 guifg=NONE]]
