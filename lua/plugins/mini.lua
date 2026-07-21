return {
  -- Collection of various small independent plugins/modules.
  -- Keep the monorepo lazy and setup each mini module only when it becomes useful.
  'nvim-mini/mini.nvim',
  lazy = true,
  init = function()
    local mini = require 'config.mini_lazy'

    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      once = true,
      callback = function()
        mini.after_start(function()
          mini.setup_many {
            'icons',
            'bufremove',
            'misc',
            'statusline',
          }
        end)
      end,
    })

    vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
      once = true,
      callback = function(ev)
        mini.after_start(function()
          mini.setup_many {
            'ai',
            'surround',
            'bracketed',
            'cursorword',
          }

          local file = vim.api.nvim_buf_get_name(ev.buf)
          if file ~= '' and vim.fs.root(file, { '.git' }) then
            mini.setup_many { 'diff', 'git' }
          end
        end)
      end,
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = {
        'astro',
        'css',
        'heex',
        'html',
        'html-eex',
        'javascript',
        'javascriptreact',
        'rust',
        'svelte',
        'typescript',
        'typescriptreact',
        'vue',
      },
      once = true,
      callback = function()
        mini.after_start(function()
          mini.setup 'hipatterns'
        end)
      end,
    })

    vim.api.nvim_create_autocmd('InsertEnter', {
      once = true,
      callback = function()
        mini.setup 'snippets'
      end,
    })
  end,
}
