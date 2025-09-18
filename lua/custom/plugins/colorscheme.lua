return {
  -- {
  --   'polirritmico/monokai-nightasty.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     dark_style_background = 'transparent',
  --     light_style_background = 'transparent',
  --     hl_styles = {
  --       floats = 'transparent',
  --       sidebars = 'transparent',
  --     },
  --     markdown_header_marks = true,
  --   },
  -- },
  {
    'tiagovla/tokyodark.nvim',
    lazy = false,
    opts = {
      transparent_background = true,
    },
    config = function(_, opts)
      require('tokyodark').setup(opts) -- calling setup is optional
      -- vim.cmd [[colorscheme tokyodark]]
    end,
  },
  {
    'AlexvZyl/nordic.nvim',
    config = function()
      require('nordic').setup {
        transparent = {
          bg = true,
          float = true,
        },
      }

      vim.cmd.colorscheme 'nordic'
    end,
  },
}
