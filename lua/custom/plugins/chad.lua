return {
  {
    'nvzone/showkeys',
    cmd = 'ShowkeysToggle',
    opts = {
      show_count = true,

      -- bottom-left, bottom-right, bottom-center, top-left, top-right, top-center
      -- position = 'bottom-right',
    },
  },
  {
    'nvzone/typr',
    dependencies = 'nvzone/volt',
    opts = {},
    cmd = { 'Typr', 'TyprStats' },
  },
}
