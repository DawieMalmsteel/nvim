local M = {}

-- Alias chuẩn
function M.map(mode, lhs, rhs, opts)
  opts = opts or {}
  if opts.silent == nil then
    opts.silent = true
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Safe require
function M.sr(mod)
  local ok, m = pcall(require, mod)
  if ok then
    return m
  end
  return nil
end

-- Thư mục của file hiện tại (nếu hợp lệ) hoặc cwd
function M.file_dir()
  local f = vim.api.nvim_buf_get_name(0)
  if f ~= '' and vim.fn.filereadable(f) == 1 then
    return vim.fn.fnamemodify(f, ':h')
  end
  return (vim.loop or vim.uv).cwd()
end

-- Toggle diagnostics (0.10+)
function M.toggle_diagnostics()
  local ok = vim.diagnostic.is_enabled and vim.diagnostic.is_enabled()
  if ok then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable()
  end
end

-- LSP scope helper
function M.lsp_scope(scope)
  return function()
    local extra = M.sr 'mini.extra'
    if extra then
      extra.pickers.lsp { scope = scope }
    else
      vim.notify('mini.extra chưa sẵn sàng', vim.log.levels.WARN)
    end
  end
end

-- Git picker (Snacks)
function M.git_pick(name)
  return function()
    local Snacks = M.sr 'snacks'
    if Snacks and Snacks.picker[name] then
      Snacks.picker[name] { cwd = M.file_dir() }
    else
      vim.notify('Snacks git picker không khả dụng: ' .. name, vim.log.levels.WARN)
    end
  end
end

-- Picker helper chung (Snacks)
function M.pick(name, opts)
  return function()
    local Snacks = M.sr 'snacks'
    if Snacks and Snacks.picker[name] then
      Snacks.picker[name](opts or {})
    else
      vim.notify('Snacks picker không khả dụng: ' .. tostring(name), vim.log.levels.WARN)
    end
  end
end

return M
