local pack = require 'custom.pack'

-- [[ inline-fold.nvim ]]
pack.add { pack.gh 'malbertzard/inline-fold.nvim' }

require('inline-fold').setup {
  defaultPlaceholder = '…',
  queries = {

    -- Some examples you can use
    html = {
      { pattern = 'class="([^"]*)"', placeholder = '@' }, -- classes in html
      { pattern = 'href="(.-)"' }, -- hrefs in html
      { pattern = 'src="(.-)"' }, -- HTML img src attribute
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
