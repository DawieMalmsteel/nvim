# nvim config

Personal Neovim config, Snacks-first.

## Structure

```text
init.lua
lua/
  config/        core options, autocmds, lazy bootstrap
  plugins/       all lazy.nvim plugin specs
  mini_modules/  remaining mini.nvim helper setup
  keymaps.lua    global keymaps
  cli.lua        optional CLI helpers
```

## Main choices

- Snacks: picker, explorer, terminal, scratch, notifier, zen.
- Mini: small editing/UI helpers only.
- lazy.nvim: plugin manager.

## Test

```sh
XDG_CONFIG_HOME=$PWD/.. nvim --headless '+lua print("nvim config ok")' '+qa'
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
