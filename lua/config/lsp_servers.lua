local M = {}

M.servers = {
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

  -- basedpyright = {
  --   before_init = function(_, c)
  --     c.settings = c.settings or {}
  --     c.settings.python = c.settings.python or {}
  --     c.settings.python.pythonPath = vim.fn.exepath 'python'
  --   end,
  --   settings = {
  --     basedpyright = {
  --       analysis = {
  --         typeCheckingMode = 'basic',
  --         autoImportCompletions = true,
  --         useLibraryCodeForTypes = true,
  --         diagnosticSeverityOverrides = {
  --           reportUnusedImport = 'information',
  --           reportUnusedFunction = 'information',
  --           reportUnusedVariable = 'information',
  --           reportGeneralTypeIssues = 'none',
  --           reportOptionalMemberAccess = 'none',
  --           reportOptionalSubscript = 'none',
  --           reportPrivateImportUsage = 'none',
  --         },
  --       },
  --     },
  --   },
  -- },
  -- copilot = {},
  ols = {},
  ty = {
    root_markers = { 'uv.lock' },
  },
  -- lean_ls= {},

  tsgo = {},
  terraformls = {},

  -- roslyn = {
  --   settings = {
  --     ['csharp|inlay_hints'] = {
  --       csharp_enable_inlay_hints_for_implicit_object_creation = true,
  --       csharp_enable_inlay_hints_for_implicit_variable_types = true,
  --       csharp_enable_inlay_hints_for_lambda_parameter_types = true,
  --       csharp_enable_inlay_hints_for_types = true,
  --       dotnet_enable_inlay_hints_for_indexer_parameters = true,
  --       dotnet_enable_inlay_hints_for_literal_parameters = true,
  --       dotnet_enable_inlay_hints_for_object_creation_parameters = true,
  --       dotnet_enable_inlay_hints_for_other_parameters = true,
  --       dotnet_enable_inlay_hints_for_parameters = true,
  --       dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
  --       dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
  --       dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
  --     },
  --
  --     ['csharp|code_lens'] = {
  --       dotnet_enable_references_code_lens = true,
  --     },
  --   },
  -- },

  rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
        cachePriming = {
          enable = false,
        },
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          buildScripts = {
            enable = true,
          },
        },
        -- Add clippy lints for Rust if using rust-analyzer
        checkOnSave = {
          enable = false,
        },
        -- Enable diagnostics if using rust-analyzer
        diagnostics = {
          enable = false,
        },
        procMacro = {
          enable = true,
          ignored = {
            ['async-trait'] = { 'async_trait' },
            ['napi-derive'] = { 'napi' },
            ['async-recursion'] = { 'async_recursion' },
          },
        },
        files = {
          excludeDirs = {
            '.direnv',
            '.git',
            '.github',
            '.gitlab',
            'bin',
            'node_modules',
            'target',
            'venv',
            '.venv',
          },
        },
      },
    },
  },
  bacon_ls = {
    enabled = true,
  },
  -- solargraph = {},
  -- vtsls = {
  --   filetypes = {
  --     'javascript',
  --     'javascriptreact',
  --     'javascript.jsx',
  --     'typescript',
  --     'typescriptreact',
  --     'typescript.tsx',
  --   },
  --   settings = {
  --     complete_function_calls = true,
  --     vtsls = {
  --       enableMoveToFileCodeAction = true,
  --       autoUseWorkspaceTsdk = true,
  --       experimental = {
  --         maxInlayHintLength = 30,
  --         completion = {
  --           enableServerSideFuzzyMatch = true,
  --         },
  --       },
  --     },
  --     typescript = {
  --       updateImportsOnFileMove = { enabled = 'always' },
  --       suggest = { completeFunctionCalls = true },
  --       inlayHints = {
  --         enumMemberValues = { enabled = true },
  --         functionLikeReturnTypes = { enabled = true },
  --         parameterNames = { enabled = 'literals' },
  --         parameterTypes = { enabled = true },
  --         propertyDeclarationTypes = { enabled = true },
  --         variableTypes = { enabled = true },
  --       },
  --     },
  --   },
  -- },
  tailwindcss = {
    root_dir = function(...)
      return require('lspconfig.util').root_pattern '.git'(...)
    end,
  },
  cssls = {},
  superhtml = {},
  markdown_oxide = {},
  lua_ls = {
    settings = {
      Lua = {
        completion = { callSnippet = 'Replace' },
        -- diagnostics = { disable = { 'missing-fields' } },
      },
    },
  },
}

M.tools = {
  'stylua',
  'markdownlint-cli2',
  'markdown-toc',
}

function M.ensure_installed()
  local ensure = vim.tbl_keys(M.servers)
  vim.list_extend(ensure, M.tools)
  return ensure
end

return M
