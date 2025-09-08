local M = function()
  local ok, miniclue = pcall(require, 'mini.clue')
  if not ok then
    return
  end

  -- Helper: extra manual clues for 'c' operator (approximate which-key operator help)
  local c_operator_clues = {
    { mode = 'n', keys = 'c', desc = 'Change (operator)' },
    { mode = 'n', keys = 'cc', desc = 'Change line' },
    { mode = 'n', keys = 'cw', desc = 'Change word (to start of next word)' },
    { mode = 'n', keys = 'cW', desc = 'Change WORD' },
    { mode = 'n', keys = 'ciw', desc = 'Change inner word' },
    { mode = 'n', keys = 'caw', desc = 'Change a word (incl. space)' },
    { mode = 'n', keys = 'ciW', desc = 'Change inner WORD' },
    { mode = 'n', keys = 'caW', desc = 'Change a WORD' },
    { mode = 'n', keys = 'cis', desc = 'Change inner sentence' },
    { mode = 'n', keys = 'cas', desc = 'Change a sentence' },
    { mode = 'n', keys = 'cip', desc = 'Change inner paragraph' },
    { mode = 'n', keys = 'cap', desc = 'Change a paragraph' },
    { mode = 'n', keys = 'ci"', desc = 'Change inside "' },
    { mode = 'n', keys = 'ca"', desc = 'Change a "' },
    { mode = 'n', keys = "ci'", desc = "Change inside '" },
    { mode = 'n', keys = "ca'", desc = "Change a '" },
    { mode = 'n', keys = 'ci`', desc = 'Change inside ` backticks' },
    { mode = 'n', keys = 'ca`', desc = 'Change a ` backticks' },
    { mode = 'n', keys = 'ci(', desc = 'Change inside (...)' },
    { mode = 'n', keys = 'ca(', desc = 'Change a (...)' },
    { mode = 'n', keys = 'ci[', desc = 'Change inside [...]' },
    { mode = 'n', keys = 'ca[', desc = 'Change a [...]' },
    { mode = 'n', keys = 'ci{', desc = 'Change inside {...}' },
    { mode = 'n', keys = 'ca{', desc = 'Change a {...}' },
    { mode = 'n', keys = 'ci<', desc = 'Change inside <...>' },
    { mode = 'n', keys = 'ca<', desc = 'Change a <...>' },
    { mode = 'n', keys = 'cit', desc = 'Change inside tag' },
    { mode = 'n', keys = 'cat', desc = 'Change a tag' },
    { mode = 'n', keys = 'ciw', desc = 'Change inner word' },
    { mode = 'n', keys = 'cib', desc = 'Change inner block/()' },
    { mode = 'n', keys = 'cab', desc = 'Change a block/()' },
    { mode = 'n', keys = 'ciB', desc = 'Change inner Block/{}' },
    { mode = 'n', keys = 'caB', desc = 'Change a Block/{}' },
  }

  miniclue.setup {
    -- Triggers: approximate which-key coverage
    -- NOTE: Adding 'c' as trigger is optional and *experimental* (operator-pending caveats).
    triggers = {
      -- Leader (Normal / Visual)
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },

      -- Brackets
      { mode = 'n', keys = '[' },
      { mode = 'n', keys = ']' },

      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },

      -- g motions/prefixes
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },

      -- Marks (apostrophe / backtick)
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },

      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },

      -- Windows
      { mode = 'n', keys = '<C-w>' },

      -- z
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },

      -- Optional operator trigger for 'c' (shows manual clues above)
      { mode = 'n', keys = 'c' },
    },

    -- Clues: leader groups + generated + manual operator/textobject help
    clues = {

      -- Show intent for marks / registers (top-level group labels)
      { mode = 'n', keys = "'", desc = 'Marks' },
      { mode = 'n', keys = '`', desc = 'Marks (exact)' },
      { mode = 'n', keys = '"', desc = 'Registers' },
      { mode = 'i', keys = '<C-r>', desc = 'Insert register' },

      -- Generated sets
      miniclue.gen_clues.square_brackets(),
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers { show_contents = false },
      miniclue.gen_clues.windows {
        submode_move = true,
        submode_navigate = true,
        submode_resize = true,
      },
      miniclue.gen_clues.z(),

      -- Manual operator 'c' help (non-intrusive; no mappings created)
      c_operator_clues,
    },

    window = {
      delay = 350,
      config = {
        border = 'rounded',
        width = 'auto',
        row = 'auto',
        col = 'auto',
        anchor = 'NW',
      },
      -- keep default scroll keys (<C-d>/<C-u>)
    },
  }

  -- Optional custom highlights (reapply on colorscheme change)
  local aug = vim.api.nvim_create_augroup('MiniClueCustomHL', { clear = true })
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = aug,
    callback = function()
      pcall(vim.api.nvim_set_hl, 0, 'MiniClueSeparator', { link = 'Comment' })
      pcall(vim.api.nvim_set_hl, 0, 'MiniClueDescGroup', { link = 'Identifier' })
    end,
  })
end

return M
