local M = function()
  local ok, clue = pcall(require, 'mini.clue')
  if not ok then
    return
  end

  local function mode_nx(keys)
    return { mode = 'n', keys = keys }, { mode = 'x', keys = keys }
  end
  clue.setup {
    triggers = {
      -- Leader triggers
      mode_nx '<leader>',

      -- Built-in completion
      { mode = 'i', keys = '<c-x>' },

      -- `g` key
      mode_nx 'g',

      -- Marks
      mode_nx "'",
      mode_nx '`',

      -- Registers
      mode_nx '"',
      { mode = 'i', keys = '<c-r>' },
      { mode = 'c', keys = '<c-r>' },

      -- Window commands
      { mode = 'n', keys = '<c-w>' },

      -- bracketed commands
      { mode = 'n', keys = '[' },
      { mode = 'n', keys = ']' },

      -- `z` key
      mode_nx 'z',

      -- surround
      mode_nx 's',

      -- text object
      { mode = 'x', keys = 'i' },
      { mode = 'x', keys = 'a' },
      { mode = 'o', keys = 'i' },
      { mode = 'o', keys = 'a' },

      -- option toggle (mini.basics)
      -- { mode = 'n', keys = 'm' },
    },

    clues = {
      -- Enhance this by adding descriptions for <Leader> mapping groups
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers { show_contents = true },
      clue.gen_clues.windows { submode_resize = true, submode_move = true },
      clue.gen_clues.z(),
    },

    -- Clue window settings
    window = {
      -- Floating window config
      config = {
        border = 'rounded',
        width = 'auto',
      },

      -- Delay before showing clue window
      delay = 0,

      -- Keys to scroll inside the clue window
      scroll_down = '<C-d>',
      scroll_up = '<C-u>',
    },
  }
end

return M
