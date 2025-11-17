# CRUSH.md for Neovim Configuration

This document outlines key aspects of this Neovim configuration to help future agents work effectively within this codebase.

## Project Type

This repository contains a Neovim configuration, primarily written in Lua. It leverages LazyVim for plugin management and provides custom utilities for development workflows.

## Code Organization and Structure

The configuration follows a modular structure:

*   **`init.lua`**: The main entry point for the Neovim configuration.
*   **`lua/config/`**: Contains general configuration settings for Neovim.
*   **`lua/custom/`**: Houses user-specific customizations.
    *   **`lua/custom/cli/`**: (Contents not explored, but likely CLI related configurations)
    *   **`lua/custom/keymaps/`**: Custom key mappings.
    *   **`lua/custom/mini/`**: (Contents not explored, but likely configurations for 'mini.nvim' plugins)
    *   **`lua/custom/plugins/`**: Configuration files for various Neovim plugins.
        *   **`lua/custom/plugins/snacks.lua`**: Example of plugin configuration using Lua tables, including custom UI/UX settings and ASCII art headers.
    *   **`lua/custom/util.lua`**: Contains helper functions and core utilities used across the configuration.

## Essential Commands and Workflows

The codebase features built-in utilities for common development tasks, accessible directly within Neovim.

### Project Bootstrapping

The `M.bootstrap_project` function (defined in `lua/custom/util.lua`) provides an interactive menu to create new projects across various technology stacks (Frontend, Backend, Fullstack, Python, Mobile). It automates the setup process by invoking tools like `npx`, `npm`, `composer`, `python3 -m venv`, `conda`, and `flutter`.

### Code Execution

The `M.run_code` function (defined in `lua/custom/util.lua`) acts as a "Code Runner". It detects the filetype of the current buffer and executes a predefined command in a Neovim terminal. It supports a wide range of languages including C, C++, C#, Go, HTML, Java, Julia, JavaScript, Lua, PHP, Perl, Python, R, Ruby, Rust, and TypeScript.

## Naming Conventions and Style Patterns

*   **Lua Tables**: Configuration and plugin options are extensively defined using Lua tables.
*   **Module Functions**: Utility functions intended for export from a module typically start with `M.`, e.g., `M.substitute`, `M.run_code`.
*   **Comments**: Comments are used to explain complex logic or provide context (e.g., `lua/custom/plugins/snacks.lua`).

## Testing Approach

No explicit testing framework or dedicated test files were identified. This is typical for personal Neovim configurations where functional testing is often done interactively by the user.

## Important Gotchas and Non-Obvious Patterns

*   **Command Placeholder Substitution**: Many internal commands (especially within `M.run_code` and `M.bootstrap_project`) utilize placeholders like `$fileBase`, `$filePath`, `$file`, `$dir`, `$altFile`, and `$project_name`. These are dynamically substituted by the `M.substitute` function in `lua/custom/util.lua` before execution. Agents should be aware of this substitution mechanism when interpreting or modifying commands.
*   **Interactive UI**: Project creation and command selection often involve interactive `vim.ui.select` and `vim.ui.input` prompts. Agents attempting to automate these workflows might need to simulate user input or bypass the interactive elements if direct execution is desired.
*   **External Tool Dependencies**: The configuration frequently invokes external command-line tools (e.g., `npx`, `npm`, `composer`, `python3`, `curl`, `git`). Ensure these tools are available in the environment where Neovim is running for the utilities to function correctly.
*   **Plugin-Specific Configurations**: Pay close attention to plugin configuration files (e.g., `lua/custom/plugins/snacks.lua`) as they can contain highly customized settings, including UI elements, keybindings, and integration with other tools (e.g., `delta` for Git diffs).
