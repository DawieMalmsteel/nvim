return {
  'leonardcser/cursortab.nvim',
  -- version = "*",  -- Use latest tagged version for more stability
  build = 'cd server && go build',
  config = function()
    require('cursortab').setup()
  end,
}
