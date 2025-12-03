local map = vim.keymap.set

map('n', '<leader>td', function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable()
  end
end, { desc = 'Toggle diagnostics (Ctrl+x)' })

map('n', '<leader>tc', '<CMD>TSContext toggle<CR>', { desc = 'Toggle Treesitter Context' })

map('n', '<leader>tm', function()
  local mini_map = require 'mini.map'
  mini_map.toggle()
end, { desc = 'Toggle Mini Map' })

map('n', '<leader>ts', '<CMD>ShowkeysToggle<CR>', { desc = 'Toggle showkeys' })

map('n', '<leader>tw', function()
  if vim.wo.wrap then
    vim.wo.wrap = false
    vim.wo.linebreak = false
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.notify('Wrap: OFF', vim.log.levels.INFO)
  else
    vim.wo.wrap = true
    vim.wo.linebreak = true
    vim.opt_local.relativenumber = true
    vim.opt_local.number = true
    vim.notify('Wrap: ON', vim.log.levels.INFO)
  end
end, { desc = 'Toggle Wrap' })

-- map('n', '<leader>tT', '<Cmd>vertical term fish<CR>', { noremap = true, silent = true, desc = 'Terminal (vertical)' })

map('n', '<leader>tn', function()
  -- :set laststatus=0
  -- :set nonumber=0
  -- :set statuscolumn=""
  -- :set signcolumn=no
  if vim.o.number == false then
    vim.o.laststatus = 2
    vim.wo.number = true
    -- vim.wo.relativenumber = true
    vim.wo.signcolumn = 'yes'
    vim.notify('Numbers: ON', vim.log.levels.INFO)
  else
    vim.o.laststatus = 0
    vim.wo.number = false
    -- vim.wo.relativenumber = false
    vim.wo.signcolumn = 'no'
    vim.wo.statuscolumn = ''
    vim.notify('Numbers: OFF', vim.log.levels.INFO)
  end
end, { desc = 'Toggle Wrap' })
