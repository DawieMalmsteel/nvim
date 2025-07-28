-- Had the same problem on macos. Following these steps solved the issue for me:
-- Made sure avante builds from source using thebuild = "make BUILD_FROM_SOURCE=true" option.
-- Removed the avante.nvim directory under ~/.local/share/nvim/lazy/avante.nvim and re-installing solved the issue.
-- Re-installed and now it works.
return {
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      provider = 'copilot',
      providers = {
        copilot = {
          model = 'claude-sonnet-4',
        },
      },

      -- provider = "gemini",
      -- gemini = {
      --   model = "gemini-2.0-flash", -- your desired model (or use gpt-4o, etc.)
      --   timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
      --   temperature = 0,
      --   max_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
      --   -- reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
      -- },

      -- system_prompt = function()
      --   local hub = require("mcphub").get_hub_instance()
      --   return hub:get_active_servers_prompt()
      -- end,
      -- -- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
      -- custom_tools = function()
      --   return {
      --     require("mcphub.extensions.avante").mcp_tool(),
      --   }
      -- end,

      web_search_engine = {
        provider = 'tavily',
        api_key = os.getenv 'TAVILY_API_KEY',

        -- Additional settings:
        max_results = 5, -- Number of search results to retrieve (default: 5)
        include_answer = true, -- Include Tavily's summarized answer (default: true)
        include_images = false, -- Include images in search results (default: false)
        search_depth = 'advanced', -- "basic" or "advanced" search depth (default: "basic")
        include_domains = {}, -- Array of domains to prioritize in search results
        exclude_domains = {}, -- Array of domains to exclude from search results
        timeout = 15000, -- Timeout in milliseconds (default: 15000)
        -- For specialized searches:
        search_type = 'search', -- Can be "search" or "passage" (default: "search")
        search_bm25 = false, -- Enable BM25 vector search (default: false)
      },

      -- Snacks slow as f
      -- file_selector = {
      --   provider = 'snacks',
      --   -- Options override for custom providers
      --   provider_opts = {},
      -- },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- build = "make BUILD_FROM_SOURCE=true",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false", -- for windows
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      'zbirenbaum/copilot.lua', -- for providers='copilot'
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
}
