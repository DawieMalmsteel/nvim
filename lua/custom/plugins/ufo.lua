return {
  -- Configure nvim-ufo
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = 'BufReadPost', -- Load UFO after reading a buffer
    opts = {},
  },
}
