return {
  'romgrk/barbar.nvim',
  init = function()
    vim.g.barbar_auto_setup = true
    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }

    -- Move to previous/next
    map('n', 'H', '<CMD>execute "silent! BufferPrevious " . v:count1<CR>', { desc = 'Previous Buffer (with count)' })
    map('n', 'L', '<CMD>execute "silent! BufferNext " . v:count1<CR>', { desc = 'Next Buffer (with count)' })

    -- Re-order to previous/next
    map('n', '<A-[>', '<Cmd>BufferMovePrevious<CR>', opts)
    map('n', '<A-]>', '<Cmd>BufferMoveNext<CR>', opts)

    -- Close buffer
    map('n', '<A-q>', '<Cmd>BufferClose<CR>', opts)

    -- Restore buffer
    map('n', '<A-r>', '<Cmd>BufferRestore<CR>', opts)

    -- Magic buffer-picking mode
    map('n', '<A-p>', '<Cmd>BufferPick<CR>', opts)
    map('n', '<leader>1', '<Cmd>BufferPickDelete<CR>', opts)

    -- Sort automatically by...
    map('n', '<Space>bsb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
    map('n', '<Space>bsn', '<Cmd>BufferOrderByName<CR>', opts)
    map('n', '<Space>bsd', '<Cmd>BufferOrderByDirectory<CR>', opts)
    map('n', '<Space>bsl', '<Cmd>BufferOrderByLanguage<CR>', opts)
    map('n', '<Space>bsw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)
  end,
  opts = {
    animation = true,
    insert_at_start = false,
    deleted = { enabled = true, icon = ' ' },
  },
  config = function(_, opts)
    require('barbar').setup(opts)
  end,
}
