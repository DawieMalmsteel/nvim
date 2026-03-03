local M = function()
  local statusline = require 'mini.statusline'
  local icons = require 'mini.icons'

  -- 1. ĐỊNH NGHĨA MÀU SẮC (HIGHLIGHTS)
  local function setup_colors()
    local p = function(name, opts)
      vim.api.nvim_set_hl(0, name, opts)
    end

    -- Git & Diff colors
    p('StatusLineGitBranch', { fg = '#b4befe', bold = true })
    p('StatusLineGitAdd', { fg = '#a6e3a1' })
    p('StatusLineGitMod', { fg = '#f9e2af' })
    p('StatusLineGitDel', { fg = '#f38ba8' })

    -- Các thành phần khác
    p('StatusLineRoot', { fg = '#89b4fa', bold = true })
    p('StatusLineSubtle', { fg = '#585b70' })
    p('StatusLineFilename', { fg = '#cdd6f4', bold = true })
    p('StatusLineHarpoonActive', { fg = '#89dceb', bold = true })
  end
  setup_colors()

  -- 2. HELPER: Tính độ rộng chuẩn xác (Tránh lỗi E5108 và khoảng trắng ma)
  local function get_width(str)
    if not str or str == '' then
      return 0
    end
    return vim.api.nvim_eval_statusline(str, {}).width
  end

  -- 3. CÁC HÀM THÀNH PHẦN (COMPONENTS)

  -- Mode rút gọn (N, I, V...)
  local function get_mode_char()
    return vim.api.nvim_get_mode().mode:sub(1, 1):upper()
  end

  -- Project Root
  local function get_root()
    local cwd = vim.fn.getcwd()
    return string.format('%%#StatusLineRoot#󱉭 %s %%#StatusLineRoot#)', vim.fs.basename(cwd))
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

  -- Harpoon (Gọn gàng: 󱡅 1 2 󰐊3)
  local function get_harpoon()
    local ok, harpoon = pcall(require, 'harpoon')
    if not ok then
      return ''
    end
    local list = harpoon:list()
    if list:length() == 0 then
      return ''
    end

    local cur_path = vim.api.nvim_buf_get_name(0)
    local nodes = {}
    for i = 1, list:length() do
      local item = list:get(i)
      if item then
        local is_cur = (vim.fn.fnamemodify(item.value, ':p') == cur_path)
        table.insert(nodes, is_cur and ('%#StatusLineHarpoonActive#' .. i) or ('%#StatusLineSubtle#' .. i))
      end
    end
    return '%#StatusLineGitBranch#󰃀 ' .. table.concat(nodes, ' ')
  end

  -- Git & Diff (Cần mini.git)
  local function get_git_stuff()
    local git = statusline.section_git { trunc_width = 120 }
    if git == '' then
      return ''
    end

    local diff_str = statusline.section_diff { trunc_width = 120 }
    local res = ''

    if diff_str ~= '' then
      local added = diff_str:match '%+(%d+)'
      local changed = diff_str:match '~(%d+)'
      local deleted = diff_str:match '%-(%d+)'
      if added then
        res = res .. '%#StatusLineGitAdd# ' .. added .. ' '
      end
      if changed then
        res = res .. '%#StatusLineGitMod# ' .. changed .. ' '
      end
      if deleted then
        res = res .. '%#StatusLineGitDel# ' .. deleted .. ' '
      end
    end
    return res .. '%#StatusLineGitBranch#' .. git
  end

  -- Center: Tên File
  local function get_center_file()
    local path = vim.fn.expand '%:p'
    if path == '' then
      return '[No Name]'
    end
    local icon, icon_hl = icons.get('file', path)
    local name = vim.fn.expand '%:t'
    local mod = vim.bo.modified and '[+]' or ''
    return string.format('%%#%s#%s %%#StatusLineFilename#%s%s', icon_hl or 'Normal', icon or '', name, mod)
  end

  -- Recording status
  local function get_recording()
    local reg = vim.fn.reg_recording()
    return reg ~= '' and ('%#StatusLineFilename# recording @' .. reg) or ''
  end

  -- 4. CẤU HÌNH CHÍNH
  statusline.setup {
    use_icons = true,
    content = {
      active = function()
        local mode_c = get_mode_char()
        local _, mode_hl = statusline.section_mode { trunc_width = 120 }

        -- Khối Mode 2 đầu
        local mode_l = string.format('%%#%s# %s %%#StatusLine#', mode_hl, mode_c)
        local mode_r = string.format(' %%#%s# %s ', mode_hl, mode_c)

        -- XỬ LÝ KHỐI LEFT: Lọc bỏ các thành phần rỗng để tránh thừa dấu cách
        local left_components = { get_root(), get_harpoon(), get_diag(), get_recording() }
        local valid_left = {}
        for _, comp in ipairs(left_components) do
          if comp ~= '' then
            table.insert(valid_left, comp)
          end
        end
        local left_str = ' ' .. table.concat(valid_left, ' ')

        local center_str = get_center_file()
        local right_str = get_git_stuff()

        -- LOGIC CĂN GIỮA FILE
        local term_width = vim.o.columns
        local left_total_w = get_width(mode_l) + get_width(left_str)
        local center_w = get_width(center_str)

        -- Tính toán padding để center_str nằm chính giữa terminal
        local padding_len = math.floor(term_width / 2 - center_w / 2) - left_total_w
        local padding = string.rep(' ', math.max(0, padding_len))

        -- Ghép tất cả lại
        return table.concat {
          mode_l,
          left_str,
          padding,
          center_str,
          '%=', -- Đẩy phần còn lại sang phải
          right_str,
          mode_r,
        }
      end,
      inactive = function()
        return '%#StatusLineNC# %f'
      end,
    },
  }

  -- Bật global statusline
  vim.opt.laststatus = 3
end

return M
