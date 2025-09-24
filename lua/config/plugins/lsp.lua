return {
  'neovim/nvim-lspconfig',
  dependencies = {
    {
      'mason-org/mason.nvim',
      opts = {
        ui = {
          border = 'rounded',
          icons = {
            package_installed = '󰄳 ',
            package_pending = '󰄲 ',
            package_uninstalled = '󰅚 ',
          },
        },
        registries = {
          'github:mason-org/mason-registry',
          'github:Crashdummyy/mason-registry',
        },
      },
    },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    -- 'saghen/blink.cmp',
  },
  opts = {
    inlay_hints = { enabled = true },
  },
  config = function()
    local Methods = vim.lsp.protocol.Methods
    local function client_supports(client, method, bufnr)
      if not client then
        return false
      end
      if vim.fn.has 'nvim-0.11' == 1 then
        return client:supports_method(method, bufnr)
      else
        return client.supports_method(method, { bufnr = bufnr })
      end
    end

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local buf = event.buf
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Keymaps moved to a separate module
        require('config.lsp_keymaps').apply(buf, client)

        -- Document highlight (kept here)
        if client_supports(client, Methods.textDocument_documentHighlight, buf) then
          local hl_group = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = buf,
            group = hl_group,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = buf,
            group = hl_group,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(ev)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = hl_group, buffer = ev.buf }
            end,
          })
        end
      end,
    })

    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(d)
          local m = {
            [vim.diagnostic.severity.ERROR] = d.message,
            [vim.diagnostic.severity.WARN] = d.message,
            [vim.diagnostic.severity.INFO] = d.message,
            [vim.diagnostic.severity.HINT] = d.message,
          }
          return m[d.severity]
        end,
      },
    }

    -- local capabilities = require('blink.cmp').get_lsp_capabilities()
    local capabilities = require('mini.completion').get_lsp_capabilities()
    local servers = {
      gopls = {
        settings = {
          gopls = {
            gofumpt = true,
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
            semanticTokens = true,
          },
        },
      },

      intelephense = {
        settings = {
          intellicode = {
            enable = true,
            suggest = {
              autoImports = true,
              localKeywords = true,
              localVariables = true,
            },
          },
        },
      },

      basedpyright = {
        before_init = function(_, c)
          c.settings = c.settings or {}
          c.settings.python = c.settings.python or {}
          c.settings.python.pythonPath = vim.fn.exepath 'python'
        end,
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = 'basic',
              autoImportCompletions = true,
              useLibraryCodeForTypes = true,
              diagnosticSeverityOverrides = {
                reportUnusedImport = 'information',
                reportUnusedFunction = 'information',
                reportUnusedVariable = 'information',
                reportGeneralTypeIssues = 'none',
                reportOptionalMemberAccess = 'none',
                reportOptionalSubscript = 'none',
                reportPrivateImportUsage = 'none',
              },
            },
          },
        },
      },

      fsautocomplete = {},
      rust_analyzer = {},
      vtsls = {
        filetypes = {
          'javascript',
          'javascriptreact',
          'javascript.jsx',
          'typescript',
          'typescriptreact',
          'typescript.tsx',
        },
        settings = {
          complete_function_calls = true,
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = {
              maxInlayHintLength = 30,
              completion = {
                enableServerSideFuzzyMatch = true,
              },
            },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = 'always' },
            suggest = { completeFunctionCalls = true },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = 'literals' },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = true },
            },
          },
        },
      },
      tailwindcss = {
        root_dir = function(...)
          return require('lspconfig.util').root_pattern '.git'(...)
        end,
      },
      cssls = {},
      html = {},
      marksman = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
    }

    for name, cfg in pairs(servers) do
      cfg.capabilities = vim.tbl_deep_extend('force', {}, capabilities, cfg.capabilities or {})
      vim.lsp.config(name, cfg) -- Configure the server
      vim.lsp.enable(name) -- Enable the server
    end

    local ensure = vim.tbl_keys(servers)
    vim.list_extend(ensure, { 'stylua' })
    require('mason-tool-installer').setup { ensure_installed = ensure }
  end,
}
