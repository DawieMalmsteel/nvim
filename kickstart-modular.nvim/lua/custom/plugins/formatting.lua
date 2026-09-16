local pack = require 'custom.pack'

-- [[ Formatting ]]
pack.add { pack.gh 'stevearc/conform.nvim' }

require('conform').setup {
  notify_on_error = false,
  -- format_on_save = function(bufnr)
  --   local disable = { c = true, cpp = true }
  --   if disable[vim.bo[bufnr].filetype] then
  --     return nil
  --   end
  --   return { timeout_ms = 500, lsp_format = 'fallback' }
  -- end,
  formatters_by_ft = {
    lua = { 'stylua' },
  },
}

local function format()
  require('conform').format { async = true, lsp_format = 'fallback' }
end

vim.keymap.set('n', '<leader>uf', format, { desc = '[F]ormat buffer' })
vim.keymap.set('n', '<leader>us', format, { desc = '[F]ormat buffer' })
vim.keymap.set('n', '<leader>F', format, { desc = '[F]ormat buffer' })

-- vim: ts=2 sts=2 sw=2 et
