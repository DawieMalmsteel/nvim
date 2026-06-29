-- local M = function()
--   local statusline = require 'mini.statusline'
--   local icons = require 'mini.icons'
--
--   local function get_theme_bg()
--     local hl = vim.api.nvim_get_hl(0, { name = 'Normal' })
--     if hl and hl.bg then
--       return string.format('#%06x', hl.bg)
--     end
--     return nil
--   end
--
--   local function is_dark_theme()
--     local bg = get_theme_bg()
--     if not bg then
--       return true
--     end
--     local r = tonumber(bg:sub(2, 3), 16)
--     local g = tonumber(bg:sub(4, 5), 16)
--     local b = tonumber(bg:sub(6, 7), 16)
--     local brightness = (r * 299 + g * 587 + b * 114) / 1000
--     return brightness < 128
--   end
--
--   local function get_palette()
--     if is_dark_theme() then
--       return {
--         root = '#89b4fa',
--         subtle = '#585b70',
--         filename = '#cdd6f4',
--         harpoon = '#89dceb',
--         git_branch = '#b4befe',
--         git_add = '#a6e3a1',
--         git_mod = '#f9e2af',
--         git_del = '#f38ba8',
--       }
--     else
--       return {
--         root = '#1e66f5',
--         subtle = '#8c8c8c',
--         filename = '#4c4f69',
--         harpoon = '#179299',
--         git_branch = '#7287fd',
--         git_add = '#40a02b',
--         git_mod = '#df8e1d',
--         git_del = '#d20f39',
--       }
--     end
--   end
--
--   local function setup_colors()
--     local p = function(name, opts)
--       vim.api.nvim_set_hl(0, name, opts)
--     end
--     local theme_hl = vim.api.nvim_get_hl(0, { name = 'StatusLine' })
--     local theme_bg = theme_hl.bg and string.format('#%06x', theme_hl.bg) or nil
--     local palette = get_palette()
--
--     p('StatusLineGitBranch', { fg = palette.git_branch, bold = true })
--     p('StatusLineGitAdd', { fg = palette.git_add })
--     p('StatusLineGitMod', { fg = palette.git_mod })
--     p('StatusLineGitDel', { fg = palette.git_del })
--
--     p('StatusLineRoot', { fg = palette.root, bold = true })
--     p('StatusLineSubtle', { fg = palette.subtle })
--     p('StatusLineFilename', { fg = palette.filename, bold = true })
--     p('StatusLineHarpoonActive', { fg = palette.harpoon, bold = true })
--
--     p('StatusLineSep1', { fg = theme_bg, bg = palette.root })
--     p('StatusLineRootSub', { fg = theme_bg, bg = palette.root })
--     p('StatusLineSep2', { fg = palette.root, bg = theme_bg })
--   end
--
--   local function setup_colorscheme_autocmd()
--     vim.api.nvim_create_autocmd('Colorscheme', {
--       pattern = '*',
--       callback = setup_colors,
--     })
--   end
--
--   setup_colors()
--   setup_colorscheme_autocmd()
--
--   -- 2. HELPER: Tính độ rộng chuẩn xác (Tránh lỗi E5108 và khoảng trắng ma)
--   local function get_width(str)
--     if not str or str == '' then
--       return 0
--     end
--     return vim.api.nvim_eval_statusline(str, {}).width
--   end
--
--   -- 3. CÁC HÀM THÀNH PHẦN (COMPONENTS)
--
--   -- Mode rút gọn (N, I, V...)
--   local function get_mode_char()
--     return vim.api.nvim_get_mode().mode:sub(1, 1):upper()
--   end
--
--   -- Project Root
--   local function get_root()
--     local cwd = vim.fn.getcwd()
--     local base = vim.fs.basename(cwd)
--
--     return table.concat {
--       '%#StatusLineRoot#󱉭 ' .. base, -- Nội dung viên thuốc 1 (Nền Xanh)
--       '%#StatusLineSep1#', --  thứ nhất (Nối Xanh sang Cam)
--       -- '%#StatusLineRootSub#  ', -- Nội dung viên thuốc 2 (Nền Cam)
--       '%#StatusLineSep2#', --  thứ hai (Kết thúc Cam sang nền Statusline)
--     }
--   end
--
--   -- Diagnostics (Không có khoảng trắng thừa)
--   local function get_diag()
--     local count = vim.diagnostic.count(0)
--     local parts = {}
--     if (count[1] or 0) > 0 then
--       table.insert(parts, '%#DiagnosticError# ' .. count[1])
--     end
--     if (count[2] or 0) > 0 then
--       table.insert(parts, '%#DiagnosticWarn# ' .. count[2])
--     end
--     return #parts > 0 and table.concat(parts, ' ') or ''
--   end
--
--   -- Harpoon (Gọn gàng: 󱡅 1 2 󰐊3)
--   local function get_harpoon()
--     local ok, harpoon = pcall(require, 'harpoon')
--     if not ok then
--       return ''
--     end
--
--     local list = harpoon:list()
--     local current_path = vim.api.nvim_buf_get_name(0)
--
--     local valid_items = {} -- Chứa các file thực sự có dữ liệu
--     local active_slot = nil -- Slot của file hiện tại (nếu có)
--
--     -- 1. Quét TOÀN BỘ danh sách Harpoon (không dừng lại giữa chừng)
--     for i = 1, list:length() do
--       local item = list:get(i)
--       -- Kiểm tra: item tồn tại VÀ có đường dẫn VÀ đường dẫn không rỗng
--       if item and item.value and item.value ~= '' then
--         table.insert(valid_items, { slot = i, value = item.value })
--
--         -- Kiểm tra xem file hiện tại có nằm ở slot 'i' này không
--         if vim.fn.fnamemodify(item.value, ':p') == current_path then
--           active_slot = i
--         end
--       end
--     end
--
--     -- Nếu không có file nào hợp lệ thì biến mất luôn
--     if #valid_items == 0 then
--       return ''
--     end
--
--     -- 2. Xây dựng danh sách hiển thị (Tối đa 4 item đầu tiên)
--     local nodes = {}
--     local max_view = 4
--     for i = 1, math.min(#valid_items, max_view) do
--       local item = valid_items[i]
--       if item.slot == active_slot then
--         -- File đang mở: Hiện số slot của nó
--         table.insert(nodes, '%#StatusLineHarpoonActive#' .. item.slot)
--       else
--         -- File khác: Hiện số slot mờ
--         table.insert(nodes, '%#StatusLineSubtle#' .. item.slot)
--       end
--     end
--
--     -- -- 3. Nếu tổng số file hợp lệ > 4, thêm dấu ba chấm để báo hiệu còn nữa
--     -- if #valid_items > max_view then
--     --   table.insert(nodes, '%#StatusLineSubtle#…')
--     -- end
--
--     -- 3. Nếu tổng số file hợp lệ < 4 return
--     if #valid_items <= max_view then
--       return string.format('%%#StatusLineHarpoonActive#󰃀:%s ', table.concat(nodes, ' '), #valid_items)
--     end
--
--     -- 4. Trả về chuỗi: Icon + List 4 số + (Tổng số file hợp lệ)
--     return string.format('%%#StatusLineHarpoonActive#󰃀⋮%s %%#StatusLineSubtle#(%d)', table.concat(nodes, ' '), #valid_items)
--   end
--
--   -- Git & Diff (Cần mini.git)
--   local function get_git_stuff()
--     local git = statusline.section_git { trunc_width = 120 }
--     if git == '' then
--       return ''
--     end
--
--     local diff_str = statusline.section_diff { trunc_width = 120 }
--     local res = ''
--
--     if diff_str ~= '' then
--       local added = diff_str:match '%+(%d+)'
--       local changed = diff_str:match '~(%d+)'
--       local deleted = diff_str:match '%-(%d+)'
--       if added then
--         res = res .. '%#StatusLineGitAdd# ' .. added .. ' '
--       end
--       if changed then
--         res = res .. '%#StatusLineGitMod# ' .. changed .. ' '
--       end
--       if deleted then
--         res = res .. '%#StatusLineGitDel# ' .. deleted .. ' '
--       end
--     end
--     return res .. '%#StatusLineGitBranch#' .. git
--   end
--
--   -- Center: Tên File
--   local function get_center_file()
--     local buf_name = vim.api.nvim_buf_get_name(0)
--     if buf_name == '' then
--       return '[No Name]'
--     end
--
--     local display_name = ''
--     local icon = ''
--     local icon_hl = ''
--
--     if vim.bo.filetype == 'oil' then
--       -- Nếu là Oil, lấy đường dẫn thư mục và hiển thị icon folder
--       -- Loại bỏ tiền tố oil://
--       local oil_path = buf_name:gsub('^oil://', '')
--       -- Rút gọn đường dẫn (ví dụ: /home/user -> ~)
--       display_name = vim.fn.fnamemodify(oil_path, ':~')
--       -- icon = '󰉋' -- Icon folder
--       -- icon_hl = 'MiniIconsAzure' -- Màu xanh cho folder
--       icon = icons.get('file', buf_name)
--       icon_hl = 'MiniIconsAzure' -- Màu xanh cho folder
--     else
--       -- Nếu là file bình thường
--       display_name = vim.fn.fnamemodify(buf_name, ':t')
--       icon, icon_hl = icons.get('file', buf_name)
--     end
--
--     local mod = vim.bo.modified and ' %#StatusLineGitMod#[+]' or ''
--
--     return string.format('%%#%s#%s %%#StatusLineFilename#%s%s', icon_hl or 'Normal', icon or '', display_name, mod)
--   end
--
--   -- Recording status
--   local function get_recording()
--     local reg = vim.fn.reg_recording()
--     return reg ~= '' and ('%#StatusLineGitDel#@' .. reg) or ''
--   end
--
--   -- 4. CẤU HÌNH CHÍNH
--   statusline.setup {
--     use_icons = true,
--     content = {
--       active = function()
--         local mode_c = get_mode_char()
--         local _, mode_hl = statusline.section_mode { trunc_width = 120 }
--
--         -- Khối Mode 2 đầu
--         local mode_l = string.format('%%#%s# %s %%#StatusLine#', mode_hl, mode_c)
--         local mode_r = string.format(' %%#%s# %s ', mode_hl, mode_c)
--
--         -- XỬ LÝ KHỐI LEFT: Lọc bỏ các thành phần rỗng để tránh thừa dấu cách
--         local left_components = { get_root(), get_harpoon(), get_diag(), get_recording() }
--         local valid_left = {}
--         for _, comp in ipairs(left_components) do
--           if comp ~= '' then
--             table.insert(valid_left, comp)
--           end
--         end
--         local left_str = ' ' .. table.concat(valid_left, ' ')
--
--         local center_str = get_center_file()
--         local right_str = get_git_stuff()
--
--         -- LOGIC CĂN GIỮA FILE
--         local term_width = vim.o.columns
--         local left_total_w = get_width(mode_l) + get_width(left_str)
--         local center_w = get_width(center_str)
--
--         -- Tính toán padding để center_str nằm chính giữa terminal
--         local padding_len = math.floor(term_width / 2 - center_w / 2) - left_total_w
--         local padding = string.rep(' ', math.max(0, padding_len))
--
--         -- Ghép tất cả lại
--         return table.concat {
--           mode_l,
--           left_str,
--           padding,
--           center_str,
--           '%=', -- Đẩy phần còn lại sang phải
--           right_str,
--           mode_r,
--         }
--       end,
--       inactive = function()
--         return '%#StatusLineNC# %f'
--       end,
--     },
--   }
--
--   -- Bật global statusline
--   vim.opt.laststatus = 3
-- end
--
-- return M

local M = function()
	local statusline = require('mini.statusline')

	-- --- ĐỊNH NGHĨA CHÍNH XÁC MÀU SẮC (Tokyo Night Palette từ soer9459) ---
	local function setup_highlights()
		-- Lấy màu nền động từ StatusLine của hệ thống để đồng bộ
		local statusline_hl = vim.api.nvim_get_hl(0, { name = 'StatusLine' })
		local bg_color = statusline_hl.bg

		local highlights = {
			StatuslineModeNormal   = { fg = '#7aa2f7', bg = bg_color, bold = true }, -- Blue
			StatuslineModeInsert   = { fg = '#9ece6a', bg = bg_color, bold = true }, -- Green
			StatuslineModeVisual   = { fg = '#bb9af7', bg = bg_color, bold = true }, -- Magenta
			StatuslineModeReplace  = { fg = '#f7768e', bg = bg_color, bold = true }, -- Red
			StatuslineModeSelect   = { fg = '#7dcfff', bg = bg_color, bold = true }, -- Teal
			StatuslineModeCommand  = { fg = '#e0af68', bg = bg_color, bold = true }, -- Yellow/Orange
			StatuslineTextMain     = { fg = '#a9b1d6', bg = bg_color },             -- Foreground chính
			StatuslineTextAccent   = { fg = '#565f89', bg = bg_color },             -- Muted Gray
			StatuslineSaved        = { fg = '#9ece6a', bg = bg_color },             -- Green
			StatuslineNotSaved     = { fg = '#f7768e', bg = bg_color, bold = true }, -- Red
			StatuslineReadOnly     = { fg = '#e0af68', bg = bg_color, bold = true }, -- Orange
			StatuslineHarpoon      = { fg = '#7dcfff', bg = bg_color, bold = true }, -- Teal
			StatuslineFiletype     = { fg = '#bb9af7', bg = bg_color, bold = true }, -- Purple
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
		local higroup = "%#StatuslineModeCommand#"
		if current_mode == "n" then
			higroup = "%#StatuslineModeNormal#"
		elseif current_mode == "i" or current_mode == "ic" then
			higroup = "%#StatuslineModeInsert#"
		elseif current_mode == "v" or current_mode == "V" or current_mode == " " then
			higroup = "%#StatuslineModeVisual#"
		elseif current_mode == "R" or current_mode == "Rv" then
			higroup = "%#StatuslineModeReplace#"
		elseif current_mode == "s" or current_mode == "S" or current_mode == " " then
			higroup = "%#StatuslineModeSelect#"
		elseif current_mode == "c" then
			higroup = "%#StatuslineModeCommand#"
		end
		return higroup
	end

	local function Mode()
		local modes = {
			["n"] = "NORMAL",
			["no"] = "NORMAL",
			["i"] = "INSERT",
			["ic"] = "INSERT",
			["v"] = "VISUAL",
			["V"] = "V-LINE",
			[" "] = "V-BLOCK",
			["s"] = "SELECT",
			["S"] = "S-LINE",
			[" "] = "S-BLOCK",
			["R"] = "REPLACE",
			["Rv"] = "V-REPLACE",
			["c"] = "COMMAND",
			["cv"] = "VIM EX",
			["ce"] = "EX",
			["r"] = "PROMPT",
			["rm"] = "MOAR",
			["r?"] = "CONFIRM",
			["!"] = "SHELL",
			["t"] = "TERMINAL",
			["niI"] = "INS-NOR",
		}
		local current_mode = vim.api.nvim_get_mode().mode
		local value = modes[current_mode] or "UNKNOWN"
		return ModeColor() .. ' ' .. value .. ' ' .. _Spacer(0)
	end

	local function Path()
		local path = vim.fn.expand('%:~:.:h')
		local higroup = '%#StatuslineTextAccent#'
		local max_width = 30
		if path == '.' or path == '' then
			return ''
		elseif #path > max_width then
			path = "…" .. string.sub(path, - max_width + 2)
		end
		return _Spacer(1) .. higroup .. path .. '/'
	end

	local function Filename()
		local filename = vim.fn.expand('%:~:t')
		local path = vim.fn.expand('%:~:.:h')
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
		local buf_modified  = vim.bo.modified
		local buf_modifiable = vim.bo.modifiable
		local buf_readonly = vim.bo.readonly
		local hi_saved = '%#StatuslineSaved#'
		local hi_notsaved = '%#StatuslineNotSaved#'
		local hi_readonly = '%#StatuslineReadOnly#'
		if buf_modified then
			return _Spacer(1) .. hi_notsaved .. ' ✘ ' .. _Spacer(0)
		elseif buf_modifiable == false or buf_readonly == true then
			return _Spacer(1) .. hi_readonly .. " • " .. _Spacer(0)
		else
			return _Spacer(1) .. hi_saved .. ' ✔ ' .. _Spacer(0)
		end
	end

	local function Harpoon()
		local final = ""
		local higroup = '%#StatuslineHarpoon#'
		local harpoon_bufs = _G.HarpoonBuffers or {}
		for key, v in pairs(harpoon_bufs) do
			if v == vim.fn.bufnr() then
				final = final .. tostring(key)
			end
		end
		if final == "" then
			return ""
		else
			return _Spacer(1) .. higroup .. ' ' .. final .. ' ' .. _Spacer(0)
		end
	end

  local function get_harpoon()
    local ok, harpoon = pcall(require, 'harpoon')
    if not ok then
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
		local current_line = vim.fn.line('.')
		local total_lines = vim.fn.line('$')
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
	statusline.setup({
		content = {
			active = function()
				return table.concat({
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
				})
			end,
			inactive = nil,
		},
	})
end

return M
