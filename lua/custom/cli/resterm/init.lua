local Snacks = require 'snacks'

-- Open existing scooter terminal if one is available, otherwise create a new one
local function open_resterm()
  Snacks.terminal('resterm', {
    interactive = true,
    auto_close = true,
  })
end

vim.keymap.set('n', '<leader>R', open_resterm, { desc = 'Open scooter' })
