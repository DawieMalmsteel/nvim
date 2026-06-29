return {
  'mistweaverco/bafa.nvim',
  version = 'v1.12.3',
  keys = {
    { '<Tab>', function() require('bafa').toggle({ with_jump_labels = true, }) end, desc = 'Bafa' },
  },
}
