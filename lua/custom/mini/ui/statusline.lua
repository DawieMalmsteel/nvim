local M = function()
  local statusline = require 'mini.statusline'
  local icons = require 'mini.icons'

  -- Buffer positions for mini-like tab display inside statusline
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
  -- initial populate
  update_buffer_positions()

  -- Ensure highlight for current filename (white)
  if not vim.g.__mini_status_current_name_hl then
    pcall(vim.api.nvim_set_hl, 0, 'MiniStatuslineCurrentName', { fg = '#ffffff' })
    vim.g.__mini_status_current_name_hl = true
  end

  -- Ensure highlight for inactive tabs (gray)
  if not vim.g.__mini_status_inactive_tab_hl then
    pcall(vim.api.nvim_set_hl, 0, 'MiniStatuslineInactiveTab', { fg = '#7e8294' })
    vim.g.__mini_status_inactive_tab_hl = true
  end
  -- Ensure highlight for modified inactive tabs (red)
  if not vim.g.__mini_status_inactive_tab_modified_hl then
    pcall(vim.api.nvim_set_hl, 0, 'MiniStatuslineInactiveTabModified', { fg = '#f38ba8' })
    vim.g.__mini_status_inactive_tab_modified_hl = true
  end
  -- Ensure highlights for diagnostics in inactive tabs
  if not vim.g.__mini_status_inactive_tab_diag_hl then
    pcall(vim.api.nvim_set_hl, 0, 'MiniStatuslineInactiveTabDiagError', { link = 'DiagnosticError' })
    pcall(vim.api.nvim_set_hl, 0, 'MiniStatuslineInactiveTabDiagWarn', { link = 'DiagnosticWarn' })
    pcall(vim.api.nvim_set_hl, 0, 'MiniStatuslineInactiveTabDiagInfo', { link = 'DiagnosticInfo' })
    pcall(vim.api.nvim_set_hl, 0, 'MiniStatuslineInactiveTabDiagHint', { link = 'DiagnosticHint' })
    vim.g.__mini_status_inactive_tab_diag_hl = true
  end

  -- Build a compact tab-like string (mini.tabline-like)
  local function tabs_side()
    local listed = vim.tbl_filter(function(buf)
      return vim.api.nvim_buf_is_valid(buf.bufnr) and vim.bo[buf.bufnr].buflisted
    end, vim.fn.getbufinfo())
    if #listed == 0 then
      return ''
    end

    local current_buf = vim.api.nvim_get_current_buf()
    local current_index = buffer_positions[current_buf] or 1

    local parts = {}
    local max_show = 3
    local start_i = 1
    local total = #listed
    if total > max_show then
      start_i = math.max(1, math.min(total - max_show + 1, (current_index - math.floor(max_show / 2))))
    end

    for i = start_i, math.min(total, start_i + max_show - 1) do
      local buf = listed[i]
      local bufnr = buf.bufnr
      local filepath = vim.api.nvim_buf_get_name(bufnr)
      local name = vim.fn.fnamemodify(filepath, ':t')
      if #name > 20 then
        name = '•' .. name:sub(-19)
      end
      local extension = vim.fn.fnamemodify(filepath, ':e')
      local icon = icons.get('extension', extension)
      if name == '' then
        name = '[NoName]'
      end

      if bufnr == current_buf then
        -- Current buffer: show full filename (no index), name in white
        local flags = ''
        if vim.bo[bufnr].modified then
          flags = flags .. ' '
        end
        if vim.bo[bufnr].readonly then
          flags = flags .. ' [RO]'
        end
        if not vim.bo[bufnr].modifiable then
          flags = flags .. ' [-]'
        end

        table.insert(parts, '%#MiniStatuslineFilename#' .. icon .. ' ' .. name .. flags)
      else
        -- Non-current: compact diagnostics count + short name
        -- local short = #name > min_len and name:sub(1, min_len) or name

        -- local min_len = 3
        local short = vim.fn.fnamemodify(name, ':r')
        local counts = { E = 0, W = 0, I = 0, H = 0 }
        local severities = vim.diagnostic.severity
        for _, diag in ipairs(vim.diagnostic.get(bufnr)) do
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
        local diag_count = counts.E + counts.W + counts.I + counts.H
        local mess = ''
        if counts.E and counts.E > 0 then
          mess = mess .. counts.E .. 'E'
        end
        if counts.W and counts.W > 0 then
          mess = mess .. counts.W .. 'W'
        end
        if counts.I and counts.I > 0 then
          mess = mess .. counts.I .. 'I'
        end
        if counts.H and counts.H > 0 then
          mess = mess .. counts.H .. 'H'
        end

        local hl
        if counts.E > 0 then
          hl = '%#MiniStatuslineInactiveTabDiagError#'
        elseif counts.W > 0 then
          hl = '%#MiniStatuslineInactiveTabDiagWarn#'
        elseif counts.I > 0 then
          hl = '%#MiniStatuslineInactiveTabDiagInfo#'
        elseif counts.H > 0 then
          hl = '%#MiniStatuslineInactiveTabDiagHint#'
        else
          hl = '%#MiniStatuslineInactiveTab#'
        end
        if vim.bo[bufnr].modified then
          hl = '%#MiniStatuslineInactiveTabModified#'
        end
        if diag_count > 0 then
          table.insert(parts, hl .. mess .. ':' .. icon .. ' ' .. short)
        else
          table.insert(parts, hl .. icon .. ' ' .. short)
        end
      end
    end

    if start_i > 1 then
      table.insert(parts, 1, '…')
    end
    if start_i + max_show - 1 < total then
      table.insert(parts, '…')
    end

    return '%#MiniStatuslineDevinfo#' .. table.concat(parts, '%#MiniStarterItemBullet#' .. ' ') .. '%#MiniStatuslineFilename#'
  end

  statusline.setup {
    use_icons = true,
    content = {
      active = function()
        local mode, mode_hl = statusline.section_mode { trunc_width = 150 }
        local git = statusline.section_git { trunc_width = 75 }

        local diagnostics = function()
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

        local location = function()
          local current_line = vim.fn.line '.'
          local total_lines = vim.fn.line '$'
          local column = vim.fn.col '.'
          local total_column = vim.fn.col '$'
          local fraction = total_lines > 0 and math.floor((current_line / total_lines) * 8) or 8
          local vbars = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
          local idx = math.max(1, math.min(#vbars, (fraction or 1)))
          local progress_bar = '%#MiniStatuslineProgress#' .. (vbars[idx] or '█')
          -- return ' ' .. current_line .. '|' .. total_lines .. '  ' .. column .. '|' .. total_column .. ' ' .. progress_bar
          return table.concat {
            '%#MiniStatuslineDevinfo#' .. column, -- Highlight column
            '',
            '%#MiniStatuslineDevinfo#' .. total_column, -- Highlight total_column
            '%#MiniStatuslineDiagnosticsWarn#' .. '|',
            '%#MiniStatuslineDiagnostics#' .. total_lines,
            -- progress_bar,
          }
        end

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
            local file_path = vim.uv.fs_realpath(item.value)
            local file_name = vim.fn.fnamemodify(file_path or '', ':t') or 'N/A'
            local short_name = file_name:sub(1, 2)
            if file_path == vim.uv.fs_realpath(current_file) then
              table.insert(harpoon_entries, '[' .. i .. ':' .. short_name .. ']')
            else
              table.insert(harpoon_entries, i .. ':' .. short_name)
            end
          end

          return table.concat(harpoon_entries, ' ')
        end

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
          local cwd = vim.uv.cwd()

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
          { strings = { tabs_side() } },
          { hl = 'MiniStatuslineDiagnostics', strings = { diagnostics() } },
          { hl = 'MiniStatuslineHarpoon', strings = { harpoon_status() } },
          '%<', -- Left truncate
          -- Only show the compact tabs list (current entry shows icon + name in white, no index)
          '%=', -- Right align
          { strings = { recording() } },
          { strings = { visits_status() } },
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
