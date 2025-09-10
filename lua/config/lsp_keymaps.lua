local M = {}

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

function M.apply(buf, client)
  local function map(lhs, rhs, desc, mode)
    vim.keymap.set(mode or 'n', lhs, rhs, { buffer = buf, desc = 'LSP: ' .. desc })
  end

  map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
  map('<leader>cR', vim.lsp.buf.rename, '[R]e[n]ame')

  map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
  map('<leader>ca', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

  if client_supports(client, Methods.textDocument_inlayHint, buf) then
    map('<leader>th', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = buf })
    end, '[T]oggle Inlay [H]ints')
  end
end

return M
