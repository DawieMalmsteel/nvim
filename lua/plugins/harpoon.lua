local function normalize_directory(path)
  path = vim.fn.fnamemodify(vim.fn.expand(path), ':p')
  return vim.fs.normalize(vim.uv.fs_realpath(path) or path)
end

local function directory_value(item)
  return type(item) == 'table' and item.value or item
end

local function current_directory()
  local path = vim.api.nvim_buf_get_name(0)
  if path ~= '' and vim.fn.isdirectory(path) == 1 then
    return normalize_directory(path)
  end
  if path ~= '' and vim.fn.filereadable(path) == 1 then
    return normalize_directory(vim.fn.fnamemodify(path, ':h'))
  end
  return normalize_directory(vim.fn.getcwd())
end

local function add_fff_directory()
  local list = require('harpoon'):list 'fff_dirs'
  local path = current_directory()

  for i = 1, list:length() do
    local item = list:get(i)
    if item and normalize_directory(directory_value(item)) == path then
      vim.notify('Directory already stored', vim.log.levels.INFO)
      return
    end
  end

  list:add()
end

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
    fff_dirs = {
      create_list_item = function(_, path)
        return { value = normalize_directory(path or current_directory()) }
      end,
      display = function(item)
        return vim.fn.fnamemodify(normalize_directory(directory_value(item)), ':~')
      end,
      equals = function(a, b)
        a, b = directory_value(a), directory_value(b)
        if not a or not b then
          return a == b
        end
        return normalize_directory(a) == normalize_directory(b)
      end,
      select = function(item)
        local path = directory_value(item)
        if not path then
          return
        end
        path = normalize_directory(path)
        if vim.fn.isdirectory(path) ~= 1 then
          vim.notify('Directory not found: ' .. path, vim.log.levels.WARN)
          return
        end
        require('fff').find_files_in_dir(path)
      end,
    },
  },
  config = function(_, opts)
    local harpoon = require 'harpoon'
    harpoon:setup(opts)
    harpoon:extend {
      UI_CREATE = function(ctx)
        if not harpoon.ui.active_list or harpoon.ui.active_list.name ~= 'fff_dirs' then
          return
        end

        vim.keymap.set('n', 'd', function()
          local line = vim.api.nvim_win_get_cursor(0)[1]
          local contents = vim.api.nvim_buf_get_lines(ctx.bufnr, 0, -1, false)
          table.remove(contents, line)

          local list = harpoon.ui.active_list
          if #contents == 0 then
            list:clear()
          else
            vim.api.nvim_buf_set_lines(ctx.bufnr, 0, -1, false, contents)
            harpoon.ui:save()
          end

          harpoon:sync()
          local save_on_toggle = harpoon.ui.settings.save_on_toggle
          harpoon.ui.settings.save_on_toggle = false
          harpoon.ui:toggle_quick_menu()
          harpoon.ui.settings.save_on_toggle = save_on_toggle
        end, { buffer = ctx.bufnr, silent = true, desc = 'Delete FFF directory' })
      end,
    }
  end,
  keys = function()
    local keys = {
      {
        '<leader>fa',
        add_fff_directory,
        desc = 'FFF Add Directory',
      },
      {
        '<leader>fm',
        function()
          local harpoon = require 'harpoon'
          harpoon.ui:toggle_quick_menu(harpoon:list 'fff_dirs')
        end,
        desc = 'FFF Directory Menu',
      },
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
        '<leader>f' .. i,
        function()
          require('harpoon'):list('fff_dirs'):select(i)
        end,
        desc = 'FFF Directory ' .. i,
      })
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
