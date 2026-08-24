local M = {}

M.rust_diagnostics = vim.g.lazyvim_rust_diagnostics or 'bacon-ls'

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

  shuck = {},
  yamlls = {
    -- Have to add this for yamlls to understand that we support line folding
    capabilities = {
      textDocument = {
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
      },
    },
    -- lazy-load schemastore when needed
    before_init = function(_, new_config)
      new_config.settings.yaml.schemas = vim.tbl_deep_extend('force', new_config.settings.yaml.schemas or {}, require('schemastore').yaml.schemas())
    end,
    settings = {
      redhat = { telemetry = { enabled = false } },
      yaml = {
        keyOrdering = false,
        format = {
          enable = true,
        },
        validate = true,
        schemaStore = {
          -- Must disable built-in schemaStore support to use
          -- schemas from SchemaStore.nvim plugin
          enable = false,
          -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
          url = '',
        },
      },
    },
  },
  helm_ls = {},
  tsgo = {},
  terraformls = {},

  -- rust_analyzer = {
  --   -- rustaceanvim owns rust-analyzer. Keep this entry so Mason still installs it.
  --   enabled = false,
  --   install = true,
  --   -- settings = M.rust_analyzer_settings,
  -- },
  jsonls = {
    -- lazy-load schemastore when needed
    before_init = function(_, new_config)
      new_config.settings.json.schemas = new_config.settings.json.schemas or {}
      vim.list_extend(new_config.settings.json.schemas, require('schemastore').json.schemas())
    end,
    settings = {
      json = {
        format = {
          enable = true,
        },
        validate = { enable = true },
      },
    },
  },
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
