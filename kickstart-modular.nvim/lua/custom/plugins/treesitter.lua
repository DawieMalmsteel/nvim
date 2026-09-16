local pack = require 'custom.pack'

-- [[ Treesitter ]]
-- `branch = 'main'` becomes the vim.pack `version` field. `build = ':TSUpdate'`
-- is handled by the PackChanged hook in lua/pack.lua.
pack.add {
  { src = pack.gh 'nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = pack.gh 'nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
  pack.gh 'nvim-treesitter/nvim-treesitter-context',
}

local function start(buf)
  pcall(vim.treesitter.start, buf)
  vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

if vim.bo.filetype ~= '' then
  start(0)
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter_start', { clear = true }),
  callback = function(ev)
    start(ev.buf)
  end,
})

local ensureInstalled = {
  'c',
  'diff',
  'cpp',
  'go',
  'lua',
  'python',
  'rust',
  'ron',
  'tsx',
  'javascript',
  'typescript',
  'vimdoc',
  'vim',
  'odin',
  'bash',
  'json',
  'markdown',
  'html',
  'http',
  'regex',
  'markdown_inline',
  'yaml',
  'ini',
  'templ',
  'c_sharp',
  'gomod',
  'gosum',
  'gowork',
  'gotmpl',
  'sql',
  'terraform',
  'hcl',
}
local alreadyInstalled = require('nvim-treesitter.config').get_installed()
local parsersToInstall = vim
  .iter(ensureInstalled)
  :filter(function(parser)
    return not vim.tbl_contains(alreadyInstalled, parser)
  end)
  :totable()
require('nvim-treesitter').install(parsersToInstall)

-- [[ Treesitter textobjects ]]
local textobjects_opts = {
  move = {
    enable = true,
    set_jumps = true, -- whether to set jumps in the jumplist
    keys = {
      goto_next_start = { [']]'] = '@function.outer', [']a'] = '@parameter.inner' },
      goto_next_end = { [']['] = '@function.outer', [']A'] = '@parameter.inner' },
      goto_previous_start = { ['[['] = '@function.outer', ['[a'] = '@parameter.inner' },
      goto_previous_end = { ['[]'] = '@function.outer', ['[A'] = '@parameter.inner' },
    },
  },
}

local function attach_textobjects(buf)
  local moves = textobjects_opts.move.keys or {}
  for method, keymaps in pairs(moves) do
    for key, query in pairs(keymaps) do
      local desc = query:gsub('@', ''):gsub('%..*', '')
      desc = desc:sub(1, 1):upper() .. desc:sub(2)
      desc = (method:find('next', 1, true) and 'Next ' or 'Prev ') .. desc
      desc = desc .. (method:find('_end', 1, true) and ' End' or ' Start')
      vim.keymap.set({ 'n', 'x', 'o' }, key, function()
        require('nvim-treesitter-textobjects.move')[method](query, 'textobjects')
      end, {
        buffer = buf,
        desc = desc,
        silent = true,
      })
    end
  end
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter_textobjects', { clear = true }),
  callback = function(ev)
    attach_textobjects(ev.buf)
  end,
})

-- nvim-treesitter-context: no setup needed.

-- vim: ts=2 sts=2 sw=2 et
