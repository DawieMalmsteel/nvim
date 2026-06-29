local gh = function(repo)
  return 'https://github.com/' .. repo
end

local function warn(msg)
  vim.schedule(function()
    vim.notify(msg, vim.log.levels.WARN)
  end)
end

local function system(cmd, cwd)
  vim.system(cmd, { cwd = cwd }, function(out)
    if out.code ~= 0 then
      warn(('pack hook failed: %s\n%s'):format(table.concat(cmd, ' '), out.stderr or ''))
    end
  end)
end

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local data = ev.data or {}
    local spec = data.spec or {}
    if data.kind ~= 'install' and data.kind ~= 'update' then
      return
    end

    if spec.name == 'fff.nvim' then
      vim.schedule(function()
        pcall(function()
          require('fff.download').download_or_build_binary()
        end)
      end)
    elseif spec.name == 'sniprun' then
      system({ 'sh', 'install.sh' }, data.path)
    elseif spec.name == 'cargo.nvim' then
      system({ 'cargo', 'build', '--release' }, data.path)
    elseif spec.name == 'nvim-treesitter' then
      vim.schedule(function()
        pcall(vim.cmd.TSUpdate)
      end)
    end
  end,
})

vim.pack.add({
  gh 'nvim-lua/plenary.nvim',
  gh 'MunifTanjim/nui.nvim',
  gh 'nvim-tree/nvim-web-devicons',

  gh 'AvengeMedia/base46',
  gh 'oskarnurm/koda.nvim',
  gh 'marekh19/meowsoot.nvim',

  gh 'folke/snacks.nvim',
  gh 'nvim-mini/mini.nvim',
  gh 'folke/which-key.nvim',
  gh 'folke/noice.nvim',
  gh 'romgrk/barbar.nvim',
  gh 'chrisgrieser/nvim-origami',
  gh 'hedyhli/outline.nvim',
  gh 'lewis6991/satellite.nvim',

  { src = gh 'saghen/blink.cmp', version = vim.version.range('1') },
  gh 'fang2hou/blink-copilot',
  gh 'Kaiser-Yang/blink-cmp-git',
  gh 'marcoSven/blink-cmp-yanky',
  gh 'rafamadriz/friendly-snippets',
  gh 'xzbdmw/colorful-menu.nvim',
  gh 'folke/lazydev.nvim',
  gh 'gbprod/yanky.nvim',
  gh 'supermaven-inc/supermaven-nvim',

  gh 'neovim/nvim-lspconfig',
  gh 'mason-org/mason.nvim',
  gh 'mason-org/mason-lspconfig.nvim',
  gh 'WhoIsSethDaniel/mason-tool-installer.nvim',

  { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = gh 'nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
  gh 'nvim-treesitter/nvim-treesitter-context',

  gh 'stevearc/conform.nvim',
  gh 'folke/todo-comments.nvim',
  gh 'windwp/nvim-autopairs',
  gh 'windwp/nvim-ts-autotag',
  gh 'folke/flash.nvim',
  gh 'folke/trouble.nvim',
  gh 'folke/persistence.nvim',
  gh 'stevearc/oil.nvim',
  gh 'NeogitOrg/neogit',
  gh 'ThePrimeagen/refactoring.nvim',
  { src = gh 'ThePrimeagen/harpoon', version = 'harpoon2' },
  gh 'MagicDuck/grug-far.nvim',
  gh 'dmtrKovalenko/fff.nvim',
  gh 'nwiizo/cargo.nvim',
  gh 'michaelb/sniprun',
  gh 'NickvanDyke/opencode.nvim',

  { src = gh 'mistweaverco/bafa.nvim', version = 'v1.12.3' },
  gh 'niekdomi/conflict.nvim',
  gh 'DawieMalmsteel/gtranslate',
  gh 'barrettruth/diffs.nvim',
  gh 'justinmk/guh.nvim',
  gh 'Julian/lean.nvim',
  gh 'malbertzard/inline-fold.nvim',
  gh 'johannww/tts.nvim',
  gh 'nemanjamalesija/ts-expand-hover.nvim',
}, {
  confirm = false,
  load = function(plugin)
    if plugin.spec.name ~= 'tts.nvim' and plugin.spec.name ~= 'lean.nvim' and plugin.spec.name ~= 'ts-expand-hover.nvim' and plugin.spec.name ~= 'grug-far.nvim' then
      vim.cmd.packadd(plugin.spec.name)
    end
  end,
})

local module_by_plugin = {
  ['blink.cmp'] = 'blink.cmp',
  ['conform.nvim'] = 'conform',
  ['lazydev.nvim'] = 'lazydev',
  ['todo-comments.nvim'] = 'todo-comments',
  ['which-key.nvim'] = 'which-key',
  ['nvim-autopairs'] = 'nvim-autopairs',
  ['nvim-ts-autotag'] = 'nvim-ts-autotag',
  ['fff.nvim'] = 'fff',
  ['flash.nvim'] = 'flash',
  ['grug-far.nvim'] = 'grug-far',
  ['harpoon'] = 'harpoon',
  ['inline-fold.nvim'] = 'inline-fold',
  ['lean.nvim'] = 'lean',
  ['noice.nvim'] = 'noice',
  ['oil.nvim'] = 'oil',
  ['outline.nvim'] = 'outline',
  ['persistence.nvim'] = 'persistence',
  ['refactoring.nvim'] = 'refactoring',
  ['sniprun'] = 'sniprun',
  ['trouble.nvim'] = 'trouble',
  ['ts-expand-hover.nvim'] = 'ts_expand_hover',
  ['yanky.nvim'] = 'yanky',
  ['nvim-origami'] = 'origami',
}

local function plugin_name(spec)
  if spec.name then
    return spec.name
  end
  local repo = spec[1]
  if type(repo) ~= 'string' then
    return nil
  end
  return repo:match('/([^/]+)$') or repo
end

local function apply_keys(keys)
  if type(keys) == 'function' then
    local ok, result = pcall(keys)
    if not ok then
      warn('pack keys failed: ' .. result)
      return
    end
    keys = result
  end
  if type(keys) ~= 'table' then
    return
  end

  for _, key in ipairs(keys) do
    if type(key) == 'table' and type(key[1]) == 'string' and key[2] ~= nil then
      local opts = vim.tbl_extend('force', {}, key)
      local mode = opts.mode or 'n'
      opts[1], opts[2], opts.mode = nil, nil, nil
      pcall(vim.keymap.set, mode, key[1], key[2], opts)
    end
  end
end

local function setup_with_opts(name, opts)
  local mod = module_by_plugin[name]
  if not mod then
    return
  end
  local ok, plugin = pcall(require, mod)
  if not ok then
    warn(('pack setup skipped %s: %s'):format(name, plugin))
    return
  end
  if type(plugin.setup) == 'function' then
    local ok_setup, err = pcall(plugin.setup, opts or {})
    if not ok_setup then
      warn(('pack setup failed %s: %s'):format(name, err))
    end
  end
end

local function apply_spec(spec)
  if type(spec) ~= 'table' then
    return
  end

  local name = plugin_name(spec)

  if type(spec.init) == 'function' then
    local ok, err = pcall(spec.init)
    if not ok then
      warn(('pack init failed %s: %s'):format(name or '?', err))
    end
  end

  local opts = spec.opts
  if type(opts) == 'function' then
    local ok, result = pcall(opts, spec)
    if ok then
      opts = result
    else
      warn(('pack opts failed %s: %s'):format(name or '?', result))
      opts = nil
    end
  end

  if type(spec.config) == 'function' then
    local ok, err = pcall(spec.config, spec, opts)
    if not ok then
      warn(('pack config failed %s: %s'):format(name or '?', err))
    end
  elseif opts ~= nil and name then
    setup_with_opts(name, opts)
  end

  apply_keys(spec.keys)
end

local function specs_from_module(mod)
  local ok, specs = pcall(require, mod)
  if not ok then
    warn(('pack require failed %s: %s'):format(mod, specs))
    return {}
  end
  if type(specs) ~= 'table' then
    return {}
  end

  if type(specs[1]) == 'string' and (specs.opts or specs.config or specs.keys or specs.init or specs.event or specs.cmd or specs.ft or specs.lazy or specs.version or specs.branch or specs.name) then
    return { specs }
  end
  return specs
end

pcall(function()
  require('mason').setup {
    ui = {
      border = 'none',
      icons = {
        package_installed = '󰄳 ',
        package_pending = '󰑓 ',
        package_uninstalled = '󰅚 ',
      },
    },
    registries = {
      'github:mason-org/mason-registry',
      'github:Crashdummyy/mason-registry',
    },
  }
end)

for _, mod in ipairs {
  'custom.plugins.colorscheme',
  'config.plugins.lazydev',
  'config.plugins.blink',
  'config.plugins.formatting',
  'config.plugins.todo',
  'config.plugins.whichkey',
  'config.plugins.treesitter',
  'custom.plugins.autopairs',
  'custom.plugins.mini',
  'custom.plugins.snacks',
  'config.plugins.lsp',
  'custom.plugins.bafa',
  'custom.plugins.barbar',
  'custom.plugins.cargo',
  'custom.plugins.colorful_menu',
  'custom.plugins.conflict',
  'custom.plugins.diffs',
  'custom.plugins.fff',
  'custom.plugins.flash',
  'custom.plugins.fold',
  'custom.plugins.gtranslate',
  'custom.plugins.harpoon',
  'custom.plugins.inline_fold',
  'custom.plugins.neogit',
  'custom.plugins.noice',
  'custom.plugins.obsidian',
  'custom.plugins.oil',
  'custom.plugins.opencode',
  'custom.plugins.outline',
  'custom.plugins.persistence',
  'custom.plugins.refactor',
  'custom.plugins.sniprun',
  'custom.plugins.supermaven',
  'custom.plugins.trouble',
  'custom.plugins.yanky',
} do
  for _, spec in ipairs(specs_from_module(mod)) do
    apply_spec(spec)
  end
end

local lean_loaded = false
local function load_lean()
  if lean_loaded then
    return
  end
  pcall(vim.cmd.packadd, 'lean.nvim')
  for _, spec in ipairs(specs_from_module 'custom.plugins.lean') do
    apply_spec(spec)
  end
  lean_loaded = true
end

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  pattern = '*.lean',
  callback = load_lean,
})

local ts_expand_hover_loaded = false
local function load_ts_expand_hover()
  if ts_expand_hover_loaded then
    return
  end
  pcall(vim.cmd.packadd, 'ts-expand-hover.nvim')
  for _, spec in ipairs(specs_from_module 'custom.plugins.typescripts') do
    apply_spec(spec)
  end
  ts_expand_hover_loaded = true
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'typescript', 'typescriptreact' },
  callback = load_ts_expand_hover,
})
vim.schedule(function()
  if vim.tbl_contains({ 'typescript', 'typescriptreact' }, vim.bo.filetype) then
    load_ts_expand_hover()
  end
end)

local grug_far_loaded = false
local function load_grug_far()
  if grug_far_loaded then
    return true
  end
  for _, cmd in ipairs { 'GrugFar', 'GrugFarWithin' } do
    pcall(vim.api.nvim_del_user_command, cmd)
  end
  pcall(vim.cmd.packadd, 'grug-far.nvim')
  for _, spec in ipairs(specs_from_module 'custom.plugins.grug_far') do
    apply_spec(spec)
  end
  grug_far_loaded = true
  return true
end

for _, cmd in ipairs { 'GrugFar', 'GrugFarWithin' } do
  vim.api.nvim_create_user_command(cmd, function(args)
    load_grug_far()
    local range = args.range and args.range > 0 and (args.line1 .. ',' .. args.line2) or ''
    local extra = args.args ~= '' and (' ' .. args.args) or ''
    vim.cmd(range .. cmd .. extra)
  end, { nargs = '?', range = true })
end

vim.keymap.set({ 'n', 'x' }, '<leader>S', function()
  load_grug_far()
  local grug = require 'grug-far'
  local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
  grug.open {
    transient = true,
    prefills = {
      filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
    },
  }
end, { desc = 'Search and Replace' })

local tts_loaded = false
local function load_tts()
  if tts_loaded then
    return true
  end

  for _, cmd in ipairs { 'TTS', 'TTSFile', 'TTSSetLanguage', 'TTSSetBackend' } do
    pcall(vim.api.nvim_del_user_command, cmd)
  end

  local plugin = vim.pack.get({ 'tts.nvim' }, { info = false })[1]
  if plugin and plugin.path then
    vim.opt.rtp:prepend(plugin.path)
  end

  local ok, tts = pcall(require, 'tts-nvim')
  if not ok then
    warn('tts.nvim load failed: ' .. tts)
    return false
  end

  for _, spec in ipairs(specs_from_module 'custom.plugins.tts') do
    local opts = spec.opts
    if type(opts) == 'function' then
      local ok_opts, result = pcall(opts, spec)
      opts = ok_opts and result or nil
    end
    if type(tts.setup) == 'function' then
      pcall(tts.setup, opts or {})
    end
  end

  vim.cmd.runtime 'plugin/tts-nvim.lua'
  tts_loaded = true
  return true
end

for _, cmd in ipairs { 'TTS', 'TTSFile', 'TTSSetLanguage', 'TTSSetBackend' } do
  vim.api.nvim_create_user_command(cmd, function(args)
    load_tts()
    local range = args.range and args.range > 0 and (args.line1 .. ',' .. args.line2) or ''
    local bang = args.bang and '!' or ''
    local extra = args.args ~= '' and (' ' .. args.args) or ''
    vim.cmd(range .. cmd .. bang .. extra)
  end, { nargs = '*', range = true, bang = true })
end
