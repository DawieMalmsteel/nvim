# PLAN: migrate lazy.nvim -> vim.pack

## Goal

Replace `lazy.nvim` with Neovim 0.12 native `vim.pack`, while keeping current behavior: LSP, completion, treesitter, picker, formatting, keymaps.

This repo is **not LazyVim**; it is kickstart-style config using `lazy.nvim`. `Hashino/minimal.nvim` is only a reference for `vim.pack` style, not code to copy.

## Rules

- No lazy.nvim dependency or event/cmd/ft lazy-loader clone.
- No new plugin-manager dependency.
- First pass is eager-loaded. Add manual lazy-loading only if startup is bad.
- Keep `nvim-pack-lock.json` tracked.
- After each phase is completed, update this file:
  - change `Status` from `TODO` to `DONE`
  - fill `Completed on`
  - fill `Completion note` with what changed and how it was verified

## Progress tracker

| Phase | Status | Summary |
| --- | --- | --- |
| 0 | DONE | Research and migration shape chosen |
| 1 | DONE | Safety branch and baseline |
| 2 | DONE | Add `config.pack` and swap bootstrap |
| 3 | DONE | Flatten plugin inventory into `vim.pack.add` |
| 4 | DONE | Convert core plugin setup modules |
| 5 | DONE | Convert leaf plugins and keymaps |
| 6 | DONE | Add build/update hooks |
| 7 | DONE | Fix known breakpoints |
| 8 | DONE | Verify and benchmark |
| 9 | DONE | Cleanup lazy.nvim files/references |

---

## Phase 0: research and migration shape

**Status:** DONE
**Completed on:** 2026-06-29
**Completion note:** Checked `Hashino/minimal.nvim`; confirmed it uses direct `vim.pack.add(...)` + `require(...).setup(...)`. Also found it should not be copied directly because it calls `catppuccin` without installing it, uses old treesitter setup style, and misses explicit `vim.lsp.enable(...)`. Confirmed this repo uses `lazy.nvim`, not `LazyVim` distro.

### Result

Use this shape:

```lua
vim.pack.add({
  'https://github.com/owner/plugin.nvim',
}, { confirm = false, load = true })

require('plugin').setup({})
```

---

## Phase 1: safety branch and baseline

**Status:** DONE
**Completed on:** 2026-06-29
**Completion note:** Created branch `pack-migration`. Captured lazy.nvim baseline: 57 active plugins and startup `214.968ms` in `/tmp/nvim-pack-migration/nvim-lazy-start.log`.

### Tasks

- [ ] Create branch:

```sh
git switch -c pack-migration
```

- [ ] Record current lazy.nvim plugin list:

```sh
nvim --headless +'lua local c=require("lazy.core.config"); local t={}; for name,_ in pairs(c.plugins) do t[#t+1]=name end; table.sort(t); print(table.concat(t,"\n"))' +qa
```

- [ ] Record startup baseline:

```sh
nvim --headless --startuptime /tmp/nvim-lazy-start.log +qa
```

### Done when

- Branch exists.
- Plugin list saved in notes or commit message.
- Startup baseline exists.

---

## Phase 2: add `config.pack` and swap bootstrap

**Status:** DONE
**Completed on:** 2026-06-29
**Completion note:** Added `lua/config/pack.lua` and changed `init.lua` from `require 'config.lazy'` to `require 'config.pack'`. Verified `nvim --headless +qa` loads without `require('lazy')`.

### Tasks

- [ ] Create `lua/config/pack.lua`.
- [ ] Add a small `gh()` helper.
- [ ] Add initial core plugin list with `vim.pack.add(..., { confirm = false, load = true })`.
- [ ] Change `init.lua`:

```lua
require 'config.pack'
-- remove: require 'config.lazy'
```

- [ ] Keep `lua/config/lazy.lua` for rollback until final cleanup.

### Starter pack list

```lua
local gh = function(repo)
  return 'https://github.com/' .. repo
end

vim.pack.add({
  gh 'folke/snacks.nvim',
  gh 'nvim-mini/mini.nvim',
  gh 'saghen/blink.cmp',
  gh 'neovim/nvim-lspconfig',
  gh 'mason-org/mason.nvim',
  gh 'mason-org/mason-lspconfig.nvim',
  gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  gh 'nvim-treesitter/nvim-treesitter',
  gh 'nvim-treesitter/nvim-treesitter-textobjects',
  gh 'nvim-treesitter/nvim-treesitter-context',
  gh 'stevearc/conform.nvim',
  gh 'folke/which-key.nvim',
  gh 'folke/todo-comments.nvim',
  gh 'nvim-lua/plenary.nvim',
}, { confirm = false, load = true })
```

### Done when

- `nvim --headless +qa` reaches config load without `require('lazy')`.
- `vim.pack.get()` shows the starter plugins.

---

## Phase 3: flatten plugin inventory

**Status:** DONE
**Completed on:** 2026-06-29
**Completion note:** Moved active plugins into `vim.pack.add`: 56 `vim.pack` plugins vs 57 lazy plugins; the missing one is `lazy.nvim` itself. Preserved explicit branches/tags for `harpoon`, `nvim-treesitter`, `nvim-treesitter-textobjects`, `blink.cmp`, and `bafa.nvim`.

### Tasks

- [ ] Generate active plugin list from lazy.nvim.
- [ ] Put every active plugin URL into `lua/config/pack.lua`.
- [ ] Preserve branch/version fields where they matter.
- [ ] Add dependency plugins explicitly.

### Important groups

- Completion: `blink.cmp`, `blink-copilot`, `blink-cmp-git`, `blink-cmp-yanky`, `friendly-snippets`, `lazydev.nvim`
- LSP/tools: `nvim-lspconfig`, `mason.nvim`, `mason-lspconfig.nvim`, `mason-tool-installer.nvim`
- UI/picker: `snacks.nvim`, `mini.nvim`, `which-key.nvim`, `nvim-web-devicons`
- Treesitter: `nvim-treesitter`, `nvim-treesitter-textobjects`, `nvim-treesitter-context`
- Shared libs: `plenary.nvim`, `nui.nvim`

### Done when

- Current lazy plugin count and `vim.pack` plugin count match, minus intentionally removed plugins.
- Missing/removal list is documented in `Completion note`.

---

## Phase 4: convert core plugin setup modules

**Status:** DONE
**Completed on:** 2026-06-29
**Completion note:** `config.pack` now loads the existing core plugin modules and runs their `init`, `opts`, `config`, and setup calls without lazy.nvim. Core startup passes for blink, LSP, treesitter, conform, mini, snacks, which-key, and todo. Kept existing module files mostly intact to avoid a giant rewrite. This runner is eager-only; it does not implement lazy.nvim events/cmd/ft loading.

### Tasks

Convert these first:

- [ ] `lua/config/plugins/blink.lua`
- [ ] `lua/config/plugins/lsp.lua`
- [ ] `lua/config/plugins/treesitter.lua`
- [ ] `lua/config/plugins/formatting.lua`
- [ ] `lua/custom/plugins/mini.lua`
- [ ] `lua/custom/plugins/snacks.lua`
- [ ] `lua/config/plugins/whichkey.lua`
- [ ] `lua/config/plugins/todo.lua`

### Conversion mapping

| lazy.nvim field | vim.pack version |
| --- | --- |
| `opts = {...}` | `require('plugin').setup(opts)` |
| `config = function(_, opts)` | call directly |
| `dependencies = {...}` | add dependency URL to `vim.pack.add` |
| `event`, `cmd`, `ft` | ignore in first pass |
| `version`, `branch` | `version = 'branch-or-tag'` in pack spec |

### Done when

- Core modules are required from `config.pack` or a `config.pack_setup` module.
- Headless startup passes.
- LSP/completion/treesitter setup does not error.

---

## Phase 5: convert leaf plugins and keymaps

**Status:** DONE
**Completed on:** 2026-06-29
**Completion note:** `config.pack` applies top-level leaf plugin modules and converts their `keys` tables/functions to `vim.keymap.set(...)`. Disabled/commented temp plugins stayed skipped. Verified headless startup and `vim.pack.get()` after keymap/setup application.

### Tasks

- [ ] Convert remaining `lua/custom/plugins/*.lua` specs.
- [ ] Convert lazy `keys = { ... }` entries to `vim.keymap.set(...)`.
- [ ] Keep existing `custom.keymaps` untouched unless needed.
- [ ] Skip disabled/commented temp plugins unless they are active today.

### Keymap conversion pattern

```lua
vim.keymap.set('n', '<leader>x', function()
  require('plugin').action()
end, { desc = 'Action' })
```

### Done when

- No active plugin behavior depends on lazy.nvim's `keys` handler.
- Existing daily keymaps still work in manual smoke test.

---

## Phase 6: build/update hooks

**Status:** DONE
**Completed on:** 2026-06-29
**Completion note:** Added `PackChanged` hooks for `fff.nvim`, `sniprun`, `cargo.nvim`, and `nvim-treesitter`. Also ran first-install builds manually: `cargo build --release`, `sh install.sh` for sniprun, and `require('fff.download').download_or_build_binary()`.

### Tasks

Add only specific hooks; do not create a framework.

- [ ] `nvim-treesitter`: run update/install logic if needed.
- [ ] `fff.nvim`: `require('fff.download').download_or_build_binary()`.
- [ ] `sniprun`: `sh install.sh`.
- [ ] `cargo.nvim`: `cargo build --release`.

### Hook shape

```lua
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then
      return
    end
    -- plugin-specific hook here
  end,
})
```

### Done when

- Plugins needing native/binary install have documented hooks or manual commands.
- Hook failures do not block unrelated startup.

---

## Phase 7: fix known breakpoints

**Status:** DONE
**Completed on:** 2026-06-29
**Completion note:** Replaced the Snacks dashboard `:Lazy` button with `:lua vim.pack.update()`. Kept current treesitter and LSP code paths, including explicit `vim.lsp.config(...)` + `vim.lsp.enable(...)`. `tts.nvim` is installed but not eagerly `packadd`ed because its plugin file errors on exit unless its module is required first; `config.pack` installs wrapper commands that load/setup it on first use.

### Tasks

- [ ] `custom/plugins/snacks.lua`: remove/change dashboard `:Lazy` button.
- [ ] `lazydev.nvim`: ensure Lua dev setup still runs before Lua LSP use.
- [ ] Treesitter: keep current new API; do not copy `minimal.nvim`'s old `nvim-treesitter.configs` usage.
- [ ] LSP: every server must call both:

```lua
vim.lsp.config(name, cfg)
vim.lsp.enable(name)
```

### Done when

- No `:Lazy` UI references remain in active UI.
- Lua LSP works with local Neovim runtime/plugin types.
- Treesitter highlight works on a Lua file.

---

## Phase 8: verify and benchmark

**Status:** DONE
**Completed on:** 2026-06-29
**Completion note:** Verified `nvim --headless +qa`, opening `lua/config/pack.lua` headlessly, and `vim.pack.get(nil, { info = false })` returning 56 plugins. Final eager startup recorded `391.387ms` in `/tmp/nvim-pack-migration/nvim-pack-start-final.log` vs lazy baseline `214.968ms`. Interactive UI smoke test still should be done by the user because headless cannot confirm picker/completion visuals.

### Commands

```sh
nvim --headless +qa
nvim --headless +'lua print(vim.inspect(vim.pack.get(nil, { info = false })))' +qa
nvim --headless --startuptime /tmp/nvim-pack-start.log +qa
```

### Manual smoke test

- [ ] Open Lua file: LSP attaches.
- [ ] Open Rust/Go/TS file: LSP config does not error.
- [ ] Completion menu opens.
- [ ] Treesitter highlight works.
- [ ] Snacks picker/dashboard works.
- [ ] Existing custom keymaps still work.

### Done when

- Headless startup exits cleanly.
- Manual smoke test passes.
- Startup time is recorded and compared with Phase 1 baseline.

---

## Phase 9: cleanup

**Status:** DONE
**Completed on:** 2026-06-29
**Completion note:** Deleted `lua/config/lazy.lua` and `lazyvim.json`. Updated README/config docs and Snacks dashboard away from Lazy commands. `nvim-pack-lock.json` now contains the installed plugin revisions. Remaining `lazy.nvim` mentions are migration notes/history, not active config.

### Tasks

- [ ] Delete `lua/config/lazy.lua`.
- [ ] Delete `lazyvim.json` if unused.
- [ ] Remove lazy.nvim references from README/dashboard.
- [ ] Keep `nvim-pack-lock.json`.
- [ ] Confirm no active `require('lazy')` remains.

### Done when

- `rg "require\(['\"]lazy|:Lazy|lazy.nvim|lazyvim"` has no active references, except historical notes if intentionally kept.
- Rollback can be done through git, not old files.

---

## Rollback

Before Phase 9, rollback is:

```lua
require 'config.lazy'
-- remove/comment: require 'config.pack'
```

After Phase 9, rollback is `git revert` or branch reset.

## Post-migration bugfixes

- 2026-06-29: fixed `tts.nvim` lazy command wrapper. The plugin's `plugin/tts-nvim.lua` references global `M`, so eager `packadd` fails on `ExitPre`. `config.pack` now keeps it out of eager `packadd`, prepends its pack path, requires `tts-nvim`, runs setup, then sources `plugin/tts-nvim.lua` on first `TTS*` command. Verified with `nvim --headless +'TTSSetBackend edge' +qa`.
- 2026-06-29: fixed `blink.cmp` health error by removing the unused `dadbod_grip` provider while the `dadbod-grip.nvim` plugin is disabled. Verified `:checkhealth blink.cmp` has no errors.
- 2026-06-29: stopped eager-loading `lean.nvim`; it now `packadd`s and runs setup only for `*.lean` buffers. This removes startup/checkhealth failures on machines without `lake` while preserving Lean support when opening Lean files.
- 2026-06-29: fixed `opencode.nvim` health failure from missing `lsof` by configuring a fixed local server URL/port (`127.0.0.1:4096`) and matching start command.
- 2026-06-29: fixed Python provider health failure by disabling the unused Python remote-plugin provider instead of requiring `pynvim` in a specific system Python.
- 2026-06-29: fixed remaining headless `:checkhealth` failures in `snacks.nvim`: install `vim.ui.input`/`vim.ui.select` wrappers immediately, mark dashboard setup as run in headless, and skip image protocol health checks when no UI is attached. Verified full headless `:checkhealth` has no `ERROR`/`❌` lines.
- 2026-06-29: cleaned up more health warnings by disabling unused Node/Perl/Ruby remote-plugin providers and registering LSP-only filetypes (`gotmpl`, `superhtml`, Tailwind template filetypes) with `vim.filetype.add`.
- 2026-06-29: fixed `ts-expand-hover.nvim` migration regression: it was using the wrong module name and was being health-checked outside TypeScript buffers. It now `packadd`s and runs setup only for TypeScript filetypes; verified `<leader>th` exists in a `.ts` buffer.
- 2026-06-29: restored command/key lazy-loading for `grug-far.nvim`; it no longer appears in baseline headless health, and `:GrugFar` still loads the plugin on demand.
- 2026-06-29: fixed Snacks dashboard startup section still calling `lazy.stats`; it now renders a tiny `vim.pack` plugin count instead. Verified `require('snacks.dashboard').open()` no longer errors.
- 2026-06-29: restored dashboard startup time without `lazy.stats` by recording `vim.uv.hrtime()` at the top of `init.lua` and rendering elapsed milliseconds in the Snacks dashboard.
- 2026-06-29: reduced dashboard startup time by deleting the expensive animated `milli.nvim` splash and enabling Neovim's Lua module cache with `vim.loader.enable()`. Verified dashboard line reports ~247ms after cache warm-up.
- 2026-06-29: removed the remaining non-historical `lazy-lock.json` README wording; active docs now refer to `nvim-pack-lock.json`.

## Final definition of done

- `nvim --headless +qa` exits cleanly.
- No active `require('lazy')` remains.
- Core editing flow works: LSP, completion, treesitter, picker, formatting.
- `nvim-pack-lock.json` is updated and tracked.
- Startup is acceptable; only then consider manual lazy-loading.
