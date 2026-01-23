local M = function()
  -- Mini Snippets
  local mini_snippets = require 'mini.snippets'
  mini_snippets.setup {
    snippets = { mini_snippets.gen_loader.from_lang() },
    mappings = {
      -- Expand snippet at cursor position. Created globally in Insert mode.
      expand = '<C-e>',
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
