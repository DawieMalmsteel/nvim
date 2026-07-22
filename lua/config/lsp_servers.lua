local M = {}

M.rust_diagnostics = vim.g.lazyvim_rust_diagnostics or 'bacon-ls'

-- Let rustaceanvim drive rust-analyzer defaults. Keep the old tuning below
-- commented in case it is useful again for a very large workspace.
-- M.rust_analyzer_settings = {
--   ['rust-analyzer'] = {
--     cachePriming = {
--       enable = false,
--     },
--     cargo = {
--       -- Keep rust-analyzer responsive on large workspaces.
--       allFeatures = false,
--       loadOutDirsFromCheck = false,
--       buildScripts = {
--         enable = false,
--       },
--     },
--     checkOnSave = M.rust_diagnostics == 'rust-analyzer',
--     diagnostics = {
--       enable = M.rust_diagnostics == 'rust-analyzer',
--     },
--     procMacro = {
--       enable = true,
--       ignored = {
--         ['async-trait'] = { 'async_trait' },
--         ['napi-derive'] = { 'napi' },
--         ['async-recursion'] = { 'async_recursion' },
--       },
--     },
--     files = {
--       -- Avoid rust-analyzer "Roots Scanned" stalls.
--       watcher = 'client',
--       exclude = {
--         '.direnv',
--         '.git',
--         '.jj',
--         '.github',
--         '.gitlab',
--         'bin',
--         'node_modules',
--         'target',
--         'venv',
--         '.venv',
--       },
--     },
--   },
-- }

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

  ols = {},
  ty = {
    root_markers = { 'uv.lock' },
  },
  -- lean_ls= {},

  tsgo = {},
  terraformls = {},

  -- rust_analyzer = {
  --   -- rustaceanvim owns rust-analyzer. Keep this entry so Mason still installs it.
  --   enabled = false,
  --   install = true,
  --   -- settings = M.rust_analyzer_settings,
  -- },
  bacon_ls = {
    -- enabled = M.rust_diagnostics == 'bacon-ls',
    enabled = true,
    install = M.rust_diagnostics == 'bacon-ls',
    settings = {
      bacon_ls = {
        backend = 'cargo',
        -- bacon = {
        --   locationsFile = '.bacon-locations',
        --   runInBackground = true,
        --   runInBackgroundCommand = 'bacon',
        --   runInBackgroundCommandArguments = '--headless -j bacon-ls',
        --   validatePreferences = true,
        --   createPreferencesFile = true,
        --   synchronizeAllOpenFilesWaitMillis = 2000,
        --   updateOnSave = true,
        --   updateOnSaveWaitMillis = 1000,
        -- },
      },
    },
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
  'bacon',
  'codelldb',
}

function M.ensure_installed()
  local ensure = {}

  for name, cfg in pairs(M.servers) do
    if cfg.mason ~= false and (cfg.enabled ~= false or cfg.install == true) then
      ensure[#ensure + 1] = name
    end
  end

  vim.list_extend(ensure, M.tools)
  return ensure
end

return M
