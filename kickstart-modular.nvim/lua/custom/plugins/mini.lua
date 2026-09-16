local pack = require 'custom.pack'

-- [[ mini.nvim ]]
-- Collection of various small independent plugins/modules. Modules are still
-- set up on demand through config.mini_loader so startup stays light.
pack.add { pack.gh 'nvim-mini/mini.nvim' }

local mini = require 'config.mini_loader'

-- Formerly gated on lazy.nvim's `User VeryLazy`; run right after startup.
mini.after_start(function()
  mini.setup_many {
    'icons',
    'bufremove',
    'misc',
    'statusline',
    'hipatterns',
  }
end)

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
  once = true,
  callback = function()
    mini.after_start(function()
      mini.setup_many {
        'ai',
        'surround',
        'bracketed',
        'cursorword',
      }
    end)
  end,
})

vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  callback = function()
    mini.setup 'snippets'
  end,
})

-- vim: ts=2 sts=2 sw=2 et
