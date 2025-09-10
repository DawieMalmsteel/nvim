local map = vim.keymap.set

map('n', '<leader>sh', '<CMD>Pick help<CR>', { desc = 'Search [H]elp' })

map('n', '<leader><leader>', function()
  local mini_pick = require 'mini.pick'
  local file = vim.api.nvim_buf_get_name(0)
  local dir = (file ~= '' and vim.fn.filereadable(file) == 1) and vim.fn.fnamemodify(file, ':h') or vim.fn.getcwd()
  mini_pick.builtin.files(nil, { source = { cwd = dir } })
end, { desc = 'Search Files in cwd' })

map('n', '<leader>sG', function()
  vim.cmd('cd ' .. vim.env.PWD or vim.fn.getcwd())
  vim.cmd 'Pick grep_live'
end, { desc = 'Search by Grep Global' })

map('n', '<leader>sg', function()
  local mini_pick = require 'mini.pick'
  local file = vim.api.nvim_buf_get_name(0)
  local dir = (file ~= '' and vim.fn.filereadable(file) == 1) and vim.fn.fnamemodify(file, ':h') or vim.fn.getcwd()
  mini_pick.builtin.grep_live(nil, { source = { cwd = dir } })
end, { desc = 'Search by Grep in file root or cwd' })

map('n', '<leader>sr', '<CMD>Pick resume<CR>', { desc = 'Search Resume' })

map('n', '<leader>r', function()
  local MiniPick = require 'mini.pick'
  local wipeout_cur = function()
    vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {})
  end
  local buffer_mappings = { wipeout = { char = '<c-d>', func = wipeout_cur } }
  MiniPick.builtin.buffers({ include_current = true }, { mappings = buffer_mappings })
end, { desc = 'Find existing buffers' })

map('n', '<leader>sw', function()
  local mini_pick = require 'mini.pick'
  mini_pick.builtin.grep { pattern = vim.fn.expand '<cword>' }
end, { desc = 'Search current Word' })

map('n', '<leader>/', "<CMD>Pick buf_lines scope='current'<CR>", { desc = 'Fuzzily search' })
