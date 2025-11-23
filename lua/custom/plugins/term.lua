return {
  {
    'nvzone/floaterm',
    dependencies = 'nvzone/volt',
    opts = {
      border = true,
      terminals = {
        { name = 'Terminal', cmd = 'fish' },
      },
    },
    cmd = 'FloatermToggle',
  },
}
