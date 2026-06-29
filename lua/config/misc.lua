-- Misc settings & GUI specific tweaks

vim.treesitter.language.register('markdown', 'minifiles')
vim.opt.termguicolors = true
vim.filetype.add {
  extension = {
    ['astro-markdown'] = 'astro-markdown',
    ['aspnetcorerazor'] = 'aspnetcorerazor',
    edge = 'edge',
    ejs = 'ejs',
    erb = 'erb',
    gohtml = 'gohtml',
    gohtmltmpl = 'gohtmltmpl',
    gotmpl = 'gotmpl',
    hbs = 'hbs',
    ['html-eex'] = 'html-eex',
    jade = 'jade',
    leaf = 'leaf',
    mdx = 'mdx',
    njk = 'njk',
    nunjucks = 'nunjucks',
    postcss = 'postcss',
    reason = 'reason',
    slim = 'slim',
    sugarss = 'sugarss',
    superhtml = 'superhtml',
  },
  pattern = {
    ['.*%.django%.html'] = 'django-html',
  },
}
-- ponytail: no remote plugins; disable providers instead of installing unused hosts.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.o.shell = 'bash'
vim.o.swapfile = false
