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
    map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
    map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)

    -- Goto buffer in position...
    map('n', '<leader>1', '<Cmd>BufferGoto 1<CR>', opts)
    map('n', '<leader>2', '<Cmd>BufferGoto 2<CR>', opts)
    map('n', '<leader>3', '<Cmd>BufferGoto 3<CR>', opts)
    map('n', '<leader>4', '<Cmd>BufferGoto 4<CR>', opts)
    map('n', '<leader>5', '<Cmd>BufferGoto 5<CR>', opts)
    map('n', '<leader>6', '<Cmd>BufferGoto 6<CR>', opts)
    map('n', '<leader>7', '<Cmd>BufferGoto 7<CR>', opts)
    map('n', '<leader>8', '<Cmd>BufferGoto 8<CR>', opts)
    map('n', '<leader>9', '<Cmd>BufferGoto 9<CR>', opts)
    map('n', '<leader>0', '<Cmd>BufferLast<CR>', opts)

    -- Pin/unpin buffer
    map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)

    -- Goto pinned/unpinned buffer
    --                 :BufferGotoPinned
    --                 :BufferGotoUnpinned

    -- Close buffer
    map('n', '<A-q>', '<Cmd>BufferClose<CR>', opts)

    -- Restore buffer
    map('n', '<A-r>', '<Cmd>BufferRestore<CR>', opts)

    -- Wipeout buffer
    --                 :BufferWipeout

    -- Close commands
    --                 :BufferCloseAllButCurrent
    --                 :BufferCloseAllButPinned
    --                 :BufferCloseAllButCurrentOrPinned
    --                 :BufferCloseBuffersLeft
    --                 :BufferCloseBuffersRight

    -- Magic buffer-picking mode
    map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
    map('n', '<C-P>', '<Cmd>BufferPickDelete<CR>', opts)

    -- Sort automatically by...
    map('n', '<Space>bsb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
    map('n', '<Space>bsn', '<Cmd>BufferOrderByName<CR>', opts)
    map('n', '<Space>bsd', '<Cmd>BufferOrderByDirectory<CR>', opts)
    map('n', '<Space>bsl', '<Cmd>BufferOrderByLanguage<CR>', opts)
    map('n', '<Space>bsw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)

    -- Other:
    -- :BarbarEnable - enables barbar (enabled by default)
    -- :BarbarDisable - very bad command, should never be used
  end,
  opts = {
    -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
    animation = true,
    insert_at_start = false,
    -- …etc.
  },
  version = '^1.0.0', -- optional: only update when a new 1.x version is released
}
