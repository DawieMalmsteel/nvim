local M = {}

local state = {
  win = nil,
  buf = nil,
  placement = nil,
}

local function valid_win(win)
  return win and vim.api.nvim_win_is_valid(win)
end

local function valid_buf(buf)
  return buf and vim.api.nvim_buf_is_valid(buf)
end

function M.close()
  if state.placement then
    pcall(function()
      state.placement:close()
    end)
  end

  state.placement = nil

  if valid_win(state.win) then
    pcall(vim.api.nvim_win_close, state.win, true)
  elseif valid_buf(state.buf) then
    pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
  end

  state.win = nil
  state.buf = nil
end

function M.toggle()
  -- Preview đang mở thì đóng.
  if valid_win(state.win) then
    M.close()
    return
  end

  local source_win = vim.api.nvim_get_current_win()

  Snacks.image.doc.at_cursor(function(src)
    if not src then
      vim.notify('Không tìm thấy ảnh hoặc Mermaid block tại cursor', vim.log.levels.WARN, { title = 'Snacks Image' })
      return
    end

    vim.schedule(function()
      if not valid_win(source_win) then
        return
      end

      -- Tạo một split và buffer preview mới.
      vim.cmd 'botright vnew'

      local preview_win = vim.api.nvim_get_current_win()
      local preview_buf = vim.api.nvim_get_current_buf()

      vim.bo[preview_buf].buftype = 'nofile'
      vim.bo[preview_buf].bufhidden = 'wipe'
      vim.bo[preview_buf].swapfile = false
      vim.bo[preview_buf].modifiable = false
      vim.bo[preview_buf].filetype = 'image'

      vim.wo[preview_win].number = false
      vim.wo[preview_win].relativenumber = false
      vim.wo[preview_win].signcolumn = 'no'
      vim.wo[preview_win].foldcolumn = '0'
      vim.wo[preview_win].statuscolumn = ''
      vim.wo[preview_win].wrap = false

      -- Có thể thay 50 bằng kích thước split mong muốn.
      vim.api.nvim_win_set_width(preview_win, 50)

      state.win = preview_win
      state.buf = preview_buf

      -- Dùng placement trực tiếp để hỗ trợ cả ảnh thường và
      -- source Mermaid cần convert sang PNG.
      state.placement = Snacks.image.placement.new(preview_buf, src, {
        inline = false,
        auto_resize = true,
        max_width = 80,
        max_height = 40,
      })

      vim.api.nvim_create_autocmd('BufWipeout', {
        buffer = preview_buf,
        once = true,
        callback = function()
          if state.placement then
            pcall(function()
              state.placement:close()
            end)
          end

          state.win = nil
          state.buf = nil
          state.placement = nil
        end,
      })

      -- Trả cursor về Markdown, giữ preview ở bên phải.
      if valid_win(source_win) then
        vim.api.nvim_set_current_win(source_win)
      end
    end)
  end)
end

return M
