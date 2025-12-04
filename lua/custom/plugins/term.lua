return {
  {
    'nvzone/showkeys',
    cmd = 'ShowkeysToggle',
    opts = {
      show_count = false,
      -- bottom-left, bottom-right, bottom-center, top-left, top-right, top-center
      position = 'bottom-right',
    },
  },
  {
    'nvzone/floaterm',
    dependencies = 'nvzone/volt',
    opts = {
      size = { h = 80, w = 95 },
      border = true,
      terminals = {
        { name = 'Terminal', cmd = 'fish' },
      },
    },
    cmd = 'FloatermToggle',
  },
}
