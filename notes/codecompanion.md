# Example 1
```lua
-- Example configuration with custom slash commands and copilot adapter
return {
  {
    "olimorris/codecompanion.nvim",
    enabled = EcoVim.plugins.ai.codecompanion.enabled or true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
    },
    keys = {
      { "<leader>ccl", "<cmd>CodeCompanion<CR>",     desc = "Inline" },
      { "<leader>ccc", "<cmd>CodeCompanionChat<CR>", desc = "Chat" },
    },
    opts = {
      opts = {
        log_level = "DEBUG",
      },
      display = {
        chat = {
          show_settings = true,
        }
      },
      strategies = {
        chat = {
          adapter = "copilot",
          keymaps = {
            completion = {
              modes = {
                i = "<C-x>"
              },
              index = 1,
              callback = "keymaps.completion",
              description = "Completion Menu",
            }
          },
        },
        slash_commands = {
          ["buffer"] = {
            callback = "strategies.chat.slash_commands.buffer",
            description = "Insert open buffers",
            opts = {
              contains_code = true,
              provider = "telescope", -- default|telescope|mini_pick|fzf_lua
            },
          },
          ["fetch"] = {
            callback = "strategies.chat.slash_commands.fetch",
            description = "Insert URL contents",
            opts = {
              adapter = "jina",
            },
          },
          ["file"] = {
            callback = "strategies.chat.slash_commands.file",
            description = "Insert a file",
            opts = {
              contains_code = true,
              max_lines = 1000,
              provider = "telescope", -- default|telescope|mini_pick|fzf_lua
            },
          },
          ["files"] = {
            callback = "strategies.chat.slash_commands.files",
            description = "Insert multiple files",
            opts = {
              contains_code = true,
              max_lines = 1000,
              provider = "telescope", -- default|telescope|mini_pick|fzf_lua
            },
          },
          ["help"] = {
            callback = "strategies.chat.slash_commands.help",
            description = "Insert content from help tags",
            opts = {
              contains_code = false,
              provider = "telescope", -- telescope|mini_pick|fzf_lua
            },
          },
          ["now"] = {
            callback = "strategies.chat.slash_commands.now",
            description = "Insert the current date and time",
            opts = {
              contains_code = false,
            },
          },
          ["symbols"] = {
            callback = "strategies.chat.slash_commands.symbols",
            description = "Insert symbols for a selected file",
            opts = {
              contains_code = true,
              provider = "telescope", -- default|telescope|mini_pick|fzf_lua
            },
          },
          ["terminal"] = {
            callback = "strategies.chat.slash_commands.terminal",
            description = "Insert terminal output",
            opts = {
              contains_code = false,
            },
          },
        },
        inline = {
          adapter = "copilot",
        },
        agent = {
          adapter = "copilot",
        },
      },
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "claude-3.5-sonnet",
              },
            },
          })
        end,
      },

    }
  }
}
```


# Example 2
```lua
--Example configuration with Deepseek and Ollama adapters
local prefix = "<leader>a"
local user = vim.env.USER or "User"

vim.api.nvim_create_autocmd("User", {
  pattern = "CodeCompanionChatAdapter",
  callback = function(args)
    if args.data.adapter == nil or vim.tbl_isempty(args.data) then
      return
    end
    vim.g.llm_name = args.data.adapter.name
  end,
})

return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionToggle", "CodeCompanionAdd", "CodeCompanionChat" },
    opts = {
      adapters = {
        deepseek_coder = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "deepseek_coder",
            schema = {
              model = {
                default = "deepseek-coder-v2:latest",
              },
            },
          })
        end,
        deepseek_r1 = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "deepseek_r1",
            schema = {
              model = {
                default = "deepseek-r1:14b",
              },
            },
          })
        end,
        ollama31 = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "ollama3.1",
            schema = {
              model = {
                default = "ollama3.1:latest",
              },
            },
          })
        end,
        qwen3 = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "qwen3",
            schema = {
              model = {
                default = "qwen3:14b",
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "qwen3",
          roles = {
            llm = "  CodeCompanion",
            user = " " .. user:sub(1, 1):upper() .. user:sub(2),
          },
          keymaps = {
            close = { modes = { n = "q", i = "<C-c>" } },
            stop = { modes = { n = "<C-c>" } },
          },
        },
        inline = { adapter = "ollama31" },
        agent = { adapter = "deepseek_r1" },
      },
      display = {
        chat = {
          show_settings = true,
          render_headers = false,
        },
      },
    },
    keys = {
      { prefix .. "a", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Action Palette" },
      { prefix .. "c", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "New Chat" },
      { prefix .. "A", "<cmd>CodeCompanionAdd<cr>", mode = "v", desc = "Add Code" },
      { prefix .. "i", "<cmd>CodeCompanion<cr>", mode = "n", desc = "Inline Prompt" },
      { prefix .. "C", "<cmd>CodeCompanionToggle<cr>", mode = "n", desc = "Toggle Chat" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { prefix, group = "ai", icon = "󱚦 ", mode = { "n", "v" } },
      },
    },
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, {
        ft = "codecompanion",
        title = "CodeCompanion",
        size = { width = 70 },
      })
    end,
  },
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        per_filetype = {
          codecompanion = { "codecompanion" },
        },
      },
    },
  },
}
```

# Example 3
```lua
-- Example configuration with history extension and custom chat opener
-- Credits to https://github.com/franco-ruggeri
-- If available, open the last chat, otherwise open a new chat
local function open_chat()
  local chat = require("codecompanion.strategies.chat").last_chat()
  if chat then
    chat.ui:open()
    vim.api.nvim_set_current_win(chat.ui.winnr)
  else
    vim.cmd("CodeCompanionChat")
  end
end

return {
  "olimorris/codecompanion.nvim",
  event = "VeryLazy",
  enabled = false,
  cmd = "CodeCompanion",
  dependencies = {
    {
      "nvim-lua/plenary.nvim",
      version = false,
    },
    "ravitemer/mcphub.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/codecompanion-history.nvim",
    { "franco-ruggeri/codecompanion-spinner.nvim" },
  },
  opts = {
    strategies = {
      chat = {
        adapter = "copilot",
      },
      inline = {
        adapter = "copilot",
      },
    }
  },
  keys = {
    {
      "<Leader>Aa",
      "<Cmd>CodeCompanionActions<CR>",
      mode = { "n", "x" },
      desc = "[A]I CodeCompanion [a]ctions",
    },
    { "<Leader>Ac", open_chat, desc = "[A]I CodeCompanion [c]hat" },
    {
      "<Leader>Ac",
      "<Cmd>CodeCompanionChat Add<CR>",
      mode = "x",
      desc = "[A]I CodeCompanion [c]hat add",
    },
    {
      "<Leader>AC",
      "<Cmd>CodeCompanionChat<CR>",
      mode = { "n", "x" },
      desc = "[A]I CodeCompanion [c]hat new",
    },
    {
      "<Leader>Ai",
      ":CodeCompanion ",
      mode = { "n", "x" },
      desc = "[A]I CodeCompanion [i]nline",
    },
    {
      "<Leader>An",
      ":CodeCompanionCmd ",
      mode = { "n", "x" },
      desc = "[A]I CodeCompanion [N]eovim command",
    },
    { "<Leader>Ah", "<Cmd>CodeCompanionHistory<CR>", desc = "[A]I CodeCompanion chat [h]istory" },
  },
  cmd = {
    "CodeCompanionActions",
    "CodeCompanionChat",
    "CodeCompanionCmd",
    "CodeCompanion",
    "CodeCompanionHistory",
  },
  opts = {
    strategies = {
      chat = {
        roles = { -- make rendered roles nicer
          llm = function(adapter)
            return (" %s"):format(adapter.formatted_name)
          end,
          user = " User",
        },
      },
    },
    extensions = {
      history = {
        opts = {
          expiration_days = 7,
          chat_filter = function(chat_data) -- only chats for the cwd
            return chat_data.cwd == vim.fn.getcwd()
          end,
          -- WARNING: The models used for titles and summaries default to the models used in the chats.
          -- So, it is crucial to set them, in order not to waste requests potentially from premium models.
          -- ====================
          title_generation_opts = {
            adapter = "copilot",
            model = "gpt-4.1",
          },
          summary = {
            generation_opts = {
              adapter = "copilot",
              model = "gpt-4.1",
            },
          },
          -- ====================
        },
      },
      spinner = {
      },
      mcphub = { callback = "mcphub.extensions.codecompanion" },
    },
  },
  config = function(_, opts)
    require("codecompanion").setup(opts)
  end,
}
```
