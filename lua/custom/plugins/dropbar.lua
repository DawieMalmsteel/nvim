return {
  {
    'Bekaboo/dropbar.nvim',
    -- optional, but required for fuzzy finder support
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local dropbar_api = require 'dropbar.api'
      vim.keymap.set('n', '<leader><tab>', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
      vim.keymap.set('n', '[<tab>', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
      vim.keymap.set('n', '<leader>cN', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
      vim.keymap.set('n', ']<tab>', dropbar_api.select_next_context, { desc = 'Select next context' })
      vim.keymap.set('n', '<leader>cn', dropbar_api.select_next_context, { desc = 'Select next context' })
    end,
  },
}
