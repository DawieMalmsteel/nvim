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

  -- Override default_select to inject kind + filetype into vim.ui.select
  -- (default_select hardcodes its own opts table, so we must replicate the call)
  MiniSnippets.default_select = function(snippets, insert, opts)
    insert = insert or MiniSnippets.default_insert
    opts = opts or {}

    -- Same single-snippet shortcut as the original
    if #snippets == 1 and (opts.insert_single == nil or opts.insert_single == true) then
      insert(snippets[1])
      return
    end

    -- Replicate format_item from the original default_select
    local prefix_width = 0
    for _, s in ipairs(snippets) do
      prefix_width = math.max(prefix_width, vim.fn.strdisplaywidth(s.prefix or '<No prefix>'))
    end
    local format_item = function(s)
      local prefix = s.prefix or '<No prefix>'
      local desc = s.desc or s.description or '<No description>'
      local pad = string.rep(' ', prefix_width - vim.fn.strdisplaywidth(prefix))
      return prefix .. pad .. ' │ ' .. desc
    end

    local on_choice = vim.schedule_wrap(function(item, _) insert(item) end)
    vim.ui.select(snippets, {
      prompt = 'Snippets',
      format_item = format_item,
      kind = 'minisnippets',
      snacks = { _snippet_ft = vim.bo.filetype },
    }, on_choice)
  end
end
return M
