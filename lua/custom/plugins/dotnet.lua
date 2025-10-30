return {
  {
    'seblyng/roslyn.nvim',
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {},
  },
  {
    'GustavEikaas/easy-dotnet.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local function get_secret_path(secret_guid)
        local path = ''
        local home_dir = vim.fn.expand '~'
        if require('easy-dotnet.extensions').isWindows() then
          local secret_path = home_dir .. '\\AppData\\Roaming\\Microsoft\\UserSecrets\\' .. secret_guid .. '\\secrets.json'
          path = secret_path
        else
          local secret_path = home_dir .. '/.microsoft/usersecrets/' .. secret_guid .. '/secrets.json'
          path = secret_path
        end
        return path
      end

      local dotnet = require 'easy-dotnet'
      -- Options are not required
      dotnet.setup {
        lsp = {
          enabled = false, -- Enable builtin roslyn lsp
          roslynator_enabled = true, -- Automatically enable roslynator analyzer
          analyzer_assemblies = {}, -- Any additional roslyn analyzers you might use like SonarAnalyzer.CSharp
          config = {},
        },
        debugger = {
          -- The path to netcoredbg executable
          bin_path = nil,
          auto_register_dap = true,
          mappings = {
            open_variable_viewer = { lhs = 'T', desc = 'open variable viewer' },
          },
        },
        ---@param action "test" | "restore" | "build" | "run"
        terminal = function(path, action, args)
          args = args or ''
          local commands = {
            run = function()
              return string.format('dotnet run --project %s %s', path, args)
            end,
            test = function()
              return string.format('dotnet test %s %s', path, args)
            end,
            restore = function()
              return string.format('dotnet restore %s %s', path, args)
            end,
            build = function()
              return string.format('dotnet build %s %s', path, args)
            end,
            watch = function()
              return string.format('dotnet watch --project %s %s', path, args)
            end,
          }
          local command = commands[action]()
          if require('easy-dotnet.extensions').isWindows() == true then
            command = command .. '\r'
          end
          vim.cmd 'vsplit'
          vim.cmd('term ' .. command)
        end,
        secrets = {
          path = get_secret_path,
        },
        csproj_mappings = true,
        fsproj_mappings = true,
        auto_bootstrap_namespace = {
          --block_scoped, file_scoped
          type = 'block_scoped',
          enabled = true,
          use_clipboard_json = {
            behavior = 'prompt', --'auto' | 'prompt' | 'never',
            register = '+', -- which register to check
          },
        },
        server = {
          ---@type nil | "Off" | "Critical" | "Error" | "Warning" | "Information" | "Verbose" | "All"
          log_level = nil,
        },
        -- choose which picker to use with the plugin
        -- possible values are "telescope" | "fzf" | "snacks" | "basic"
        -- if no picker is specified, the plugin will determine
        -- the available one automatically with this priority:
        -- telescope -> fzf -> snacks ->  basic
        picker = 'snacks',
        background_scanning = true,
        notifications = {
          --Set this to false if you have configured lualine to avoid double logging
          handler = function(start_event)
            local spinner = require('easy-dotnet.ui-modules.spinner').new()
            spinner:start_spinner(start_event.job.name)
            ---@param finished_event JobEvent
            return function(finished_event)
              spinner:stop_spinner(finished_event.result.msg, finished_event.result.level)
            end
          end,
        },
        diagnostics = {
          default_severity = 'error',
          setqflist = false,
        },
      }
    end,
  },
}
