return {
  'otaleghani/dwight.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('dwight').setup {
      backend = 'gemini', -- or "codex", "gemini", "opencode"
    }
  end,
}
