return {
  'aznhe21/actions-preview.nvim',
  otps = {},
  config = function()
    require('actions-preview').setup {
      -- priority list of preferred backend
      -- backend = { 'minipick', 'nui', 'snacks' },
      backend = { 'nui' },

      highlight_command = {
        require('actions-preview.highlight').delta(),
        -- require("actions-preview.highlight").diff_so_fancy(),
        -- require("actions-preview.highlight").diff_highlight(),
      },

      -- options for nui.nvim components
      nui = {
        -- component direction. "col" or "row"
        dir = 'col',
        -- keymap for selection component: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/menu#keymap
        keymap = {
          close = { '<Esc>', '<C-c>', 'q' },
          focus_next = { 'j', '<Down>', '<Tab>' },
          focus_prev = { 'k', '<Up>', '<S-Tab>' },
          submit = { '<CR>' },
        },
        -- options for nui Layout component: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/layout
        layout = {
          position = '50%',
          size = {
            width = '90%',
            height = '90%',
          },
          min_width = 40,
          min_height = 10,
          relative = 'editor',
        },
        -- options for preview area: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup
        preview = {
          size = '60%',
          border = {
            style = 'rounded',
            padding = { 0, 1 },
          },
        },
        -- options for selection area: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/menu
        select = {
          size = '40%',
          border = {
            style = 'rounded',
            padding = { 0, 1 },
          },
        },
      },

      --- options for snacks picker
      snacks = {
        layout = { preset = 'default' },
      },
    }
    vim.keymap.set({ 'v', 'n' }, '<leader>ca', require('actions-preview').code_actions)
  end,
}
