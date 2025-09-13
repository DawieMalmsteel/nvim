local map = vim.keymap.set

map('n', '<leader>n', function()
  local Snacks = require 'snacks'
  if Snacks.config.picker and Snacks.config.picker.enabled then
    Snacks.picker.notifications()
  else
    Snacks.notifier.show_history()
  end
end, { desc = 'Notification History' })

map('n', '<leader>un', function()
  local Snacks = require 'snacks'
  Snacks.notifier.hide()
end, { desc = 'Dismiss All Notifications' })
