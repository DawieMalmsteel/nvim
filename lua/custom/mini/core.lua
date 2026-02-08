local modules = {
  'custom.mini.editing.ai',
  'custom.mini.editing.surround',
  'custom.mini.editing.pairs',
  'custom.mini.editing.indentscope',
  'custom.mini.editing.bracketed',
  'custom.mini.editing.bufremove',
  'custom.mini.ui.icons',
  'custom.mini.ui.cursorword',
  -- 'custom.mini.ui.tabline',
  'custom.mini.ui.hipatterns',
  'custom.mini.ui.map',
  'custom.mini.ui.diff',
  'custom.mini.ui.splitjoin',
  -- 'custom.mini.ui.clue',
  -- 'custom.mini.nav.visits',
  'custom.mini.nav.files',
  'custom.mini.nav.pick',
  'custom.mini.productivity.snippets',
  -- 'custom.mini.editing.completion',
  -- 'custom.mini.productivity.sessions',
  'custom.mini.productivity.git',
  'custom.mini.ui.statusline',
  'custom.mini.misc',
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
