Neovim cấu hình (Tiếng Việt)

Mục tiêu

- Cấu hình Neovim dùng `vim.pack` native làm trình quản lý plugin.
- Hỗ trợ LSP, completion, format, Treesitter, which-key, TODO và UI/plugin cá nhân.

Yêu cầu

- Neovim >= 0.12.
- `git` để `vim.pack` clone/update plugin.
- Linux: nên có `curl`, `unzip`, build tools, `ripgrep`.
- Nerd Font để icon hiển thị đúng.

Khởi động lần đầu

- Mở Neovim: `nvim`
- `vim.pack` sẽ cài plugin theo `lua/config/pack.lua`.
- Cập nhật plugin: `:lua vim.pack.update()`.

Cấu trúc chính

- `init.lua` - entrypoint.
- `lua/config/options.lua` - option lõi.
- `lua/config/autocmds.lua` - autocmd chung.
- `lua/config/pack.lua` - cài plugin bằng `vim.pack`, chạy setup/keymap từ các module plugin hiện có.
- `lua/config/lsp_keymaps.lua` - keymap khi LSP attach.
- `lua/config/plugins/` - cấu hình plugin lõi.
- `lua/custom/plugins/` - cấu hình plugin cá nhân.
- `lua/custom/keymaps/` - keymap cá nhân.

Ghi chú migration

- Không còn bootstrap `lazy.nvim`.
- Các file plugin cũ vẫn giữ shape gần lazy spec để tránh rewrite lớn; `config.pack` đọc chúng và chạy eager setup.
- Plugin cần build được xử lý bằng hook `PackChanged` hoặc lệnh build thủ công.

Lệnh hữu ích

- Plugin update: `:lua vim.pack.update()`
- Xem plugin: `:lua =vim.pack.get(nil, { info = false })`
- Mason: `:Mason`
- LSP: `:LspInfo` hoặc `:checkhealth vim.lsp`
- Treesitter parser: `:TSUpdate`

Khắc phục sự cố

- Plugin không cài: kiểm tra mạng/git, rồi mở lại `nvim` hoặc chạy `:lua vim.pack.update()`.
- LSP không hoạt động: kiểm tra `:Mason` và `:checkhealth vim.lsp`.
- Treesitter lỗi build: cài compiler/toolchain rồi chạy `:TSUpdate`.
- Icon lỗi: cài Nerd Font và set terminal dùng font đó.

Reset plugin data

- Xóa plugin do `vim.pack` quản lý: `rm -rf ~/.local/share/nvim/site/pack/core/opt`
- Sau đó mở lại `nvim` để cài lại từ `nvim-pack-lock.json`.
