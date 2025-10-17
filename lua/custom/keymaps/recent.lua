local map = vim.keymap.set

map('n', '<leader>r', function()
  local MiniPick = require 'mini.pick'
  local wipeout_cur = function()
    vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {})
  end
  local buffer_mappings = { wipeout = { char = '<c-d>', func = wipeout_cur } }
  MiniPick.builtin.buffers({ include_current = true }, { mappings = buffer_mappings })
end, { desc = 'Find existing buffers' })
