# 👤 (cb81c6f2-15cc-4641-babb-e35c1358d6bf) ───

how to go back last jump in nvim?

#   (22e9f356-6fc2-4498-ba57-3e5932aba722) ───

Use Neovim’s jump list:

- Go back to previous jump: **`Ctrl-o`**
- Go forward again: **`Ctrl-i`** (or `<Tab>` in some terminals)

Useful check:
- Show jump list: **`:jumps`**

So for “last jump,” press **`Ctrl-o`** in Normal mode.

# 👤 (180022ad-4dea-45d7-a3ab-f05bfc78c4a4) ───

i remember nvim has g; or g, to go to last jump and previous jump is that true

#   (bab99b5c-0a80-424c-869a-ee30de614e8d) ───

Yes! But those are specifically for the **change list** (not jump list):

- **`g;`** — go to previous change location
- **`g,`** — go to newer change location

To view the change list: **`:changes`**

So:
- **Jump list** (`Ctrl-o` / `Ctrl-i`) — tracks cursor jumps (searches, `gg`, `G`, etc.)
- **Change list** (`g;` / `g,`) — tracks where edits were made

