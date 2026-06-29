local modules = {
  'mini_modules.ai',
  'mini_modules.surround',
  'mini_modules.indentscope',
  'mini_modules.bracketed',
  'mini_modules.bufremove',
  'mini_modules.icons',
  'mini_modules.cursorword',
  'mini_modules.hipatterns',
  'mini_modules.map',
  'mini_modules.diff',
  'mini_modules.splitjoin',
  'mini_modules.snippets',
  'mini_modules.git',
  'mini_modules.statusline',
  'mini_modules.misc',
}

for _, m in ipairs(modules) do
  local ok, mod = pcall(require, m)
  if ok then
    if type(mod) == 'function' then
      mod()
    elseif type(mod) == 'table' and type(mod.setup) == 'function' then
      mod.setup()
    end
  end
end
