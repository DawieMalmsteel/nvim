local M = function()
  -- Better Around/Inside textobjects
  --
  -- Examples:
  --  - va)  - [V]isually select [A]round [)]paren
  --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
  --  - ci'  - [C]hange [I]nside [']quote
  require('mini.ai').setup {
    n_lines = 500,
    -- mappings = { around_next = 'an', inside_next = 'in', around_last = 'al', inside_last = 'il' },
    mappings = {
      around_next = '',
      inside_next = '',
      around_last = '',
      inside_last = '',
    },
  }
end
return M
