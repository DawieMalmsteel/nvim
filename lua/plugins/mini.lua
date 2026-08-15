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
            'hipatterns',
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
        end)
      end,
    })

    -- mini.git / mini.diff: load on first buffer inside a git repo
    local mini_git_loaded = false
    vim.api.nvim_create_autocmd('BufReadPost', {
      callback = function(ev)
        if mini_git_loaded then
          return
        end
        if vim.b[ev.buf].mini_git_checked then
          return
        end
        vim.b[ev.buf].mini_git_checked = true
        local file = vim.api.nvim_buf_get_name(ev.buf)
        if file == '' then
          return
        end
        local dir = vim.fn.fnamemodify(file, ':p:h')
        -- finddir: thư mục .git; findfile: file .git (worktree / submodule)
        local d = vim.fn.finddir('.git', dir .. ';')
        if d == '' then
          d = vim.fn.findfile('.git', dir .. ';')
        end
        if d ~= '' then
          mini_git_loaded = true
          mini.setup_many { 'diff', 'git' }
        end
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
