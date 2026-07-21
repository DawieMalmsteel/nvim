return {
  'malbertzard/inline-fold.nvim',
  ft = { 'html', 'svelte', 'vue', 'typescriptreact', 'javascriptreact' },

  opts = {
    defaultPlaceholder = "…",
    queries = {

      -- Some examples you can use
      html = {
        { pattern = 'class="([^"]*)"', placeholder = '@' }, -- classes in html
        { pattern = 'href="(.-)"' }, -- hrefs in html
        { pattern = 'src="(.-)"' }, -- HTML img src attribute
      },
    },
  },
}
