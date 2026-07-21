return {
  'niekdomi/conflict.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    require('conflict').setup {
      -- your config here
    }
  end,
}
