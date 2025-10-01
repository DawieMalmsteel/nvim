return {
  'folke/sidekick.nvim',
  opts = {
    -- add any options here
    cli = {
      mux = {
        backend = 'tmux',
        enabled = true,
      },
    },
  },
  keys = {
    {
      '<tab>',
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require('sidekick').nes_jump_or_apply() then
          return '<Tab>' -- fallback to normal tab
        end
      end,
      expr = true,
      desc = 'Goto/Apply Next Edit Suggestion',
    },
    {
      '<c-.>',
      function()
        require('sidekick.cli').focus()
      end,
      mode = { 'n', 'x', 'i', 't' },
      desc = 'Sidekick Switch Focus',
    },
    {
      '<leader>Aa',
      function()
        require('sidekick.cli').toggle()
      end,
      desc = 'Sidekick Toggle CLI',
      mode = { 'n', 'v' },
    },
    {
      '<leader>As',
      function()
        require('sidekick.cli').select()
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
      end,
      desc = 'Sidekick Select CLI',
      mode = { 'n', 'v' },
    },
    {
      '<leader>Ac',
      function()
        require('sidekick.cli').toggle { name = 'copilot', focus = true }
      end,
      desc = 'Sidekick Copilot Toggle',
      mode = { 'n', 'v' },
    },
    {
      '<leader>Ag',
      function()
        require('sidekick.cli').toggle { name = 'gemini', focus = true }
      end,
      desc = 'Sidekick Gemini Toggle',
      mode = { 'n', 'v' },
    },
    {
      '<leader>Ap',
      function()
        require('sidekick.cli').prompt()
      end,
      desc = 'Sidekick Ask Prompt',
      mode = { 'n', 'v' },
    },
  },
}
