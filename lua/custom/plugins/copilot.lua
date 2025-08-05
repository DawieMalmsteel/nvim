return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'BufReadPost',
    opts = {
      suggestion = {
        enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        hide_during_completion = vim.g.ai_cmp,
        keymap = {
          accept = '<M-CR>',
          accept_word = false,
          accept_line = false,
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<M-d>',
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    cmd = 'CopilotChat',

    dependencies = {
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    keys = {
      { '<C-s>', '<CR>', ft = 'copilot-chat', desc = 'Submit Prompt', remap = true },
      {
        '<leader>aa',
        function()
          return require('CopilotChat').toggle()
        end,
        desc = 'AI Toggle',
        mode = { 'n' },
      },
      {
        '<leader>aa',
        function()
          return require('CopilotChat').open()
        end,
        desc = 'AI Open',
        mode = { 'v' },
      },
      {
        '<leader>ax',
        function()
          return require('CopilotChat').reset()
        end,
        desc = 'AI Reset',
        mode = { 'n' },
      },
      {
        '<leader>as',
        function()
          return require('CopilotChat').stop()
        end,
        desc = 'AI Stop',
        mode = { 'n' },
      },
      {
        '<leader>am',
        function()
          return require('CopilotChat').select_model()
        end,
        desc = 'AI Models',
        mode = { 'n' },
      },
      {
        '<leader>ap',
        function()
          return require('CopilotChat').select_prompt()
        end,
        desc = 'AI Prompts',
        mode = { 'n', 'v' },
      },
      {
        '<leader>aq',
        function()
          vim.ui.input({
            prompt = 'AI Question> ',
          }, function(input)
            if input ~= '' then
              require('CopilotChat').ask(input)
            end
          end)
        end,
        desc = 'AI Question',
        mode = { 'n', 'v' },
      },
    },
    opts = {
      model = 'claude-sonnet-4',
      -- model = 'gpt-4.1',
      -- model = 'gemini-2.5-flash',
      debug = false,
      temperature = 0,
      sticky = '#buffers',
      headers = {
        user = ' 👤 ',
        assistant = ' 🤖 ',
        tool = ' 🛠️ ',
      },
      mappings = {
        reset = false,
        complete = {
          insert = '<Tab>',
        },
        show_diff = {
          full_diff = true,
        },
      },
      prompts = {
        Explain = {
          mapping = '<leader>ae',
          description = 'AI Explain',
        },
        Review = {
          mapping = '<leader>ar',
          description = 'AI Review',
        },
        Tests = {
          mapping = '<leader>at',
          description = 'AI Tests',
        },
        Fix = {
          mapping = '<leader>af',
          description = 'AI Fix',
        },
        Optimize = {
          mapping = '<leader>ao',
          description = 'AI Optimize',
        },
        Docs = {
          mapping = '<leader>ad',
          description = 'AI Documentation',
        },
        Commit = {
          mapping = '<leader>ac',
          description = 'AI Generate Commit',
        },
      },
      providers = {
        github_models = {
          disabled = false,
        },
        gemini = {

          get_headers = function()
            local api_key = assert(os.getenv 'GEMINI_API_KEY', 'GEMINI_API_KEY env not set')
            return {
              Authorization = 'Bearer ' .. api_key,
              ['Content-Type'] = 'application/json',
            }
          end,

          get_models = function(headers)
            local response, err = require('CopilotChat.utils').curl_get('https://generativelanguage.googleapis.com/v1beta/openai/models', {
              headers = headers,
              json_response = true,
            })

            if err then
              error(err)
            end

            return vim.tbl_map(function(model)
              local id = model.id:gsub('^models/', '')
              return {
                id = id,
                name = id,
                streaming = true,
                tools = true,
              }
            end, response.body.data)
          end,

          embed = function(inputs, headers)
            local response, err = require('CopilotChat.utils').curl_post('https://generativelanguage.googleapis.com/v1beta/openai/embeddings', {
              headers = headers,
              json_request = true,
              json_response = true,
              body = {
                input = inputs,
                model = 'text-embedding-004',
              },
            })

            if err then
              error(err)
            end

            return response.body.data
          end,

          get_url = function()
            return 'https://generativelanguage.googleapis.com/v1beta/openai/chat/completions'
          end,
        },
      },
    },
    config = function(_, opts)
      local chat = require 'CopilotChat'

      -- Đảm bảo provider tồn tại
      opts.providers = opts.providers or {}
      opts.providers.gemini = opts.providers.gemini or {}

      -- Require đúng module sau khi plugin đã load
      local providers = require 'CopilotChat.config.providers'
      opts.providers.gemini.prepare_input = providers.copilot.prepare_input
      opts.providers.gemini.prepare_output = providers.copilot.prepare_output

      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'copilot-*',
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      -- Override the file input method
      local original_input = vim.ui.input
      vim.ui.input = function(input_opts, on_confirm)
        input_opts = input_opts or {}
        local prompt = input_opts.prompt or ''

        -- Check if this is CopilotChat asking for a file
        if prompt:match 'file' or prompt:match 'path' then
          local files = vim.fn.glob('**/*', false, true)
          vim.ui.select(files, {
            prompt = prompt,
          }, on_confirm)
        else
          original_input(input_opts, on_confirm)
        end
      end

      chat.setup(opts)

      -- MCP hub setup
      -- require('mcphub').setup {
      --   extensions = {
      --     copilotchat = {
      --       enabled = true,
      --       convert_tools_to_functions = true,
      --       convert_resources_to_functions = true,
      --       add_mcp_prefix = false,
      --     },
      --   },
      -- }
    end,
  },
}
