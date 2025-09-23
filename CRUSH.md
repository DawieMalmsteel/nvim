# CRUSH.md for Neovim Configuration

This file outlines conventions and commands for working with this Neovim configuration.

## Build/Lint/Test Commands

- **Linting:** This project uses `stylua` for formatting Lua files.
  - To lint all Lua files: `stylua --check .`
  - To format all Lua files: `stylua .`
  - This project uses `nvim-lint` for general linting, configured in `lua/kickstart/plugins/lint.lua`. Linting runs automatically on buffer write.

- **Tests:** There are no explicit test commands found for running unit tests. `nvim-neotest` is a dependency, suggesting a testing framework could be configured. If you add tests, integrate them with `neotest`.

## Code Style Guidelines (Lua)

- **Formatting:**
  - `column_width = 160`
  - `line_endings = "Unix"`
  - `indent_type = "Spaces"`
  - `indent_width = 2`
  - `quote_style = "AutoPreferSingle"`
  - `call_parentheses = "None"`
  - These settings are enforced by `stylua` and defined in `.stylua.toml`.

- **Imports:** Use `require 'module'` for importing modules.
- **Naming Conventions:** Follow Lua's conventional snake_case for variables and functions.
- **Error Handling:** Neovim typically uses `pcall` for protected calls to handle errors.
- **General:** Mimic existing code style and structure found throughout `lua/`.
