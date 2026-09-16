local M = function()
  local statusline = require 'mini.statusline'

  -- --- ĐỊNH NGHĨA CHÍNH XÁC MÀU SẮC (Tokyo Night Palette từ soer9459) ---
  local function setup_highlights()
    -- Lấy màu nền động từ StatusLine của hệ thống để đồng bộ
    local statusline_hl = vim.api.nvim_get_hl(0, { name = 'StatusLine' })
    local bg_color = statusline_hl.bg

    local highlights = {
      StatuslineModeNormal = { fg = '#7aa2f7', bg = bg_color, bold = true }, -- Blue
      StatuslineModeInsert = { fg = '#9ece6a', bg = bg_color, bold = true }, -- Green
      StatuslineModeVisual = { fg = '#bb9af7', bg = bg_color, bold = true }, -- Magenta
      StatuslineModeReplace = { fg = '#f7768e', bg = bg_color, bold = true }, -- Red
      StatuslineModeSelect = { fg = '#7dcfff', bg = bg_color, bold = true }, -- Teal
      StatuslineModeCommand = { fg = '#e0af68', bg = bg_color, bold = true }, -- Yellow/Orange
      StatuslineTextMain = { fg = '#a9b1d6', bg = bg_color }, -- Foreground chính
      StatuslineTextAccent = { fg = '#565f89', bg = bg_color }, -- Muted Gray
      StatuslineSaved = { fg = '#9ece6a', bg = bg_color }, -- Green
      StatuslineNotSaved = { fg = '#f7768e', bg = bg_color, bold = true }, -- Red
      StatuslineReadOnly = { fg = '#e0af68', bg = bg_color, bold = true }, -- Orange
      StatuslineHarpoon = { fg = '#7dcfff', bg = bg_color, bold = true }, -- Teal
      StatuslineFiletype = { fg = '#bb9af7', bg = bg_color, bold = true }, -- Purple
    }

    for name, opts in pairs(highlights) do
      vim.api.nvim_set_hl(0, name, opts)
    end
  end

  -- Khởi tạo màu sắc ngay khi nạp module
  setup_highlights()

  -- Tự động cập nhật lại màu sắc nếu bạn chuyển đổi Colorscheme
  vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = setup_highlights,
  })

  -- --- Các hàm bổ trợ (Sử dụng lại hệ màu nguyên bản của bạn) ---
  local function _Spacer(n)
    local spaces = string.rep(' ', n)
    return '%#StatuslineTextMain#' .. spaces
  end

  -- Diagnostics (Không có khoảng trắng thừa)
  local function get_diag()
    local count = vim.diagnostic.count(0)
    local parts = {}
    if (count[1] or 0) > 0 then
      table.insert(parts, '%#DiagnosticError# ' .. count[1])
    end
    if (count[2] or 0) > 0 then
      table.insert(parts, '%#DiagnosticWarn# ' .. count[2])
    end
    return #parts > 0 and table.concat(parts, ' ') or ''
  end

  local function ModeColor()
    local current_mode = vim.api.nvim_get_mode().mode
    local higroup = '%#StatuslineModeCommand#'
    if current_mode == 'n' then
      higroup = '%#StatuslineModeNormal#'
    elseif current_mode == 'i' or current_mode == 'ic' then
      higroup = '%#StatuslineModeInsert#'
    elseif current_mode == 'v' or current_mode == 'V' or current_mode == ' ' then
      higroup = '%#StatuslineModeVisual#'
    elseif current_mode == 'R' or current_mode == 'Rv' then
      higroup = '%#StatuslineModeReplace#'
    elseif current_mode == 's' or current_mode == 'S' or current_mode == ' ' then
      higroup = '%#StatuslineModeSelect#'
    elseif current_mode == 'c' then
      higroup = '%#StatuslineModeCommand#'
    end
    return higroup
  end

  local function Mode()
    local modes = {
      ['n'] = 'NORMAL',
      ['no'] = 'NORMAL',
      ['i'] = 'INSERT',
      ['ic'] = 'INSERT',
      ['v'] = 'VISUAL',
      ['V'] = 'V-LINE',
      [' '] = 'V-BLOCK',
      ['s'] = 'SELECT',
      ['S'] = 'S-LINE',
      [' '] = 'S-BLOCK',
      ['R'] = 'REPLACE',
      ['Rv'] = 'V-REPLACE',
      ['c'] = 'COMMAND',
      ['cv'] = 'VIM EX',
      ['ce'] = 'EX',
      ['r'] = 'PROMPT',
      ['rm'] = 'MOAR',
      ['r?'] = 'CONFIRM',
      ['!'] = 'SHELL',
      ['t'] = 'TERMINAL',
      ['niI'] = 'INS-NOR',
    }
    local current_mode = vim.api.nvim_get_mode().mode
    local value = modes[current_mode] or 'UNKNOWN'
    return ModeColor() .. ' ' .. value .. ' ' .. _Spacer(0)
  end

  local function Path()
    local path = vim.fn.expand '%:~:.:h'
    local higroup = '%#StatuslineTextAccent#'
    local max_width = 30
    if path == '.' or path == '' then
      return ''
    elseif #path > max_width then
      path = '…' .. string.sub(path, -max_width + 2)
    end
    return _Spacer(1) .. higroup .. path .. '/'
  end

  local function Filename()
    local filename = vim.fn.expand '%:~:t'
    local path = vim.fn.expand '%:~:.:h'
    local higroup = '%#StatuslineTextMain#'
    if filename == '' then
      return _Spacer(1) .. higroup .. '[No Name]'
    end
    if path == '.' then
      return _Spacer(1) .. higroup .. filename
    end
    return higroup .. filename
  end

  local function Modified()
    local buf_modified = vim.bo.modified
    local buf_modifiable = vim.bo.modifiable
    local buf_readonly = vim.bo.readonly
    local hi_saved = '%#StatuslineSaved#'
    local hi_notsaved = '%#StatuslineNotSaved#'
    local hi_readonly = '%#StatuslineReadOnly#'
    if buf_modified then
      return _Spacer(1) .. hi_notsaved .. ' ✘ ' .. _Spacer(0)
    elseif buf_modifiable == false or buf_readonly == true then
      return _Spacer(1) .. hi_readonly .. ' • ' .. _Spacer(0)
    else
      return _Spacer(1) .. hi_saved .. ' ✔ ' .. _Spacer(0)
    end
  end

  local function Harpoon()
    local final = ''
    local higroup = '%#StatuslineHarpoon#'
    local harpoon_bufs = _G.HarpoonBuffers or {}
    for key, v in pairs(harpoon_bufs) do
      if v == vim.fn.bufnr() then
        final = final .. tostring(key)
      end
    end
    if final == '' then
      return ''
    else
      return _Spacer(1) .. higroup .. ' ' .. final .. ' ' .. _Spacer(0)
    end
  end

  local function get_harpoon()
    local harpoon = package.loaded.harpoon
    if not harpoon then
      return ''
    end

    local list = harpoon:list()
    local current_path = vim.api.nvim_buf_get_name(0)

    local valid_items = {} -- Chứa các file thực sự có dữ liệu
    local active_slot = nil -- Slot của file hiện tại (nếu có)

    -- 1. Quét TOÀN BỘ danh sách Harpoon (không dừng lại giữa chừng)
    for i = 1, list:length() do
      local item = list:get(i)
      -- Kiểm tra: item tồn tại VÀ có đường dẫn VÀ đường dẫn không rỗng
      if item and item.value and item.value ~= '' then
        table.insert(valid_items, { slot = i, value = item.value })

        -- Kiểm tra xem file hiện tại có nằm ở slot 'i' này không
        if vim.fn.fnamemodify(item.value, ':p') == current_path then
          active_slot = i
        end
      end
    end

    -- Nếu không có file nào hợp lệ thì biến mất luôn
    if #valid_items == 0 then
      return ''
    end

    -- 2. Xây dựng danh sách hiển thị (Tối đa 4 item đầu tiên)
    local nodes = {}
    local max_view = 4
    for i = 1, math.min(#valid_items, max_view) do
      local item = valid_items[i]
      if item.slot == active_slot then
        -- File đang mở: Hiện số slot của nó
        table.insert(nodes, '%#StatuslineHarpoon#' .. item.slot)
      else
        -- File khác: Hiện số slot mờ
        table.insert(nodes, '%#StatuslineTextAccent#' .. item.slot)
      end
    end

    -- -- 3. Nếu tổng số file hợp lệ > 4, thêm dấu ba chấm để báo hiệu còn nữa
    -- if #valid_items > max_view then
    --   table.insert(nodes, '%#StatusLineSubtle#…')
    -- end

    -- 3. Nếu tổng số file hợp lệ < 4 return
    if #valid_items <= max_view then
      return string.format('%%#StatuslineHarpoon#󰃀:%s ', table.concat(nodes, ' '), #valid_items)
    end

    -- 4. Trả về chuỗi: Icon + List 4 số + (Tổng số file hợp lệ)
    return string.format('%%#StatuslineHarpoon#󰃀⋮%s %%#StatuslineTextAccent#(%d)', table.concat(nodes, ' '), #valid_items)
  end

  local function Percentage()
    local current_line = vim.fn.line '.'
    local total_lines = vim.fn.line '$'
    local percentage = vim.fn.floor(current_line / total_lines * 100)
    local content = ''
    local higroupmain = '%#StatuslineTextMain#'
    local higroupaccent = '%#StatuslineTextAccent#'
    if current_line == 1 then
      content = 'Top'
    elseif current_line == total_lines then
      content = 'End'
    elseif percentage < 10 then
      content = higroupaccent .. '·' .. higroupmain .. percentage .. '%%'
    else
      content = percentage .. '%%'
    end
    return higroupaccent .. '≡ ' .. higroupmain .. content .. _Spacer(2)
  end

  local function Filetype()
    local higroup = '%#StatuslineFiletype#'
    local filetype = vim.bo.filetype:upper()
    if filetype == '' then
      return higroup .. '-' .. _Spacer(2)
    else
      return higroup .. filetype .. _Spacer(2)
    end
  end

  -- Recording status
  local function get_recording()
    local reg = vim.fn.reg_recording()
    return reg ~= '' and ('%#StatusLineGitDel#@' .. reg) or ''
  end

  -- --- Setup Mini.statusline ---
  statusline.setup {
    content = {
      active = function()
        return table.concat {
          Mode(),
          Path(),
          Filename(),
          Modified(),
          Harpoon(),
          _Spacer(2),
          '%=',
          get_recording(),
          get_diag(),
          get_harpoon(),
          Percentage(),
          Filetype(),
          '%<',
        }
      end,
      inactive = nil,
    },
  }
end

return M
