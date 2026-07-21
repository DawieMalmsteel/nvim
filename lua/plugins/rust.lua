return {
  {
    'mrcjkb/rustaceanvim',
    ft = { 'rust' },
    opts = function()
      return {
        server = {
          on_attach = function(_, bufnr)
            vim.keymap.set('n', '<leader>cA', function()
              vim.cmd.RustLsp 'codeAction'
            end, { desc = 'Rust Code Action', buffer = bufnr })

            vim.keymap.set('n', '<leader>dr', function()
              vim.cmd.RustLsp 'debuggables'
            end, { desc = 'Rust Debuggables', buffer = bufnr })
          end,
          -- default_settings = require('config.lsp_servers').rust_analyzer_settings,
        },
      }
    end,
    config = function(_, opts)
      local codelldb = vim.fn.exepath 'codelldb'
      local mason = vim.fn.stdpath 'data' .. '/mason'
      local lib_ext = vim.uv.os_uname().sysname == 'Darwin' and '.dylib' or '.so'
      local library_path = mason .. '/packages/codelldb/extension/lldb/lib/liblldb' .. lib_ext

      if codelldb ~= '' and vim.uv.fs_stat(library_path) then
        opts.dap = {
          adapter = require('rustaceanvim.config').get_codelldb_adapter(codelldb, library_path),
        }
      end

      vim.g.rustaceanvim = vim.tbl_deep_extend('keep', vim.g.rustaceanvim or {}, opts or {})

      if vim.fn.executable 'rust-analyzer' == 0 then
        vim.notify('rust-analyzer not found in PATH. Mason should install it shortly.', vim.log.levels.WARN, {
          title = 'rustaceanvim',
        })
      end
    end,
  },
}
