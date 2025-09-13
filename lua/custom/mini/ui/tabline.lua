local M = function()
  -- Disable mini.tabline by default (can enable later via <leader>tt)
  if vim.g.minitabline_disable == nil then
    vim.g.minitabline_disable = true
  end

  if vim.g.minitabline_disable then
    if not vim.g.__showtabline_before_mini_toggle then
      vim.g.__showtabline_before_mini_toggle = vim.o.showtabline
    end
    vim.o.showtabline = 0
  end

  local buffer_positions = {}

  local function update_buffer_positions()
    local listed_buffers = vim.tbl_filter(function(buf)
      return vim.api.nvim_buf_is_valid(buf.bufnr) and vim.bo[buf.bufnr].buflisted
    end, vim.fn.getbufinfo())

    buffer_positions = {}
    for i, buf in ipairs(listed_buffers) do
      buffer_positions[buf.bufnr] = i
    end
  end

  vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete', 'BufEnter' }, {
    callback = update_buffer_positions,
  })

  update_buffer_positions()

  local config = {
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

  -- Store config for later first-time enable
  vim.g.__mini_tabline_config = config

  if not vim.g.minitabline_disable and not vim.g.__mini_tabline_initialized then
    require('mini.tabline').setup(config)
    vim.g.__mini_tabline_initialized = true
  end
end

return M
