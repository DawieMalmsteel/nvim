-- Các keymaps bổ sung gom vào một module riêng (Option C)
local core = require 'custom.keymaps.core'
local map = core.map

-----------------------------------------------------------------------
-- 1. Điều hướng cửa sổ (window navigation)
-----------------------------------------------------------------------
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus upper window' })

-----------------------------------------------------------------------
-- 2. Oldfiles (bị thiếu trong bản tách)
-----------------------------------------------------------------------
map('n', '<leader>o', '<CMD>Pick oldfiles<CR>', { desc = 'Recent Oldfiles' })

-----------------------------------------------------------------------
-- 3. Plugin spec picker (Snacks lazy)
-----------------------------------------------------------------------
map('n', '<leader>sp', function()
  local Snacks = core.sr 'snacks'
  if Snacks and Snacks.picker.lazy then
    Snacks.picker.lazy()
  else
    vim.notify('Snacks lazy picker không khả dụng', vim.log.levels.WARN)
  end
end, { desc = 'Plugin Specs' })

-----------------------------------------------------------------------
-- 4. Buffer picker + xoá nhanh bằng <C-d> (mini.pick)
-----------------------------------------------------------------------
local function mini_buffers_with_delete()
  local pick = require 'mini.pick'
  local function wipeout_cur()
    local matches = pick.get_picker_matches()
    if matches and matches.current and matches.current.bufnr then
      pcall(vim.api.nvim_buf_delete, matches.current.bufnr, {})
    end
  end
  pick.builtin.buffers({ include_current = true }, {
    mappings = { wipeout = { char = '<c-d>', func = wipeout_cur } },
  })
end
map('n', '<leader>R', mini_buffers_with_delete, { desc = 'Buffers (mini.pick) + delete' })
map('n', '<M-r>', mini_buffers_with_delete, { desc = 'Buffers (mini.pick) + delete' })

-----------------------------------------------------------------------
-- 5. Các toggle bổ sung (Markdown preview, inline fold)
-- (Để tách khỏi ui.lua cho rõ ràng)
-----------------------------------------------------------------------
map('n', '<leader>tm', '<CMD>RenderMarkdown toggle<CR>', { desc = 'Toggle Markdown Preview' })
map('n', '<leader>ti', '<CMD>InlineFoldToggle<CR>', { desc = 'Toggle Inline Fold' })

-- Kết thúc extras.lua
