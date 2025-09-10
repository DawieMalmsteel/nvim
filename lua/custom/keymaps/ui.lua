local core = require 'custom.keymaps.core'
local map = core.map

-- Wrap
map('n', '<leader>uw', function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = 'Toggle Wrap' })

-- Theme
map('n', '<leader>uc', function()
  local Snacks = core.sr 'snacks'
  if Snacks and Snacks.picker.colorschemes then
    Snacks.picker.colorschemes()
  else
    vim.notify('Snacks colorschemes picker không khả dụng', vim.log.levels.WARN)
  end
end, { desc = 'Change Colorscheme' })

-- Treesitter context
map('n', '<leader>tc', '<CMD>TSContext toggle<CR>', { desc = 'TS Context toggle' })

-- Mini starter
map('n', '<leader>uo', function()
  local starter = core.sr 'mini.starter'
  if starter then
    starter.open()
  end
end, { desc = 'Mini Starter' })

-- Mini map
map('n', '<leader>um', function()
  local m = core.sr 'mini.map'
  if m then
    m.toggle()
  end
end, { desc = 'Mini Map toggle' })
map('n', '<leader>uM', function()
  local m = core.sr 'mini.map'
  if m then
    m.toggle_focus()
  end
end, { desc = 'Mini Map focus' })

-- Dashboard (Snacks)
map('n', '<leader>tD', function()
  local Snacks = core.sr 'snacks'
  if Snacks and Snacks.dashboard then
    Snacks.dashboard()
  end
end, { desc = 'Toggle Dashboard' })

-- Explorer (Snacks)
map('n', '<leader>E', function()
  local Snacks = core.sr 'snacks'
  if Snacks and Snacks.explorer then
    Snacks.explorer()
  end
end, { desc = 'Snacks Explorer (cwd)' })

map('n', '<leader>n', function()
  local Snacks = core.sr 'snacks'
  if Snacks.config.picker and Snacks.config.picker.enabled then
    Snacks.picker.notifications()
  else
    Snacks.notifier.show_history()
  end
end, { desc = 'Notification History' })

map('n', '<leader>un', function()
  local Snacks = core.sr 'snacks'
  Snacks.notifier.hide()
end, { desc = 'Dismiss All Notifications' })
