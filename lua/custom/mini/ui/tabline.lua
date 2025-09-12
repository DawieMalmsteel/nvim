-- filepath: buffer 6
local M = function()
  local buffer_positions = {}

  -- Update buffer positions safely
  local function update_buffer_positions()
    local listed_buffers = vim.tbl_filter(function(buf)
      return vim.api.nvim_buf_is_valid(buf.bufnr) and vim.bo[buf.bufnr].buflisted
    end, vim.fn.getbufinfo())

    buffer_positions = {}
    for i, buf in ipairs(listed_buffers) do
      buffer_positions[buf.bufnr] = i
    end
  end

  -- Update buffer positions on relevant events
  vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete', 'BufEnter' }, {
    callback = function()
      update_buffer_positions()
    end,
  })

  -- Initial update
  update_buffer_positions()

  require('mini.tabline').setup {
    format = function(buf_id, label)
      local current_buf = vim.api.nvim_get_current_buf()
      local current_index = buffer_positions[current_buf]
      local buf_index = buffer_positions[buf_id]
      local tabline = require 'mini.tabline'
      if buf_id == current_buf then
        return tabline.default_format(buf_id, label)
      else
        local relative_number = (buf_index and current_index) and math.abs(buf_index - current_index) or '?'
        local short_label = (label and #label > 0) and label:sub(1, 5) or '[NoName]'
        return ' ' .. relative_number .. ':' .. short_label .. ' '
      end
    end,
  }
end

return M
