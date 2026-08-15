-- fff.nvim — official file + content search picker.
--
-- Package renamed `dmtrKovalenko/fff.nvim` -> `dmtrKovalenko/fff` upstream.
-- After this change run:
--     :Lazy clean        -- remove the old fff.nvim dir
--     :Lazy sync/build   -- clone the new name + download/build the Rust binary
-- fff covers file-path search and content grep only. Buffers, diagnostics, LSP
-- symbols, undo, git branches/log, todo, marks, help, ... stay on Snacks picker.

return {
  'dmtrKovalenko/fff',
  build = function()
    -- downloads a prebuilt binary, or falls back to the rustup toolchain
    require('fff.download').download_or_build_binary()
  end,
  lazy = false, -- picker self-initialises on first use
  opts = {
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
  },
  keys = {
    {
      '<leader>ff',
      function()
        require('fff').find_files()
      end,
      desc = 'Find Files (fff)',
    },
    {
      '<leader>fg',
      function()
        require('fff').live_grep()
      end,
      desc = 'Live Grep (fff)',
    },
    {
      '<leader>sG',
      function()
        require('fff').live_grep()
      end,
      desc = 'Grep Global (fff)',
    },
    {
      '<leader>sg',
      function()
        require('fff').live_grep()
      end,
      desc = 'Grep (fff)',
    },
    {
      '<leader><space>',
      function()
        require('fff').find_files()
      end,
      desc = 'Find files (fff)',
    },
    {
      '\\f',
      function()
        require('fff').find_files()
      end,
      desc = 'Find files (fff)',
    },
    {
      '\\g',
      function()
        require('fff').live_grep()
      end,
      desc = 'Live grep (fff)',
    },
    {
      '\\z',
      function()
        require('fff').live_grep {
          grep = {
            modes = { 'fuzzy', 'plain' },
          },
        }
      end,
      desc = 'Fuzzy grep (fff)',
    },
    {
      '\\c',
      function()
        require('fff').live_grep_under_cursor()
      end,
      mode = { 'n', 'x' },
      desc = 'Grep <cword> / selection (fff)',
    },
  },
}
