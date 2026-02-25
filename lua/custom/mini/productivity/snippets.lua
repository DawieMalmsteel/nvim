local M = function()
  -- Mini Snippets
  local mini_snippets = require 'mini.snippets'
  mini_snippets.setup {
    snippets = {
      mini_snippets.gen_loader.from_lang(),
      -- Example of friendly snippets
      -- mini_snippets.gen_loader.from_lang {
      --   lang_patterns = {
      --     cs = { 'csharp.json' },
      --     plaintex = { 'latex.json' },
      --   },
      -- },

      -- custom loader for snippets stored in `~/.config/nvim/snippets/`
      function(context)
        local rel_path = '~/.config/nvim/snippets/' .. context.lang
        if vim.fn.filereadable(rel_path) == 0 then
          return
        end
        return MiniSnippets.read_file(rel_path)
      end,
    },
    mappings = {
      -- Expand snippet at cursor position. Created globally in Insert mode.
      expand = '<C-a>',
      -- Interact with default `expand.insert` session.
      -- Created for the duration of active session(s)
      jump_next = '<C-n>',
      jump_prev = '<C-p>',
      stop = '<C-c>',
    },
  }
  -- MiniSnippets.start_lsp_server()
end
return M
