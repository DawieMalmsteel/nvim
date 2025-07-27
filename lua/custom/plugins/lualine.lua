return {
  'nvim-lualine/lualine.nvim',
  -- event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      theme = {
        normal = {
          a = { bg = 'NONE', fg = '#cba6f7' },
          b = { bg = 'NONE', fg = '#89b4fa' },
          c = { bg = 'NONE', fg = '#cdd6f4' },
        },
        insert = {
          a = { bg = 'NONE', fg = '#a6e3a1' },
          b = { bg = 'NONE', fg = '#89b4fa' },
          c = { bg = 'NONE', fg = '#cdd6f4' },
        },
        visual = {
          a = { bg = 'NONE', fg = '#f9e2af' },
          b = { bg = 'NONE', fg = '#89b4fa' },
          c = { bg = 'NONE', fg = '#cdd6f4' },
        },
        replace = {
          a = { bg = 'NONE', fg = '#f38ba8' },
          b = { bg = 'NONE', fg = '#89b4fa' },
          c = { bg = 'NONE', fg = '#cdd6f4' },
        },
        command = {
          a = { bg = 'NONE', fg = '#fab387' },
          b = { bg = 'NONE', fg = '#89b4fa' },
          c = { bg = 'NONE', fg = '#cdd6f4' },
        },
        inactive = {
          a = { bg = 'NONE', fg = '#45475a' },
          b = { bg = 'NONE', fg = '#45475a' },
          c = { bg = 'NONE', fg = '#45475a' },
        },
      },
      icons_enabled = true,
      component_separators = { left = '│', right = '│' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'ministarter' } },
      globalstatus = true,
    },
    sections = {
      lualine_a = {
        {
          function()
            local mode = vim.fn.mode()
            local mode_info = {
              n = { name = 'NORMAL', icon = '' },
              i = { name = 'INSERT', icon = '' },
              v = { name = 'VISUAL', icon = '✂️' },
              V = { name = 'V-LINE', icon = '' },
              [''] = { name = 'V-BLOCK', icon = '' },
              c = { name = 'COMMAND', icon = '' },
              R = { name = 'REPLACE', icon = '' },
              t = { name = 'TERMINAL', icon = '' },
            }
            local info = mode_info[mode] or { name = mode, icon = '' }
            return info.icon .. ' ' .. info.name
          end,
          color = function()
            local mode = vim.fn.mode()
            if mode == 'v' or mode == 'V' or mode == '' then
              return { fg = '#f9e2af' }
            elseif mode == 'i' then
              return { fg = '#a6e3a1' }
            elseif mode == 'r' then
              return { fg = '#f38ba8' }
            elseif mode == 'c' then
              return { fg = '#fab387' }
            else
              return { fg = '#cba6f7' }
            end
          end,
        },
      },
      lualine_b = {
        { 'branch', icon = '' },
        {
          'diagnostics',
          symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
        },
      },
      lualine_c = {
        {
          'filename',
          path = 1,
          symbols = { modified = '●', readonly = '🔒' },
          color = function()
            return vim.bo.modified and { fg = '#fab387' } or { fg = '#cdd6f4' }
          end,
        },
        { 'filetype', icon_only = true, separator = ' ' },
      },
      lualine_x = {
        {
          function()
            local reg = vim.fn.reg_recording()
            if reg == '' then
              return ''
            end
            return '⏺️ Recording @' .. reg
          end,
          color = { fg = '#f38ba8' },
        },
        -- {
        --   function()
        --     local ok, copilot = pcall(require, "copilot.api")
        --     if ok and copilot.client and copilot.client.is_active and copilot.client.is_active() then
        --       return " Copilot"
        --     end
        --     return " Off"
        --   end,
        --   color = { fg = "#89b4fa" },
        --   cond = function()
        --     return package.loaded["copilot"] ~= nil
        --   end,
        -- },
      },
      lualine_y = { { 'progress', icon = '📏' } },
      lualine_z = { { 'location', icon = '📍' } },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        {
          'filename',
          path = 1,
          symbols = { modified = '●', readonly = '🔒' },
          color = { fg = '#45475a' },
        },
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = { { 'location', icon = '📍' } },
    },
    extensions = { 'lazy' },
  },
}
