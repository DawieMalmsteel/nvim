return {
  'joryeugene/dadbod-grip.nvim',
  version = '*',
  config = function()
    require('dadbod-grip').setup {
      completion = false,
      keymaps = { qpad_execute = '<C-r>' }, -- or whatever key you prefer
    }
    require('blink.cmp').setup {
      sources = {
        providers = {
          dadbod_grip = { name = 'Grip SQL', module = 'dadbod-grip.completion.blink' },
        },
      },
    }
  end,
  keys = {
    { '<leader>db', '<cmd>GripConnect<cr>', desc = 'DB connect' },
    { '<leader>dg', '<cmd>Grip<cr>', desc = 'DB grid' },
    { '<leader>dt', '<cmd>GripTables<cr>', desc = 'DB tables' },
    { '<leader>dq', '<cmd>GripQuery<cr>', desc = 'DB query pad' },
    { '<leader>ds', '<cmd>GripSchema<cr>', desc = 'DB schema' },
    { '<leader>dh', '<cmd>GripHistory<cr>', desc = 'DB history' },
    { '<leader>dd', '<cmd>GripStart<cr>', desc = 'DB history' },
  },
}
