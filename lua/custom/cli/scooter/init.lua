local Snacks = require 'snacks'

-- Open existing scooter terminal if one is available, otherwise create a new one
local function open_scooter()
  Snacks.terminal('scooter', {
    interactive = true,
    auto_close = true,
  })
end

-- Called by scooter to open the selected file at the correct line from the scooter search list
_G.EditLineFromScooter = function(file_path, line)
  local current_path = vim.fn.expand '%:p'
  local target_path = vim.fn.fnamemodify(file_path, ':p')
  if current_path ~= target_path then
    vim.cmd.edit(vim.fn.fnameescape(file_path))
  end
  vim.api.nvim_win_set_cursor(0, { line, 0 })
end

-- Opens scooter with the search text populated by the `search_text` arg
_G.OpenScooterSearchText = function(search_text)
  local escaped_text = vim.fn.shellescape(search_text:gsub('\r?\n', ' '))
  Snacks.terminal('scooter --search-text ' .. escaped_text, {
    interactive = true,
    auto_close = true,
  })
end

vim.keymap.set('n', '<leader>S', open_scooter, { desc = 'Open scooter' })

vim.keymap.set('v', '<leader>$', '"ay<ESC><cmd>lua OpenScooterSearchText(vim.fn.getreg("a"))<CR>', { desc = 'Search selected text in scooter' })
