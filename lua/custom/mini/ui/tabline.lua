local M = function()
  local buffer_positions = {}

  -- Hàm cập nhật danh sách buffer và vị trí
  local function update_buffer_positions()
    local listed_buffers = vim.tbl_filter(function(buf)
      return vim.bo[buf.bufnr].buflisted
    end, vim.fn.getbufinfo())

    buffer_positions = {}
    for i, buf in ipairs(listed_buffers) do
      buffer_positions[buf.bufnr] = i
    end
  end

  -- Cập nhật danh sách buffer khi có sự kiện liên quan
  vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete', 'BufEnter' }, {
    callback = update_buffer_positions,
  })

  -- Gọi cập nhật lần đầu khi khởi động
  update_buffer_positions()

  require('mini.tabline').setup {
    format = function(buf_id, label)
      local current_buf = vim.api.nvim_get_current_buf()
      local function visit_count(id)
        local ok, visits = pcall(require, 'mini.visits')
        if not ok then
          return nil
        end
        local path = vim.api.nvim_buf_get_name(id)
        if path == '' then
          return nil
        end
        local cwd = vim.loop.cwd()
        local index = visits.get_index()
        local cwd_tbl = index[cwd]
        if not cwd_tbl then
          return nil
        end
        local entry = cwd_tbl[path]
        if not entry then
          return nil
        end
        return entry.count
      end
      local count = visit_count(buf_id)
      local current_index = buffer_positions[current_buf]
      local buf_index = buffer_positions[buf_id]
      if buf_id == current_buf then
        local base = MiniTabline.default_format(buf_id, label)
        if count and count > 0 then
          base = base .. '' .. count
        end
        return base
      else
        local relative_number = math.abs((buf_index or 0) - (current_index or 0))
        local short_label = label:sub(1, 5)
        local count_part = (count and count > 0) and ('(' .. count .. ')') or ''
        return ' ' .. relative_number .. ':' .. short_label .. count_part .. ' '
      end
    end,
  }
end
return M
