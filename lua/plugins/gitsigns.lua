return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '▏' },
      change = { text = '▏' },
      delete = { text = '▏' },
      topdelete = { text = '▏' },
      changedelete = { text = '▏' },
      untracked = { text = '▏' },
    },

    signs_staged = {
      add = { text = '▏' },
      change = { text = '▏' },
      delete = { text = '▏' },
      topdelete = { text = '▏' },
      changedelete = { text = '▏' },
    },

    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    word_diff = true,
    current_line_blame_opts = {
      delay = 300,
      use_focus = true,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    attach_to_untracked = true,

    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(lhs, rhs, desc)
        vim.keymap.set('n', lhs, rhs, {
          buffer = bufnr,
          silent = true,
          desc = desc,
        })
      end

      map('[G', function()
        gs.nav_hunk 'first'
      end, 'First git hunk')
      map('[g', function()
        gs.nav_hunk 'prev'
      end, 'Previous git hunk')
      map(']g', function()
        gs.nav_hunk 'next'
      end, 'Next git hunk')
      map(']G', function()
        gs.nav_hunk 'last'
      end, 'Last git hunk')

      map('<leader>hs', gs.stage_hunk, 'Stage hunk')
      map('<leader>hr', gs.reset_hunk, 'Reset hunk')
      map('<leader>hp', gs.preview_hunk, 'Preview hunk')
      map('<leader>go', gs.preview_hunk, 'Preview hunk')
      map('<leader>hP', gs.preview_hunk_inline, 'Preview hunk inline')
      map('<leader>hb', gs.blame_line, 'Blame current line')
      map('<leader>hB', gs.toggle_current_line_blame, 'Toggle line blame')
      map('<leader>hD', function()
        gs.diffthis '~1'
      end, 'Diff against previous commit')
      map('<leader>hd', gs.diffthis, 'Diff current file')
      map('<leader>hw', gs.toggle_word_diff, 'Toggle word diff')
      map('<leader>hn', gs.toggle_numhl, 'Toggle line number highlights')
      map('<leader>hl', gs.toggle_linehl, 'Toggle line highlights')
      map('<leader>hS', gs.toggle_signs, 'Toggle git signs')

      vim.keymap.set('v', '<leader>hs', function()
        gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { buffer = bufnr, silent = true, desc = 'Stage selected hunk' })

      vim.keymap.set('v', '<leader>hr', function()
        gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { buffer = bufnr, silent = true, desc = 'Reset selected hunk' })

      vim.keymap.set({ 'o', 'x' }, 'ih', '<Cmd>Gitsigns select_hunk<CR>', {
        buffer = bufnr,
        silent = true,
        desc = 'Inner git hunk',
      })
    end,
  },
}
