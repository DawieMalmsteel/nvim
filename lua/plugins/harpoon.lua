return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
    settings = {
      save_on_toggle = true,
    },
  },
  keys = function()
    local keys = {
      {
        '<M-w>',
        function()
          local harpoon = require 'harpoon'
          harpoon.ui:toggle_quick_menu(harpoon:list())
          -- print 'Harpoon Quick Menu toggled'
        end,
        desc = 'Harpoon Quick Menu',
      },
      {
        '<M-s>',
        function()
          require('harpoon'):list():add()
          -- print('📌 Added to Harpoon: ' .. vim.fn.expand '%:p')
          -- print '📌 Added to Harpoon'
        end,
        desc = 'Harpoon File',
      },
      {
        '<M-d>',
        function()
          require('harpoon'):list():next()
          -- print '➡️  Next Harpoon File'
        end,
        desc = 'Harpoon File',
      },

      {
        '<M-a>',
        function()
          require('harpoon'):list():prev()
          -- print '⬅️  Previous Harpoon File'
        end,
        desc = 'Harpoon File',
      },

      {
        '<M-x>',
        function()
          local harpoon = require 'harpoon'
          local list = harpoon:list()
          local current_file = vim.fn.expand '%:p'
          local index = nil

          for i, item in ipairs(list.items) do
            if vim.loop.fs_realpath(item.value) == vim.loop.fs_realpath(current_file) then
              index = i
              break
            end
          end

          if index then
            table.remove(list.items, index) -- Xoá và dịch phần tử lại
            -- print('🗑 Removed from Harpoon: ' .. current_file)
          else
            -- print '⚠ File not in Harpoon list'
          end
        end,
        desc = 'Harpoon Delete File',
      },
    }

    for i = 1, 9 do
      table.insert(keys, {
        '<leader-' .. i .. '>',
        function()
          require('harpoon'):list():select(i)
        end,
        desc = 'Harpoon to File ' .. i,
      })
    end
    return keys
  end,
}
