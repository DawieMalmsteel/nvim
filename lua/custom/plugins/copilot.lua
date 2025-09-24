return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  build = ':Copilot auth',
  event = 'BufReadPost',
  opts = {
    suggestion = {
      enabled = not vim.g.ai_cmp,
      auto_trigger = true,
      hide_during_completion = vim.g.ai_cmp,

      -- default keymaps
      -- accept = "<M-l>",
      -- accept_word = false,
      -- accept_line = false,
      -- next = "<M-]>",
      -- prev = "<M-[>",
      -- dismiss = "<C-]>",
      keymap = {
        accept = '<M-CR>',
        accept_word = false,
        accept_line = false,
        next = '<M-]>',
        prev = '<M-[>',
        dismiss = '<M-d>',
      },
    },
    panel = {
      enabled = true,

      -- default keymaps
      -- jump_prev = "[[",
      -- jump_next = "]]",
      -- accept = "<CR>",
      -- refresh = "gr",
      -- open = "<M-CR>"
      keymap = {
        open = '<S-Tab>',
      },
    },
    filetypes = {
      markdown = true,
      help = true,
    },
  },
}
