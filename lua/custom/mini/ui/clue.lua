local M = function()
  local ok, clue = pcall(require, 'mini.clue')
  if not ok then
    return
  end

  local function mode_nx(keys)
    return { mode = 'n', keys = keys }, { mode = 'x', keys = keys }
  end

  local triggers = {}
  local function add(...)
    for i = 1, select('#', ...) do
      table.insert(triggers, (select(i, ...)))
    end
  end

  -- Leader triggers
  add(mode_nx '<leader>')

  -- Built-in completion
  add { mode = 'i', keys = '<c-x>' }

  -- `g` key
  add(mode_nx 'g')

  -- Marks
  add(mode_nx "'")
  add(mode_nx '`')

  -- Registers
  add(mode_nx '"')
  add { mode = 'i', keys = '<c-r>' }
  add { mode = 'c', keys = '<c-r>' }

  -- Window commands
  add { mode = 'n', keys = '<c-w>' }

  -- bracketed commands
  add { mode = 'n', keys = '[' }
  add { mode = 'n', keys = ']' }

  -- `z` key
  add(mode_nx 'z')

  -- surround
  add(mode_nx 's')
  add { mode = 'x', keys = 's' }

  -- text object
  add { mode = 'x', keys = 'i' }
  add { mode = 'x', keys = 'a' }
  add { mode = 'o', keys = 'i' }
  add { mode = 'o', keys = 'a' }

  clue.setup {
    triggers = triggers,

    clues = {
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers { show_contents = true },
      clue.gen_clues.windows { submode_resize = true, submode_move = true },
      clue.gen_clues.z(),
    },

    -- Clue window settings
    window = {
      config = {
        border = 'rounded',
        width = 'auto',
      },
      delay = 0,
      scroll_down = '<C-d>',
      scroll_up = '<C-u>',
    },
  }
end

return M
