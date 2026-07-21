return {
  'romgrk/barbar.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  cmd = {
    'BufferPrevious',
    'BufferNext',
    'BufferMovePrevious',
    'BufferMoveNext',
    'BufferClose',
    'BufferRestore',
    'BufferOrderByBufferNumber',
    'BufferOrderByName',
    'BufferOrderByDirectory',
    'BufferOrderByLanguage',
    'BufferOrderByWindowNumber',
  },
  init = function()
    vim.g.barbar_auto_setup = true
    vim.opt.showtabline = 0
  end,
  keys = {
    {
      'H',
      '<CMD>execute "silent! BufferPrevious " . v:count1<CR>',
      desc = 'Previous Buffer (with count)',
    },
    {
      'L',
      '<CMD>execute "silent! BufferNext " . v:count1<CR>',
      desc = 'Next Buffer (with count)',
    },
    { '<A-[>', '<Cmd>BufferMovePrevious<CR>', desc = 'Move Buffer Previous' },
    { '<A-]>', '<Cmd>BufferMoveNext<CR>', desc = 'Move Buffer Next' },
    { '<A-q>', '<Cmd>BufferClose<CR>', desc = 'Close Buffer' },
    { '<A-r>', '<Cmd>BufferRestore<CR>', desc = 'Restore Buffer' },
    { '<Space>bsb', '<Cmd>BufferOrderByBufferNumber<CR>', desc = 'Order Buffers by Number' },
    { '<Space>bsn', '<Cmd>BufferOrderByName<CR>', desc = 'Order Buffers by Name' },
    { '<Space>bsd', '<Cmd>BufferOrderByDirectory<CR>', desc = 'Order Buffers by Directory' },
    { '<Space>bsl', '<Cmd>BufferOrderByLanguage<CR>', desc = 'Order Buffers by Language' },
    { '<Space>bsw', '<Cmd>BufferOrderByWindowNumber<CR>', desc = 'Order Buffers by Window Number' },
    {
      '<leader>ub',
      function()
        vim.g.barbar_tabline_visible = not vim.g.barbar_tabline_visible
        vim.opt.showtabline = vim.g.barbar_tabline_visible and 2 or 0
        vim.cmd 'redrawtabline'
      end,
      desc = 'Toggle tabline',
    },
  },
  opts = {
    animation = false,
    insert_at_start = false,
    deleted = { enabled = true, icon = ' ' },
  },
  config = function(_, opts)
    require('barbar').setup(opts)
  end,
}
