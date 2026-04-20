return {
  'NitroVim/voice.nvim',
  config = function()
    require('voice').setup {
      -- Optional overrides
      -- storage_root = vim.fn.getcwd() .. "/voice_comments",
      -- keymaps = { record = "<leader>vr", play = "<leader>vp" },
    }
  end,
}
