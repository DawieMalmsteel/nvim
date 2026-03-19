return {
  'stevearc/oil.nvim',
  opts = {
    use_default_keymaps = false,
    keymaps = {
      ['<tab>'] = { 'actions.parent', mode = 'n' },
      ['g?'] = { 'actions.show_help', mode = 'n' },
      ['<CR>'] = 'actions.select',
      -- ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
      ['<C-l>'] = { 'actions.select', mode = 'n' },
      ['L'] = { 'actions.select', mode = 'n' },
      ['<C-h>'] = { 'actions.parent', mode = 'n' },
      ['H'] = { 'actions.parent', mode = 'n' },
      ['<C-r>'] = 'actions.refresh',
      ['<C-p>'] = 'actions.preview',
      ['<C-t>'] = { 'actions.select', opts = { tab = true } },
      ['<C-c>'] = { 'actions.close', mode = 'n' },
      ['q'] = { 'actions.close', mode = 'n' },
      ['-'] = { 'actions.parent', mode = 'n' },
      ['_'] = { 'actions.open_cwd', mode = 'n' },
      ['`'] = { 'actions.cd', mode = 'n' },
      ['g~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
      ['gs'] = { 'actions.change_sort', mode = 'n' },
      ['gx'] = 'actions.open_external',
      ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
      ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
    },
    view_options = {
      show_hidden = true,
    },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    float = {
      -- Padding around the floating window
      padding = 1,
      -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      max_width = 0.8,
      max_height = 0.8,
      border = 'solid', -- Border style. Can be 'none', 'single', 'double', 'rounded', 'solid', or 'shadow'.
      win_options = {
        winblend = 1,
      },
      -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
      get_win_title = nil,
      -- preview_split: Split direction: "auto", "left", "right", "above", "below".
      preview_split = 'right',
      -- This is the config that will be passed to nvim_open_win.
      -- Change values here to customize the layout
      override = function(conf)
        return conf
      end,
    },
  },
  lazy = false,
  keys = {
    { '<leader>e', "<cmd>lua require('oil').open_float()<CR>", desc = 'Oil', mode = { 'n' } },
  },
}
