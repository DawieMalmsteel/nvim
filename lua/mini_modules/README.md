# mini.nvim modules

Per-module configs, loaded contextually by `lua/plugins/mini.lua` through the
`config.mini_loader` loader:

- on `VeryLazy`: `icons`, `bufremove`, `misc`, `statusline`, `hipatterns`
- on first buffer read: `ai`, `surround`, `bracketed`, `cursorword`
- on first buffer inside a git repo: `diff`, `git`
- on first `InsertEnter`: `snippets`

Mini is kept for small editing/UI helpers only. Navigation/search/explorer moved to Snacks.