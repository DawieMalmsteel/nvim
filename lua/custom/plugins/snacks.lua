return {
  {
    'folke/snacks.nvim',
    opts = {
      picker = {
        ui_select = true,
        -- Override preview for vim.ui.select kinds that don't have item.file
        kinds = {
          -- mini.snippets: preview snippet body with current buffer's filetype highlighting
          minisnippets = {
            preview = function(ctx)
              local snippet = ctx.item and ctx.item.item
              if type(snippet) ~= 'table' then
                return
              end
              local body = snippet.body
              if type(body) == 'table' then
                body = table.concat(body, '\n')
              end
              if type(body) ~= 'string' or body == '' then
                ctx.preview:reset()
                ctx.preview:set_lines { '(No body)' }
                return
              end
              local ft = ctx.picker.opts._snippet_ft or ''
              ctx.item.preview = { text = body, ft = ft, loc = false }
              Snacks.picker.preview.preview(ctx)
            end,
          },
          -- LSP code actions: build a real unified diff from action.edit
          -- vim.ui.select items for codeaction have shape: {action: lsp.CodeAction, ctx: lsp.HandlerContext}
          codeaction = {
            preview = function(ctx)
              local raw = ctx.item and ctx.item.item
              if type(raw) ~= 'table' then
                ctx.preview:notify('No action data', 'warn', { item = false })
                return
              end
              local action = raw.action
              local lsp_ctx = raw.ctx
              if type(action) ~= 'table' then
                ctx.preview:notify('No action data', 'warn', { item = false })
                return
              end

              local client = lsp_ctx and vim.lsp.get_client_by_id(lsp_ctx.client_id)
              local enc = client and client.offset_encoding or 'utf-16'

              -- Build diff from a resolved action that has .edit
              local function render_edit(resolved)
                local edit = resolved.edit
                if not edit then
                  -- Command-only action — show command info
                  local lines = {
                    'Title:   ' .. (resolved.title or '?'),
                    'Kind:    ' .. (resolved.kind or '?'),
                    '',
                  }
                  if resolved.command then
                    local cmd = type(resolved.command) == 'table' and resolved.command or resolved
                    lines[#lines + 1] = 'Command: ' .. (cmd.command or '?')
                    if cmd.arguments then
                      lines[#lines + 1] = ''
                      vim.list_extend(lines, vim.split(vim.inspect(cmd.arguments), '\n', { plain = true }))
                    end
                  end
                  ctx.preview:reset()
                  ctx.preview:set_lines(lines)
                  return
                end

                -- Collect (uri, TextEdit[]) pairs — skip file-op entries (create/rename/delete)
                local file_edits = {}
                if edit.changes then
                  for uri, edits in pairs(edit.changes) do
                    file_edits[#file_edits + 1] = { uri = uri, edits = edits }
                  end
                elseif edit.documentChanges then
                  for _, change in ipairs(edit.documentChanges) do
                    -- no .kind means TextDocumentEdit; .kind means CreateFile/RenameFile/DeleteFile
                    if not change.kind and change.textDocument then
                      file_edits[#file_edits + 1] = { uri = change.textDocument.uri, edits = change.edits }
                    end
                  end
                end

                if #file_edits == 0 then
                  ctx.preview:reset()
                  ctx.preview:set_lines { '(No text edits)' }
                  return
                end

                local diff_parts = {}
                for _, fe in ipairs(file_edits) do
                  local fname = vim.uri_to_fname(fe.uri)
                  -- Use vim.uri_to_bufnr + bufload so we always have a valid buffer
                  local file_bufnr = vim.uri_to_bufnr(fe.uri)
                  vim.fn.bufload(file_bufnr)
                  local original = vim.api.nvim_buf_get_lines(file_bufnr, 0, -1, false)

                  -- Apply edits on a scratch buffer (correct encoding, handles overlaps)
                  local scratch = vim.api.nvim_create_buf(false, true)
                  vim.api.nvim_buf_set_lines(scratch, 0, -1, false, original)
                  vim.lsp.util.apply_text_edits(fe.edits, scratch, enc)
                  local modified = vim.api.nvim_buf_get_lines(scratch, 0, -1, false)
                  vim.api.nvim_buf_delete(scratch, { force = true })

                  local diff = vim.diff(table.concat(original, '\n') .. '\n', table.concat(modified, '\n') .. '\n', { ctxlen = 3 })
                  if diff and diff ~= '' then
                    local short = vim.fn.fnamemodify(fname, ':~:.')
                    diff_parts[#diff_parts + 1] = '--- a/' .. short .. '\n+++ b/' .. short .. '\n' .. vim.trim(diff)
                  end
                end

                if #diff_parts == 0 then
                  ctx.preview:reset()
                  ctx.preview:set_lines { '(No changes)' }
                  return
                end

                ctx.item.diff = table.concat(diff_parts, '\n')
                Snacks.picker.preview.diff(ctx)
              end

              -- 1. Already resolved and cached on the item → skip network round-trip
              if ctx.item._resolved then
                render_edit(ctx.item._resolved)
                return
              end

              -- 2. Action already has .edit → no need to resolve
              if action.edit then
                ctx.item._resolved = action
                render_edit(action)
                return
              end

              -- 3. Need codeAction/resolve (e.g. rust-analyzer refactors)
              if client and client:supports_method 'codeAction/resolve' then
                ctx.preview:reset()
                ctx.preview:set_lines { 'Resolving ' .. (action.title or '') .. '...' }

                client:request('codeAction/resolve', action, function(err, resolved)
                  vim.schedule(function()
                    if ctx.picker.closed then
                      return
                    end
                    ctx.item._resolved = (not err and resolved) or action
                    -- Clear cached preview item so snacks re-runs the previewer
                    ctx.picker.preview.item = nil
                    ctx.picker:show_preview()
                  end)
                end, lsp_ctx.bufnr)
                return
              end

              -- 4. Server does not support resolve — command-only action
              ctx.item._resolved = action
              render_edit(action)
            end,
          },
        },
        layout = {
          select = {
            layout = 'ivy',
          },
          layout = {
            box = 'horizontal',
            backdrop = true,
            width = 0.8,
            height = 0.9,
            border = 'none',
            {
              box = 'vertical',
              { win = 'input', height = 1, border = true, title = '{title} {live} {flags}', title_pos = 'center' },
              { win = 'list', title = ' Results ', title_pos = 'center', border = true },
            },
            {
              win = 'preview',
              title = '{preview:Preview}',
              width = 0.5,
              border = true,
              title_pos = 'center',
            },
          },
        },
        previewers = {
          git = {
            native = true,
            args = { '-c', 'delta.line-numbers=false', '-c', 'delta.side-by-side=false' },
          },
          diff = {
            style = 'fancy',
            cmd = { 'delta' },
          },
        },
        file = {
          max_size = 1024 * 1024, -- 1MB
          max_line_length = 500, -- max line length
          ft = nil, ---@type string? filetype for highlighting. Use `nil` for auto detect
        },
      },
      terminal = {
        win = {
          position = 'float',
        },
      },
      statuscolumn = {
        enabled = true,
        left = {
          'mark',
          'git',
        },
        right = {
          'sign',
          'fold',
        },
      }, -- ERROR:this make error with default nvim statuscolumn, disable it
      image = { enabled = true, doc = { inline = false } },
      -- Centered floating input
      input = {
        enabled = true,
        win = {
          relative = 'editor',
          style = 'minimal',
          border = 'rounded',
          width = 100,
          height = 1,
          row = math.floor((vim.o.lines - 1) / 2.2),
          -- center vertically
          col = math.floor((vim.o.columns - 100) / 2), -- center horizontally
          title = ' Input ',
        },
      },
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = false },
      scroll = { enabled = false },
      words = { enabled = true },
      zen = { enabled = true },
      indent = {
        enabled = false,
        scope = {
          enabled = true, -- enable highlighting the current scope
          priority = 200,
          char = '│',
          underline = true, -- underline the start of the scope
          only_current = true, -- only show scope in the current window
        },
        chunk = {
          enabled = false,
          only_current = true,
          char = {
            corner_top = '╭',
            corner_bottom = '╰',
            horizontal = '─',
            vertical = '│',
            arrow = '>',
          },
        },
      },
      dashboard = {
        enabled = true, -- disable the dashboard by default
        width = 80,
        row = nil, -- dashboard position. nil for center
        col = nil, -- dashboard position. nil for center
        pane_gap = 4, -- empty columns between vertical panes
        autokeys = '1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', -- autokey sequence
        preset = {
          pick = nil,
          keys = {},

          -- header = [[
          -- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡀⠀
          -- ⢀⣀⣀⡀⠀⣀⡀⠀⡀⠀⠀⣀⠀⠀⠀⣀⠀⠀⢠⡘⣇⣤⣄⠀⢀⡤⣄⢀⣼⣤⡄⠈⣹⠟⠀
          -- ⠀⠿⠁⠻⠐⢧⡽⠃⠳⠿⢷⠏⠀⠀⠀⠸⠾⠷⠟⠀⠟⠁⠻⠀⠿⠶⠻⠄⠸⠇⠀⠀⣡⠀⠀
          -- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          --         @NeoVim của Dwcks 🦀        ]],
          header = [[
                    |  \ \ | |/ /
                    |  |\ `' ' /
                    |  ;'aorta \      / , pulmonary
                    | ;    _,   |    / / ,  arteries
           superior | |   (  `-.;_,-' '-' ,
          vena cava | `,   `-._       _,-'_
                    |,-`.    `.)    ,<_,-'_, pulmonary
                   ,'    `.   /   ,'  `;-' _,  veins
                  ;        `./   /`,    \-'
                  | right   /   |  ;\   |\
                  | atrium ;_,._|_,  `, ' \
                  |        \    \ `       `,
                  `      __ `    \   left  ;,
                   \   ,'  `      \,  ventricle
                    \_(            ;,      ;;
                    |  \           `;,     ;;
           inferior |  |`.          `;;,   ;'
          vena cava |  |  `-.        ;;;;,;'
                    |  |    |`-.._  ,;;;;;'
                    |  |    |   | ``';;;'
                            aorta                   ]],
        },

        sections = {
          {
            { section = 'header' },
            { pane = 2, icon = ' ', key = 'f', desc = 'Find File', action = ':Pick files' },
            { pane = 2, icon = '', key = 'n', desc = 'New File', action = ':ene | startinsert' },
            { pane = 2, icon = ' ', key = 'g', desc = 'Find Text', action = ':Pick grep_live' },
            { pane = 2, icon = ' ', key = 'r', desc = 'Recent Files', action = ':Pick oldfiles' },
            {
              pane = 2,
              icon = ' ',
              key = 'c',
              desc = 'Config',
              action = ":lua require('mini.pick').builtin.files(nil, { source = { cwd = vim.fn.stdpath 'config' } })",
            },
            {
              pane = 2,
              icon = '',
              key = 's',
              desc = 'Session restore (mini)',
              -- action = ':lua MiniSessions.read(nil, {})',
              action = ':lua require("persistence").load()',
            },
            { pane = 2, icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
            { pane = 2, icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
            { pane = 2, icon = ' ', title = 'Keymaps', section = 'keys', indent = 2, padding = 1, layout = 'vertical' },
            { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
            { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
            { section = 'startup' },
          },
        },
      },
    },
    keys = {
      {
        'grI',
        function()
          Snacks.picker.lsp_incoming_calls()
        end,
        desc = 'C[a]lls Incoming',
      },
      {
        'grO',
        function()
          Snacks.picker.lsp_outgoing_calls()
        end,
        desc = 'C[a]lls Outgoing',
      },
      {
        '<leader>sb',
        function()
          local curr_path = vim.fn.expand '%:p'
          Snacks.picker.todo_comments { ---@diagnostic disable-line: undefined-field
            transform = function(item)
              local item_path = vim.fn.fnamemodify(item.cwd .. '/' .. item.file, ':p')
              return item_path == curr_path
            end,
          }
        end,
        desc = 'buffer Todo',
      },
      {
        '<leader>sa',
        function()
          Snacks.picker.todo_comments()
        end,
        desc = 'All Todo',
      },
      {
        '<leader>st',
        function()
          Snacks.picker.todo_comments { keywords = { 'TODO' } }
        end,
        desc = 'Todo',
      },
      {
        '<leader>se',
        function()
          Snacks.picker.todo_comments { keywords = { 'ERROR' } }
        end,
        desc = 'ERROR',
      },
      {
        '<leader>sn',
        function()
          Snacks.picker.todo_comments { keywords = { 'NOTE' } }
        end,
        desc = 'NOTE',
      },
      {
        '<leader>sf',
        function()
          Snacks.picker.todo_comments { keywords = { 'FIX' } }
        end,
        desc = 'FIX',
      },
      {
        '<leader>sw',
        function()
          Snacks.picker.todo_comments { keywords = { 'WARN' } }
        end,
        desc = 'WARN',
      },

      {
        '<leader>sp',
        function()
          Snacks.picker.todo_comments { keywords = { 'PERF' } }
        end,
        desc = 'PERF',
      },

      {
        '<leader>sh',
        function()
          Snacks.picker.todo_comments { keywords = { 'HACK' } }
        end,
        desc = 'HACK',
      },
      {
        '<leader>sT',
        function()
          Snacks.picker.todo_comments { keywords = { 'TEST' } }
        end,
        desc = 'TEST',
      },
    },
  },
}
