local M = function()
  require('mini.pairs').setup {
    mappings = {
      ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
      ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
      ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

      [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
      [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
      ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

      ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
      ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
      ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
    },
  }
  -- Auto-tag for JSX/TSX: type <Example> then get <Example></Example> with cursor inside.
  local function setup_tsx_autotag()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'typescriptreact', 'javascriptreact', 'tsx', 'jsx', 'html' },
      callback = function(args)
        vim.keymap.set('i', '>', function()
          local win = 0
          local _, col = unpack(vim.api.nvim_win_get_cursor(win))
          local line = vim.api.nvim_get_current_line()
          local before = line:sub(1, col)

          -- Bỏ qua nếu đang gõ closing tag hoặc self-closing
          if before:match '</[%w_:-]*$' or before:match '<[%w_:-][^<>]*/%s*$' then
            return '>'
          end

          -- Lấy tên tag vừa gõ
          local tag = before:match '<([%w_:-]+)[^<>]*$'
          if not tag then
            return '>'
          end

          -- Nếu sau con trỏ đã có </tag> thì bỏ
          local after = line:sub(col + 1)
          if after:match('^%s*</' .. tag .. '>') then
            return '>'
          end

          -- Chèn closing tag sau khi insert '>'
          vim.schedule(function()
            -- Lấy lại vị trí (sau khi '>' được chèn)
            local r, c = unpack(vim.api.nvim_win_get_cursor(win))
            local closing = '</' .. tag .. '>'
            vim.api.nvim_buf_set_text(0, r - 1, c, r - 1, c, { closing })
            -- Đưa con trỏ về giữa
            vim.api.nvim_win_set_cursor(win, { r, c })
          end)

          return '>'
        end, { buffer = args.buf, expr = true, desc = 'Auto close JSX/TSX tag' })
      end,
    })
  end
  setup_tsx_autotag()
end
return M
