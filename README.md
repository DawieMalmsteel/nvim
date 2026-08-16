# nvim config

Personal Neovim config, Snacks-first.

## Structure

```text
init.lua
lua/
  config/        core options, autocmds, lazy bootstrap
  plugins/       all lazy.nvim plugin specs
  mini_modules/  remaining mini.nvim helper setup
  obsidian/      obsidian.nvim daily-activity logic
  keymaps.lua    global keymaps
```

## Main choices

- Snacks: picker, explorer, terminal, scratch, notifier, zen.
- Mini: small editing/UI helpers only.
- lazy.nvim: plugin manager.

## Test

```sh
./test.sh
```

## Mermaid rendering

`Snacks.image` renders Mermaid diagrams via an executable named `mmdc`.

A compatibility wrapper calls `mmdr` instead of the original `mmdc` (Chrome/Puppeteer-based).

Source setup script:

```text
~/.config/nvim/setup-snacks-mmdr.sh
```

Manual setup/repair:

```bash
~/.config/nvim/setup-snacks-mmdr.sh
```

Cache reset (only when needed):

```vim
:lua vim.fn.delete(vim.fn.stdpath("cache") .. "/snacks/image", "rf")
```
