# Thiết lập mini.nvim (lua/custom/mini)

Bộ cấu hình mini.nvim được tách theo nhóm: Editing, Navigation, UI, Productivity. Điểm vào (entry point): `lua/custom/mini/core.lua`.

Cách bật
```lua
-- Trong init.lua (hoặc nơi bootstrap)
require('custom.mini.core')
-- Muốn hiện gợi ý phím kiểu which-key: mở comment module 'custom.mini.ui.clue' trong core.lua
```

Cấu trúc thư mục
```
lua/custom/mini/
├── core.lua
├── editing/
│   ├── ai.lua            -- Textobjects Around/Inside (mini.ai)
│   ├── surround.lua      -- Thêm/xóa/đổi bao quanh (mini.surround)
│   ├── pairs.lua         -- Cặp ngoặc/quote thông minh + auto-close tag JSX/TSX/HTML
│   ├── indentscope.lua   -- Cột indent + textobject scope (mini.indentscope)
│   ├── bracketed.lua     -- Di chuyển theo nhóm [d][q][b]… (mini.bracketed)
│   └── bufremove.lua     -- Xóa buffer không phá layout (mini.bufremove)
├── nav/
│   ├── files.lua         -- File explorer + overlay Git (mini.files)
│   ├── pick.lua          -- Finder nhẹ, cửa sổ lớn giữa màn hình (mini.pick)
│   └── visits.lua        -- Ghi nhớ tần suất/lần truy cập + nhãn (mini.visits)
├── productivity/
│   ├── snippets.lua      -- Snippets (mini.snippets)
│   ├── sessions.lua      -- Phiên làm việc (mini.sessions)
│   └── git.lua           -- Tích hợp Git nhẹ (mini.git)
└── ui/
    ├── icons.lua         -- Biểu tượng (mini.icons)
    ├── cursorword.lua    -- Tô sáng từ dưới con trỏ (mini.cursorword)
    ├── tabline.lua       -- Thanh tab (mini.tabline)
    ├── hipatterns.lua    -- Tô màu hex/Tailwind (mini.hipatterns)
    ├── map.lua           -- Minimap (mini.map)
    ├── diff.lua          -- Hiển thị diff dạng sign (mini.diff)
    ├── statusline.lua    -- Thanh trạng thái tùy biến (mini.statusline)
    └── clue.lua          -- Gợi ý phím giống which-key (mini.clue)
```

Hướng dẫn dùng (tóm tắt theo nhóm)

Editing
- mini.ai (textobjects): ví dụ `va)` (chọn quanh ngoặc), `yinq` (yank inside next quote), `ci'`
- mini.surround: `saiw)` (thêm), `sd'` (xóa), `sr)'` (đổi)
- mini.pairs:
  - Cặp ngoặc/quote thông minh
  - Ở file `typescriptreact/javascriptreact/tsx/jsx/html`: gõ `>` sau `<Tag` sẽ tự chèn `</Tag>` nếu phù hợp
- mini.indentscope:
  - Textobject: `ii` (inner scope), `ai` (toàn scope)
  - Di chuyển: `[i` (đầu scope), `]i` (cuối scope)
- mini.bracketed (di chuyển theo nhóm):
  - Diagnostics: `[d` / `]d`
  - Quickfix: `[q` / `]q`
  - Buffer: `[b` / `]b`
  - Treesitter node: `[t` / `]t` (cần treesitter)
  - … xem chú thích trong `editing/bracketed.lua`
- mini.bufremove: dùng API để xóa buffer mà không thay đổi layout
```lua
-- Gợi ý map tùy chọn
vim.keymap.set('n', '<leader>bd', function() require('mini.bufremove').delete(0, true) end)
```

Navigation
- mini.files (explorer + Git):
  - Mở: `:lua require('mini.files').open()`
  - Có preview, tự vẽ dấu/trạng thái Git theo từng dòng khi đang ở repo Git
- mini.pick (finder):
  - Mặc định hay dùng:
    - Files: `:lua require('mini.pick').builtin.files()`
    - Live grep: `:lua require('mini.pick').builtin.grep_live()`
    - Buffers: `:lua require('mini.pick').builtin.buffers()`
  - Phím trong picker: Chọn `<CR>`, split `<C-s>`, vsplit `<C-v>`, tab `<C-t>`, di chuyển `<C-n>/<C-p>`, refine `<C-Space>`, toggle preview `<Tab>`, toggle info `<S-Tab>`, thoát `<Esc>`
- mini.visits (frecent + nhãn):
  - Chọn theo mức truy cập:
    - Tất cả: `<leader>vr` (recent), `<leader>vy` (frecent), `<leader>vf` (frequent)
    - Theo cwd: `<leader>vR`, `<leader>vY`, `<leader>vF`
  - Nhãn cho file hiện tại:
    - Thêm nhãn: `<leader>va` (buffer), `<leader>vda` (scoped theo cwd)
    - Xóa nhãn (picker): `<leader>vA` (global), `<leader>vdA` (cwd)
  - Chọn theo nhãn:
    - Tất cả nhãn: `<leader>vl`
    - Nhãn trong cwd: `<leader>vL`
    - Chỉ file có nhãn (all): `<leader>vP`
    - Cùng nhãn với file đang mở: `<leader>vp`
  - Duyệt theo recency (cwd): `[v` (earlier), `]v` (later)
  - Nhãn cố định “core”: thêm `<leader>vc`, xóa `<leader>vC`, chọn `<leader>v*`
  - Ghi index thủ công: `:VisitsWrite`

Productivity
- mini.sessions (lưu tại `stdpath('data')/sessions`):
  - Khôi phục mặc định: `<leader>qs`
  - Chọn & đọc: `<leader>qS`
  - Ghi global theo CWD: `<leader>qw`
  - Ghi đè phiên hiện tại: `<leader>qv`
  - Ghi local (Session.vim trong project): `<leader>qW`
  - Ghi tên tùy ý: `<leader>qN`
  - Đọc phiên gần nhất: `<leader>ql`
  - Xóa (picker): `<leader>qD`
- mini.snippets (Insert mode):
  - Mở rộng: `<C-a>`; Nhảy: `<C-l>/<C-h>`; Dừng: `<C-c>`
- mini.git: tích hợp Git nhẹ (xem `:h mini.git` nếu cần lệnh)

UI
- mini.map (minimap, bên phải): bật/tắt khi cần
```lua
vim.keymap.set('n', '<leader>mm', function() require('mini.map').toggle() end)
```
- mini.diff: điều hướng hunk `[G`, `[g`, `]g`, `]G`
- mini.statusline / mini.tabline: tự kích hoạt; statusline hiển thị mode, git, diagnostics, tên file, macro recording, nhãn visits, harpoon (nếu có), vị trí dòng/cột + “progress bar”
- mini.hipatterns: tự tô màu mã màu hex và lớp Tailwind cho các file web
- mini.clue: enable bằng cách bỏ comment trong `core.lua`; hiện pop-up gợi ý phím theo ngữ cảnh
