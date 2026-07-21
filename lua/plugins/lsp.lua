return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'saghen/blink.cmp',
  },
  opts = {
    inlay_hints = { enabled = true },
  },
  config = function()
    local Methods = vim.lsp.protocol.Methods
    local function client_supports(client, method, bufnr)
      if not client then
        return false
      end
      if vim.fn.has 'nvim-0.11' == 1 then
        return client:supports_method(method, bufnr)
      else
        return client.supports_method(method, { bufnr = bufnr })
      end
    end

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('nvim-lsp-attach', { clear = true }),
      callback = function(event)
        local buf = event.buf
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Keymaps moved to a separate module
        require('config.lsp_keymaps').apply(buf, client)

        -- Document highlight (kept here)
        if client_supports(client, Methods.textDocument_documentHighlight, buf) then
          local hl_group = vim.api.nvim_create_augroup('nvim-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = buf,
            group = hl_group,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = buf,
            group = hl_group,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('nvim-lsp-detach', { clear = true }),
            callback = function(ev)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = hl_group, buffer = ev.buf }
            end,
          })
        end
      end,
    })

    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(d)
          local m = {
            [vim.diagnostic.severity.ERROR] = d.message,
            [vim.diagnostic.severity.WARN] = d.message,
            [vim.diagnostic.severity.INFO] = d.message,
            [vim.diagnostic.severity.HINT] = d.message,
          }
          return m[d.severity]
        end,
      },
    }

    local capabilities = require('blink.cmp').get_lsp_capabilities()
    -- local capabilities = require('mini.completion').get_lsp_capabilities()
    local servers = require('config.lsp_servers').servers

    for name, cfg in pairs(servers) do
      cfg.capabilities = vim.tbl_deep_extend('force', {}, capabilities, cfg.capabilities or {})
      vim.lsp.config(name, cfg) -- Configure the server
      vim.lsp.enable(name) -- Enable the server
    end

    -- vim.lsp.enable 'gleam'
  end,
}
