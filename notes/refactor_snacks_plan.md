# Refactor plan: Snacks-first Neovim config

Goal: make Snacks the single navigation/search/explorer layer.

## Phase 1 - Snacks first

- Enable Snacks picker, explorer, input, notifier, terminal, scratch, lazygit, statuscolumn, words, zen.
- Move Snacks-related keymaps into `lua/plugins/snacks.lua`.
- Replace Mini Pick/Mini Files keymaps with Snacks equivalents.
- Stop loading Mini Pick/Mini Files as the default navigation layer.

## Phase 2 - Delete clutter

Done:

- Flattened keymaps into `lua/keymaps.lua`.
- Removed old split keymap tree.
- Removed disabled/temp plugin experiments.
- Moved Mini config to flat `lua/mini_modules/`.
- Moved plugin specs to single `lua/plugins/` directory.

Left:

- Rename files whose name does not match their plugin.
- Update root README if needed.

## Phase 3 - Structure cleanup

Optional later: group `lua/plugins/*.lua` into `coding.lua`, `ui.lua`, `tools.lua`, `langs.lua`, `ai.lua`.
