return {
  {
    'mason-org/mason.nvim',
    cmd = 'Mason',
    opts = {
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
    },
  },
  {
    'mason-org/mason-lspconfig.nvim',
    lazy = true,
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    event = 'VimEnter',
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
    },
    config = function()
      local mason_tool_installer = require 'mason-tool-installer'

      mason_tool_installer.setup {
        ensure_installed = require('config.lsp_servers').ensure_installed(),
        run_on_start = false,
      }

      vim.defer_fn(function()
        mason_tool_installer.check_install(false)
      end, 3000)
    end,
  },
}
