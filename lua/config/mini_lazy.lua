local M = {}

local loaded = {}

function M.setup(name)
  if loaded[name] then
    return
  end

  loaded[name] = true

  local ok, mod = pcall(require, 'mini_modules.' .. name)
  if not ok then
    loaded[name] = nil
    vim.schedule(function()
      vim.notify(('Failed to load mini.%s: %s'):format(name, mod), vim.log.levels.ERROR)
    end)
    return
  end

  if type(mod) == 'function' then
    mod()
  elseif type(mod) == 'table' and type(mod.setup) == 'function' then
    mod.setup()
  end
end

function M.setup_many(names)
  for _, name in ipairs(names) do
    M.setup(name)
  end
end

function M.after_start(callback)
  if vim.v.vim_did_enter == 1 then
    vim.schedule(callback)
    return
  end

  vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = function()
      vim.schedule(callback)
    end,
  })
end

return M
