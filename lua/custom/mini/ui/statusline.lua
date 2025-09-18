local M = function()
  local statusline = require 'mini.statusline'

  statusline.setup {
    use_icons = true, -- Giữ icons nếu có Nerd Font
    content = {
      active = function()
        local mode, mode_hl = statusline.section_mode { trunc_width = 150 }
        local git = statusline.section_git { trunc_width = 75 }
        local diagnostics = function() -- Thay icon diagnostics thành chữ với màu
          if not vim.diagnostic.is_enabled() then
            return ''
          end
          local counts = { E = 0, W = 0, I = 0, H = 0 }
          local severities = vim.diagnostic.severity
          for _, diag in ipairs(vim.diagnostic.get(0)) do
            if diag.severity == severities.ERROR then
              counts.E = counts.E + 1
            elseif diag.severity == severities.WARN then
              counts.W = counts.W + 1
            elseif diag.severity == severities.INFO then
              counts.I = counts.I + 1
            elseif diag.severity == severities.HINT then
              counts.H = counts.H + 1
            end
          end
          local result = {}
          if counts.E > 0 then
            table.insert(result, '%#MiniStatuslineDiagnosticsError# ' .. counts.E)
          end
          if counts.W > 0 then
            table.insert(result, '%#MiniStatuslineDiagnosticsWarn# ' .. counts.W)
          end
          if counts.I > 0 then
            table.insert(result, '%#MiniStatuslineDiagnosticsInfo# ' .. counts.I)
          end
          if counts.H > 0 then
            table.insert(result, '%#MiniStatuslineDiagnosticsHint#󰌶 ' .. counts.H)
          end
          return table.concat(result, ' ')
        end
        local filename = function()
          -- Custom filename: relative path shortened with ~ for home, dynamic color if modified
          local name = vim.fn.expand '%:~:.'
          if name == '' then
            name = '[No Name]'
          end
          -- Đổi màu toàn bộ filename nếu modified (sử dụng highlight MiniStatuslineModified)
          local hl = vim.bo.modified and '%#MiniStatuslineModified#' or '%#MiniStatuslineFilename#'
          -- Flags cho readonly/modifiable (không cần [+] vì đã đổi màu, giữ gọn)
          local flags = ''
          if vim.bo.modified then
            flags = flags .. ' ' -- Thêm icon Nerd Font cho modified (pencil icon biểu thị chỉnh sửa)
          end
          if vim.bo.readonly then
            flags = flags .. ' [RO]'
          end
          if not vim.bo.modifiable then
            flags = flags .. ' [-]'
          end
          return hl .. name .. flags
        end
        local location = function()
          -- Kết hợp location đầy đủ (với tổng lines và column) + progress bar dọc (sử dụng ký tự tăng dần dọc để gọn và đẹp)
          local current_line = vim.fn.line '.'
          local total_lines = vim.fn.line '$'
          local column = vim.fn.col '.'
          local fraction = math.floor((current_line / total_lines) * 8) -- 0 đến 8 cho các mức
          local vbars = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' } -- Ký tự progress dọc (tăng từ dưới lên)
          local progress_bar = '%#MiniStatuslineProgress#' .. (vbars[math.max(1, math.min(#vbars, fraction or 1))] or '█') -- Chọn ký tự đại diện progress dọc

          return ' ' .. current_line .. '  ' .. column .. ' ' .. progress_bar
          -- return ' ' .. current_line .. '/' .. total_lines .. '  ' .. column .. ' ' .. progress_bar
        end

        -- Thêm recording macro minimal
        local recording = function()
          local reg = vim.fn.reg_recording()
          if reg == '' then
            return ''
          end
          return '%#MiniStatuslineRecording#Recording @' .. reg
        end

        local harpoon_status = function()
          local ok, harpoon = pcall(require, 'harpoon')
          if not ok then
            return ''
          end

          local list = harpoon:list()
          if not list or #list.items == 0 then
            return ''
          end

          local current_file = vim.fn.expand '%:p'
          local harpoon_entries = {}

          for i, item in ipairs(list.items) do
            local file_path = vim.loop.fs_realpath(item.value)
            local file_name = vim.fn.fnamemodify(file_path or '', ':t') or 'N/A' -- Lấy tên file hoặc gán giá trị mặc định
            local short_name = file_name:sub(1, 2) -- Lấy 3 ký tự đầu tiên của tên file
            if file_path == vim.loop.fs_realpath(current_file) then
              table.insert(harpoon_entries, '[' .. i .. ':' .. short_name .. ']') -- Đánh dấu file hiện tại bằng dấu ngoặc vuông
            else
              table.insert(harpoon_entries, i .. ':' .. short_name) -- Hiển thị index và tên file rút gọn
            end
          end

          return table.concat(harpoon_entries, ' ') -- Ngăn cách các file bằng khoảng trắng
        end

        -- MiniVisits label status (show local vs truly global; show global even if not labeled in current cwd)
        local visits_status = function()
          local ok, visits = pcall(require, 'mini.visits')
          if not ok then
            return ''
          end
          local path = vim.api.nvim_buf_get_name(0)
          if path == '' then
            return ''
          end
          local index = visits.get_index()
          local cwd = vim.loop.cwd()

          -- Build label -> set(cwd) across ALL cwd for this path
          local label_cwds = {}
          for cwd_key, cwd_tbl in pairs(index) do
            local entry = cwd_tbl[path]
            if entry and entry.labels then
              for label, _ in pairs(entry.labels) do
                local set = label_cwds[label]
                if not set then
                  set = {}
                  label_cwds[label] = set
                end
                set[cwd_key] = true
              end
            end
          end
          if not next(label_cwds) then
            return ''
          end

          local local_labels, global_labels = {}, {}
          for label, cset in pairs(label_cwds) do
            local n = 0
            for _ in pairs(cset) do
              n = n + 1
            end
            if cset[cwd] and n == 1 then
              table.insert(local_labels, label)
            else
              -- Appears in multiple cwd OR only in other cwd(s) -> treat as global
              table.insert(global_labels, label)
            end
          end

          table.sort(local_labels)
          table.sort(global_labels)
          if #local_labels == 0 and #global_labels == 0 then
            return ''
          end

          if not vim.g.__mini_visits_status_hl then
            pcall(vim.api.nvim_set_hl, 0, 'MiniStatuslineVisitLocal', { link = 'MiniStatuslineDevinfo' })
            pcall(vim.api.nvim_set_hl, 0, 'MiniStatuslineVisitGlobal', { link = 'Title' })
            vim.g.__mini_visits_status_hl = true
          end

          local parts = {}
          if #local_labels > 0 then
            for i, l in ipairs(local_labels) do
              local_labels[i] = '' .. l
            end
            table.insert(parts, '%#MiniStatuslineVisitLocal#' .. table.concat(local_labels, ','))
          end
          if #global_labels > 0 then
            for i, l in ipairs(global_labels) do
              global_labels[i] = '' .. l
            end
            table.insert(parts, '%#MiniStatuslineVisitGlobal#' .. table.concat(global_labels, ','))
          end
          return table.concat(parts, ' ')
        end

        return statusline.combine_groups {
          { hl = mode_hl, strings = { mode } },
          { hl = 'MiniStatuslineDevinfo', strings = { git } },
          { hl = 'MiniStatuslineDiagnostics', strings = { diagnostics() } },
          '%<', -- Left truncate
          { hl = 'MiniStatuslineFilename', strings = { filename() } },
          '%=', -- Right align
          { strings = { recording() } },
          { strings = { visits_status() } },
          { hl = 'MiniStatuslineHarpoon', strings = { harpoon_status() } }, -- Thêm Harpoon ở giữa
          { hl = 'MiniStatuslineLocation', strings = { location() } },
        }
      end,
      inactive = function()
        return '%#MiniStatuslineInactive#' .. statusline.section_filename {}
      end,
    },
  }
end
return M
