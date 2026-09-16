local pack = require 'custom.pack'

-- [[ Mason ]]
pack.add {
  pack.gh 'mason-org/mason.nvim',
  pack.gh 'mason-org/mason-lspconfig.nvim',
  pack.gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
}

require('mason').setup {
  ui = {
    border = 'none',
    icons = {
      package_installed = '󰄳 ',
      package_pending = '󰑓 ',
      package_uninstalled = '󰅚 ',
    },
  },
  registries = {
    'github:mason-org/mason-registry',
    'github:Crashdummyy/mason-registry',
  },
}

-- mason-lspconfig is installed for its registry translation helpers; servers
-- themselves are enabled through `vim.lsp.enable()` in custom/plugins/lsp.lua.

local mason_tool_installer = require 'mason-tool-installer'

mason_tool_installer.setup {
  ensure_installed = require('config.lsp_servers').ensure_installed(),
  run_on_start = false,
}

vim.defer_fn(function()
  mason_tool_installer.check_install(false)
end, 3000)

-- vim: ts=2 sts=2 sw=2 et
