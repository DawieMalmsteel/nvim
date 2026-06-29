# Neovim config structure

Runtime entry:

- `init.lua` loads core config, plugins, keymaps, optional CLI helpers.
- `lua/config/` contains core Neovim settings only.
- `lua/plugins/` contains all lazy.nvim plugin specs.
- `lua/keymaps.lua` contains global keymaps not owned by a plugin.
- `lua/mini_modules/` contains the remaining mini.nvim helper modules.

Snacks is the main navigation/search/explorer layer. Mini is kept for small editing/UI helpers.
