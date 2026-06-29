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
