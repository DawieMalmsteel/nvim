local pack = require 'custom.pack'

-- fff — official file + content search picker.
--
-- Package renamed `dmtrKovalenko/fff.nvim` -> `dmtrKovalenko/fff` upstream.
-- The Rust binary is built/downloaded by the PackChanged hook in lua/pack.lua.
-- fff covers file-path search and content grep only. Buffers, diagnostics, LSP
-- symbols, undo, git branches/log, todo, marks, help, ... stay on Snacks picker.
pack.add { pack.gh 'dmtrKovalenko/fff' }

require('fff').setup {
  mode = 'mixed', -- 'mixed' | 'files' | 'directories'
  layout = {
    height = 0.9,
    width = 0.9,
    prompt_position = 'top',
    preview_position = 'right',
    preview_size = 0.5,
    flex = { size = 130, wrap = 'top' },
    anchor = 'center',
  },
  keymaps = {
    close = { '<C-c>', '<Esc>' },
  },
  -- Color filenames by git status (modified/untracked/staged/...).
  git = {
    status_text_color = true,
  },
  file_picker = {
    -- Highlight the fuzzy query match inside each result line.
    fuzzy_query_highlighting = true,
  },
  grep = {
    smart_case = true,
    modes = { 'plain', 'regex', 'fuzzy' },
    -- `score.rs` in a grep query is treated as a file-path filter that scopes
    -- the search to that file (instead of searching the literal text).
    enable_filename_constraint = true,
  },
  debug = {
    enabled = false, -- keep the file-info panel off during normal use
    show_scores = true,
  },
  history = {
    enabled = true,
  },
}

local function find_files()
  require('fff').find_files()
end

local function live_grep()
  require('fff').live_grep()
end

vim.keymap.set('n', '<leader>ff', find_files, { desc = 'Find Files (fff)' })
vim.keymap.set('n', '\\\\', find_files, { desc = 'Find Files (fff)' })
vim.keymap.set('n', '<leader>fg', live_grep, { desc = 'Live Grep (fff)' })
vim.keymap.set('n', '<leader>sr', function()
  require('fff').resume()
end, { desc = 'resume (fff)' })
vim.keymap.set('n', '<leader>sG', live_grep, { desc = 'Grep Global (fff)' })
vim.keymap.set('n', '<leader>sg', live_grep, { desc = 'Grep (fff)' })
vim.keymap.set('n', '<leader><space>', find_files, { desc = 'Find files (fff)' })
vim.keymap.set('n', '\\f', find_files, { desc = 'Find files (fff)' })
vim.keymap.set('n', '\\g', live_grep, { desc = 'Live grep (fff)' })
vim.keymap.set('n', '\\z', function()
  require('fff').live_grep {
    grep = {
      modes = { 'fuzzy', 'plain' },
    },
  }
end, { desc = 'Fuzzy grep (fff)' })
vim.keymap.set({ 'n', 'x' }, '\\c', function()
  require('fff').live_grep_under_cursor()
end, { desc = 'Grep <cword> / selection (fff)' })

-- vim: ts=2 sts=2 sw=2 et
