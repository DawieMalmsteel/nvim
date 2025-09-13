Neovim cấu hình (Tiếng Việt)

Mục tiêu
- Cấu hình Neovim nhanh, tối giản, dùng lazy.nvim làm trình quản lý plugin.
- Hỗ trợ LSP, hoàn thành mã, format, Treesitter, which-key, TODO, và thông báo tiến trình LSP.

Yêu cầu
- Neovim >= 0.10 (khuyến nghị 0.11+).
- Linux: đã cài git, curl, unzip, build tools.
  - Ubuntu/Debian:
    sudo apt update && sudo apt install -y git curl unzip build-essential ripgrep
- Khuyến nghị dùng Nerd Font (để icon hiển thị đúng).
- Nếu dùng Neovide: nên cài font “Monolisa Variable” hoặc đổi guifont.

Khởi động lần đầu
- Mở Neovim tại thư mục này: nvim
- lazy.nvim sẽ tự bootstrap và cài plugin.
- Sau khi xong: :Lazy sync, :TSUpdate

Cấu trúc thư mục
- lua/core/
  - plugins/            - Cấu hình từng plugin
  - autocmds.lua        - Tự động lệnh (yank highlight, thông báo tiến trình LSP)
  - lazy.lua            - Bootstrap và cấu hình lazy.nvim
  - lsp_keymaps.lua     - Keymap cho LSP (đổi tên, code action, inlay hints)
  - misc.lua            - Thiết lập linh tinh (Treesitter, termguicolors, python host, shell)
  - neovide.lua         - Tùy chỉnh khi chạy Neovim trong Neovide GUI
  - options.lua         - Tùy chọn lõi (số dòng, fold, clipboard, split, v.v.)

Giải thích từng file

1) lua/core/options.lua
- mapleader và maplocalleader là khoảng trắng.
- Số dòng: number + relativenumber.
- cmdheight = 0 (ẩn dòng lệnh khi rảnh).
- foldmethod/expr dùng Treesitter, foldlevel 99 (mở rộng).
- Clipboard = unnamedplus (đặt trễ bằng vim.schedule để ổn định).
- Thụt lề 4 khoảng; expandtab bật.
- Undo file bật (giữ lịch sử).
- Tìm kiếm: ignorecase + smartcase.
- signcolumn = yes.
- updatetime = 250, timeoutlen = 300 (cân bằng phản hồi và trải nghiệm).
- splitright/splitbelow = true.
- list tắt; inccommand = split (xem trước thay thế).
- cursorline bật; scrolloff = 8; confirm = true.

2) lua/core/neovide.lua
- Chỉ áp dụng khi chạy trong Neovide (vim.g.neovide).
- Bật IME, opacity = 0.8, padding = 0.
- guifont = 'Monolisa Variable-Script:h14' (đổi nếu không có font).
- Toàn màn hình bật.
- Gợi ý: đổi vim.o.guifont cho phù hợp hệ thống.

3) lua/core/misc.lua
- Đăng ký Treesitter cho filetype 'minifiles' dùng ngôn ngữ 'markdown'.
- Bật termguicolors (màu 24-bit).
- python3_host_prog = /usr/bin/python3 (đồng bộ với hệ Linux).
- shell = bash (phục vụ tích hợp markdown-org).

4) lua/core/lsp_keymaps.lua
- Hàm apply(buf, client) gắn keymap theo buffer khi LSP attach:
  - grn hoặc <leader>cR: đổi tên (rename).
  - gra hoặc <leader>ca: code action (normal/visual).
  - <leader>th: bật/tắt Inlay Hints nếu server hỗ trợ.
- Có kiểm tra hỗ trợ method theo phiên bản Neovim.

5) lua/core/lazy.lua
- Bootstrap lazy.nvim (clone nếu chưa có).
- require('lazy').setup với:
  - { import = 'core.plugins' } – nạp toàn bộ plugin trong lua/core/plugins/
  - require 'kickstart.plugins.debug' – tùy chọn debug (nếu có)
  - { import = 'custom.plugins' } – điểm mở rộng cho người dùng (tạo lua/custom/plugins nếu muốn).
- UI icon tùy Nerd Font.

6) lua/core/autocmds.lua
- TextYankPost: highlight vùng vừa yank (copy).
- LspProgress: hiển thị tiến trình LSP qua vim.notify với spinner.
  - Gom nhóm theo client, tự động cập nhật và kết thúc khi done.

7) lua/core/plugins (mỗi file một plugin/chức năng)

- completion.lua
  - saghen/blink.cmp: plugin hoàn thành mã thế hệ mới.
  - Phụ thuộc: blink-cmp-copilot (Copilot source), friendly-snippets, lazydev.nvim.
  - Keymap preset 'enter'; <C-y> chọn và chấp nhận.
  - Hiển thị documentation tự động; ghost_text dựa vào vim.g.ai_cmp.
  - Nguồn: lsp, path, snippets, buffer, lazydev, copilot.
  - Tùy biến biểu tượng loại gợi ý (kể cả 'Copilot').
  - Signature help bật.

- formatting.lua
  - stevearc/conform.nvim: định dạng tự động trước khi lưu (BufWritePre).
  - <leader>uf: format thủ công (async, fallback LSP nếu cần).
  - Tắt format-on-save với c/cpp; timeout 500ms.
  - Lua dùng stylua.

- lazydev.lua
  - folke/lazydev.nvim: cải thiện trải nghiệm Lua/LuaLS.
  - Chỉ áp dụng cho filetype lua; thêm thư viện luv (vim.uv).

- lsp.lua
  - neovim/nvim-lspconfig + mason + mason-lspconfig + mason-tool-installer + blink.cmp.
  - Bật inlay_hints toàn cục.
  - LspAttach: gắn keymap (từ lsp_keymaps.lua) và bật Document Highlight nếu server hỗ trợ.
  - Cấu hình chẩn đoán: sắp xếp theo mức độ, float border rounded, underline chỉ ERROR, signs có icon khi có Nerd Font, virtual_text gọn.
  - Khả năng client: lấy từ blink.cmp (tự điền capabilities).
  - Server cài sẵn:
    - gopls (tối ưu hóa gợi ý, inlay hints, phân tích, semantic tokens, gofumpt,…)
    - intelephense (PHP)
    - basedpyright (Python, pythonPath tự phát hiện): type checking basic, auto import, nới lỏng vài cảnh báo.
    - fsautocomplete (F#)
    - rust_analyzer
    - vtsls (TS/JS) với inlay hints, complete function calls, fuzzy matching server-side.
    - tailwindcss (root từ .git)
    - cssls, html, marksman (Markdown), lua_ls (Lua, callSnippet = Replace).
  - Mason Tool Installer sẽ đảm bảo cài đặt danh sách trên + stylua.
  - Lệnh hữu ích: :Mason, :LspInfo

- todo.lua
  - folke/todo-comments.nvim: tô sáng TODO/FIXME/…; tắt signs (gọn hơn).
  - Tìm TODO: :TodoTelescope (nếu dùng telescope) hoặc :TodoQuickFix.

- treesitter.lua
  - nvim-treesitter: highlight, indent, và textobjects di chuyển.
  - ensure_installed: bash, c, diff, html, lua, luadoc, markdown, markdown_inline, query, vim, vimdoc, ocaml, c_sharp, sql.
  - highlight bật; indent bật (trừ ruby).
  - textobjects.move: phím tắt điều hướng cấu trúc
    - ]f/[f: function start; ]F/[F: function end
    - ]l/[l: class start; ]L/[L: class end
    - ]a/[a: parameter start; ]A/[A: parameter end
  - Lưu ý: để textobjects hoạt động, nên cài nvim-treesitter-textobjects.
  - Lệnh: :TSUpdate

- whichkey.lua
  - folke/which-key.nvim: gợi ý phím tắt theo preset “helix”, delay = 0.
  - Icon phím phụ thuộc Nerd Font; map fallback khi không có.

Sử dụng nhanh (cheatsheet)
- LSP:
  - Đổi tên: grn hoặc <leader>cR
  - Code Action: gra hoặc <leader>ca (normal/visual)
  - Bật/tắt Inlay Hints: <leader>th
  - Thông tin LSP: :LspInfo
- Format:
  - Tự động khi lưu (trừ c/cpp)
  - Thủ công: <leader>uf hoặc :ConformInfo
- Plugin:
  - Quản lý: :Lazy, :Lazy sync, :Lazy update
  - Công cụ LSP: :Mason
- Treesitter:
  - Cập nhật parser: :TSUpdate

Tùy biến
- Thêm plugin: tạo file mới trong lua/core/plugins/ hoặc dùng thư mục lua/custom/plugins/ (đã import trong lazy.lua).
- Đổi keymap LSP: sửa lua/core/lsp_keymaps.lua.
- Đổi tùy chọn chung: sửa lua/core/options.lua.
- Neovide: đổi font/opacity/fullscreen trong lua/core/neovide.lua.
- Python host: đổi đường dẫn trong lua/core/misc.lua nếu Python nằm nơi khác.

Khắc phục sự cố
- Thiếu icon/ký tự lạ: cài Nerd Font và set terminal dùng font đó.
- Không tự cài plugin: kiểm tra mạng, chạy :Lazy sync, xem :messages.
- Treesitter lỗi build: đảm bảo đã có compiler và toolchain (build-essential/clang), chạy :TSUpdate.
- LSP không hoạt động: kiểm tra :Mason xem server đã cài chưa, mở :LspInfo để xem client attach chưa.
- Neovide font không tồn tại: đổi vim.o.guifont trong lua/core/neovide.lua.

Gỡ cài đặt/Reset
- Xóa dữ liệu lazy: rm -rf ~/.local/share/nvim/lazy ~/.local/state/nvim/lazy
- Xóa cache Treesitter: rm -rf ~/.local/share/nvim/site/pack/packer/start/nvim-treesitter/parser

Ghi chú
- Cấu hình ưu tiên tính ổn định và hiệu năng. Một số tính năng (vd: textobjects) cần cài plugin phụ trợ tương ứng.
- Bạn có thể mở rộng mọi thứ trong thư mục lua/custom mà không đụng chạm lõi.
