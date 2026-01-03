local M = function()
  local statusline = require 'mini.statusline'
  local icons = require 'mini.icons'
  local diagnostic = vim.diagnostic

  -- 1. SETUP MÀU SẮC
  local function setup_custom_highlights()
    local p = function(name, opts)
      vim.api.nvim_set_hl(0, name, opts)
    end

    p('MiniStatuslineFilenameActive', { fg = '#ffffff', bold = true })
    p('MiniStatuslineFilenameInactive', { fg = '#7e8294' })
    p('MiniStatuslineFilenameError', { link = 'DiagnosticError' })
    p('MiniStatuslineFilenameWarn', { link = 'DiagnosticWarn' })
    p('MiniStatuslineFilenameMod', { fg = '#7aa2f7' })

    p('MiniStatuslineDiagError', { link = 'DiagnosticError' })
    p('MiniStatuslineDiagWarn', { link = 'DiagnosticWarn' })
    p('MiniStatuslineDiagInfo', { link = 'DiagnosticInfo' })
    p('MiniStatuslineDiagHint', { link = 'DiagnosticHint' })
  end
  setup_custom_highlights()

  -- 2. DIAGNOSTICS
  local function section_diagnostics()
    if not diagnostic.is_enabled() then
      return ''
    end
    local count = diagnostic.count(0)
    local t = {}

    if (count[diagnostic.severity.ERROR] or 0) > 0 then
      table.insert(t, '%#MiniStatuslineDiagError# ' .. count[diagnostic.severity.ERROR])
    end
    if (count[diagnostic.severity.WARN] or 0) > 0 then
      table.insert(t, '%#MiniStatuslineDiagWarn# ' .. count[diagnostic.severity.WARN])
    end
    -- Bạn có thể bỏ comment nếu muốn hiện Info/Hint
    if (count[diagnostic.severity.INFO] or 0) > 0 then
      table.insert(t, '%#MiniStatuslineDiagInfo# ' .. count[diagnostic.severity.INFO])
    end
    if (count[diagnostic.severity.HINT] or 0) > 0 then
      table.insert(t, '%#MiniStatuslineDiagHint#󰌶 ' .. count[diagnostic.severity.HINT])
    end

    if #t == 0 then
      return ''
    end
    -- QUAN TRỌNG: Thêm %#StatusLine# vào cuối để reset màu, tránh lem màu sang khoảng trắng kế tiếp
    return table.concat(t, ' ') .. '%#StatusLine#'
  end

  -- 3. HARPOON
  local function section_harpoon()
    local ok, harpoon = pcall(require, 'harpoon')
    if not ok then
      return ''
    end
    local list = harpoon:list()
    if not list or #list.items == 0 then
      return ''
    end
    local current_path = vim.uv.fs_realpath(vim.fn.expand '%:p')
    local parts = {}
    for i, item in ipairs(list.items) do
      local is_curr = (vim.uv.fs_realpath(item.value) == current_path)
      local n = vim.fn.fnamemodify(item.value, ':t'):sub(1, 2)
      local fmt = is_curr and '[%d:%s]' or '%d:%s'
      table.insert(parts, string.format(fmt, i, n))
    end
    -- Reset màu cuối chuỗi
    return '%#MiniStatuslineHarpoon#' .. table.concat(parts, ' ') .. '%#StatusLine#'
  end

  -- 4. TABS LIST (DISABLED)
  -- local function section_tabs_list()
  --   local buffers = vim.tbl_filter(function(b)
  --     return vim.api.nvim_buf_is_valid(b.bufnr) and vim.bo[b.bufnr].buflisted
  --   end, vim.fn.getbufinfo())
  --   if #buffers == 0 then
  --     return ''
  --   end

  --   local cur_buf = vim.api.nvim_get_current_buf()
  --   local max_view = 3
  --   local cur_idx = 1
  --   for i, b in ipairs(buffers) do
  --     if b.bufnr == cur_buf then
  --       cur_idx = i
  --       break
  --     end
  --   end

  --   local start_i = math.max(1, cur_idx - math.floor(max_view / 2))
  --   local end_i = math.min(#buffers, start_i + max_view - 1)
  --   if end_i - start_i + 1 < max_view and end_i == #buffers then
  --     start_i = math.max(1, end_i - max_view + 1)
  --   end

  --   local parts = {}
  --   for i = start_i, end_i do
  --     local b = buffers[i]
  --     local bid = b.bufnr
  --     local path = b.name
  --     local is_active = (bid == cur_buf)
  --     local is_mod = vim.bo[bid].modified

  --     local name = (path == '') and '[No Name]' or vim.fn.fnamemodify(path, ':t')

  --     if is_active then
  --       local max_active_len = 20
  --       if #name > max_active_len then
  --         name = '…' .. name:sub(-(max_active_len - 1))
  --       end
  --     else
  --       name = vim.fn.fnamemodify(name, ':r')
  --       if #name > 8 then
  --         name = name:sub(1, 7) .. '…'
  --       end
  --     end

  --     local icon, icon_hl_group = icons.get('file', path)
  --     local icon_str = string.format('%%#%s#%s', icon_hl_group, icon)

  --     local text_hl = 'MiniStatuslineInactive'
  --     local status_icon = ''

  --     local errs = #diagnostic.get(bid, { severity = diagnostic.severity.ERROR })
  --     local warns = #diagnostic.get(bid, { severity = diagnostic.severity.WARN })

  --     if is_active then
  --       text_hl = 'MiniStatuslineFilenameActive'
  --       if is_mod then
  --         status_icon = ' ●'
  --       end
  --     else
  --       if errs > 0 then
  --         text_hl = 'MiniStatuslineFilenameError'
  --       elseif warns > 0 then
  --         text_hl = 'MiniStatuslineFilenameWarn'
  --       elseif is_mod then
  --         text_hl = 'MiniStatuslineFilenameMod'
  --         status_icon = ' ●'
  --       end
  --     end

  --     local item = string.format('%s %%#%s#%s%s', icon_str, text_hl, name, status_icon)
  --     table.insert(parts, item)
  --   end

  --   if start_i > 1 then
  --     table.insert(parts, 1, '%#MiniStatuslineFilenameInactive#')
  --   end
  --   if end_i < #buffers then
  --     table.insert(parts, '%#MiniStatuslineFilenameInactive#')
  --   end

  --   return table.concat(parts, '%#MiniStatuslineFilenameInactive# ') .. '%#StatusLine#'
  -- end

  -- 4. SINGLE FILE PATH
  local function section_file_path()
    local path = vim.fn.expand '%:p'
    if path == '' then
      return '%#MiniStatuslineFilenameActive#[No Name]'
    end

    local is_oil = vim.bo.filetype == 'oil'
    local is_active = true
    local is_mod = vim.bo.modified
    local text_hl = 'MiniStatuslineFilenameActive'
    local status_icon = ''

    local errs = #diagnostic.get(0, { severity = diagnostic.severity.ERROR })
    local warns = #diagnostic.get(0, { severity = diagnostic.severity.WARN })

    if errs > 0 then
      text_hl = 'MiniStatuslineFilenameError'
    elseif warns > 0 then
      text_hl = 'MiniStatuslineFilenameWarn'
    elseif is_mod then
      text_hl = 'MiniStatuslineFilenameMod'
      status_icon = ' ●'
    end

    if is_oil then
      local dir_icon, dir_icon_hl = icons.get('file', path)
      local dir_icon_str = string.format('%%#%s#%s', dir_icon_hl, dir_icon)
      return string.format('%s %%#%s#%s%%#StatusLine#', dir_icon_str, text_hl, path)
    end

    local icon, icon_hl_group = icons.get('file', path)
    local icon_str = string.format('%%#%s#%s', icon_hl_group, icon)

    local rel_path = vim.fn.fnamemodify(path, ':~:.')
    local parts = vim.split(rel_path, '/', { plain = true })
    if #parts > 1 then
      local filename = parts[#parts]
      local dirs = { parts[1] }

      for i = 2, #parts - 1 do
        table.insert(dirs, parts[i]:sub(1, 1))
      end

      local ext = vim.fn.fnamemodify(filename, ':e')
      local name_only = vim.fn.fnamemodify(filename, ':t:r')
      local full_ext = #ext > 0 and ('.' .. ext) or ''

      if #filename > 25 then
        local max_name = 25 - #full_ext
        if max_name > 3 then
          name_only = '...' .. name_only:sub(-(max_name - 3))
        else
          name_only = name_only:sub(-25 + #full_ext)
        end
      end

      rel_path = table.concat(dirs, '/') .. '/' .. name_only .. full_ext
    end

    return string.format('%s %%#%s#%s%s%%#StatusLine#', icon_str, text_hl, rel_path, status_icon)
  end

  -- 5. CONFIG CHÍNH
  statusline.setup {
    use_icons = true,
    content = {
      active = function()
        local mode, mode_hl = statusline.section_mode { trunc_width = 100 }
        local git = statusline.section_git { trunc_width = 40 }

        -- SỬA RECORD MODE:
        -- Reset màu (%#StatusLine#) ngay cuối chuỗi.
        -- Nếu không reset, khoảng trắng sau chữ "@reg" sẽ bị dính màu nền xanh/hồng.
        local rec = vim.fn.reg_recording()
        local rec_str = (rec ~= '') and ('%#MiniStatuslineFilenameMod#@' .. rec .. '%#StatusLine#') or ''

        return statusline.combine_groups {
          { hl = mode_hl, strings = { mode } },
          { hl = 'MiniStatuslineDevinfo', strings = { git } },
          { strings = { section_file_path() } },
          { strings = { section_diagnostics() } },
          { strings = { section_harpoon() } },
          '%<',
          '%=',
          { strings = { rec_str } }, -- Đã fix khoảng trắng thừa do lem màu
          -- '%S', -- Show command
          { hl = 'MiniStatuslinePosition', strings = { '%l:%v' } },
          { hl = 'MiniStatuslineFileinfo', strings = { statusline.section_fileinfo { trunc_width = 80 } } },
        }
      end,
      inactive = function()
        return '%#MiniStatuslineInactive#%f'
      end,
    },
  }
end

-- Bật hiển thị command
-- vim.opt.showcmdloc = 'statusline'

return M
