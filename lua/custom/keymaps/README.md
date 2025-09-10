Tiêu đề: Bộ keymaps Neovim dạng mô-đun (lua/custom/keymaps)

Tổng quan
- Vị trí: lua/custom/keymaps/*.lua
- Điểm vào: lua/custom/keymaps/init.lua nạp lần lượt các mô-đun, có cảnh báo nếu lỗi.
- Triết lý: Tách nhỏ theo chủ đề, dùng Snacks pickers khi có; fallback sang mini.nvim khi cần. Tránh lỗi khi thiếu plugin bằng safe require.

Yêu cầu
- Neovim 0.10+ (đang dùng vim.diagnostic.is_enabled/enable).
- Plugin chính:
  - snacks.nvim (picker, lazygit, terminal, words, notifications, dashboard, explorer)
  - mini.nvim: mini.pick, mini.files, mini.diff, mini.extra, mini.map (tuỳ tính năng)
  - refactoring.nvim
  - treesitter-context (TSContext)
  - vim-dadbod-ui (DBUI)
  - RenderMarkdown, InlineFold
- Công cụ ngoài:
  - lazygit (CLI) nếu dùng <leader>gg/<leader>gl.

Cài đặt / Cách nạp
- Chép thư mục lua/custom/keymaps vào config của bạn.
- Nạp sớm (vd. trong init.lua):
  - require('custom.keymaps')

Cấu trúc mô-đun
- init.lua: danh sách mô-đun và vòng lặp nạp an toàn.
- core.lua: hàm trợ giúp:
  - map(mode, lhs, rhs, opts): bọc vim.keymap.set, mặc định silent = true.
  - sr(mod): safe require (trả nil khi không có).
  - file_dir(): trả về thư mục của buffer hiện tại nếu hợp lệ, ngược lại cwd.
  - toggle_diagnostics(): bật/tắt diagnostics toàn cục.
  - lsp_scope(scope): mở mini.extra pickers.lsp theo scope.
  - git_pick(name), pick(name, opts): gọi Snacks.picker theo tên, có cwd/file_dir khi cần.
- groups.lua: khai báo nhãn nhóm cho which-key (không tạo map chức năng, chỉ để hiển thị nhóm).

Phím tắt theo chủ đề

1) Chỉnh sửa cơ bản (editing.lua)
- Điều hướng dòng bọc: j → gj, k → gk.
- Vào CMD nhanh: ; → : (nowait).
- Thoát insert: ở insert gõ kj.
- Lưu: <C-s> ở normal/insert/visual.
- Xoá ký tự ^M: <C-\>.
- Cuộn nhanh: <C-e>/<C-y> cuộn 3 dòng.
- Không ghi đè register mặc định:
  - v: c → "_c, x → "_x
  - n: c → "_c, x → "_x, <S-X> → "_dd
- Dán không ghi đè: visual <leader>P → "_dP.
- Di chuyển block chọn: visual J/K.
- Nhảy đầu/cuối từ đã trim: gi → ^, ga → g_.
- Nhảy theo cặp: <Tab> → %.
- Chọn/yank trong cặp nháy: y'/v', y"/v".
- Tạo file mới: <leader><Tab> → :e (đợi bạn nhập tên).

2) Tìm kiếm & Picker (search.lua)
- Lịch sử lệnh: <leader>; (Snacks), và <leader>sc.
- File (cwd): <leader>ff (đặt cwd theo PWD hoặc getcwd rồi :Pick files).
- File gần đây: <leader>fr (Snacks recent live; fallback mini.pick).
- Dòng trong buffer hiện tại: <leader>/ (Pick buf_lines scope='current').
- Tìm sống toàn cục: <leader>fg (Snacks live).
- Grep (cwd): <leader>sG (đổi cwd rồi Pick grep_live).
- Grep theo thư mục file: <leader>sg (mini.pick grep_live trong dir của buffer hoặc cwd).
- Từ hiện tại: <leader>sw (mini.pick grep pattern=<cword>).
- Resume: <leader>sr (Pick), <leader>sR (Snacks).
- Tiện ích khác (Snacks):
  - Đăng ký: <leader>s"
  - Lịch sử tìm kiếm: <leader>s/
  - Autocmds: <leader>sa
  - Help: <leader>sh
  - Lệnh: <leader>sC; Lịch sử lệnh: <leader>sc
  - Diagnostics: <leader>sd (tất cả), <leader>sD (buffer)
  - Highlights: <leader>sH; Icons: <leader>si
  - Jumps: <leader>sj; Keymaps: <leader>sk
  - Loclist: <leader>sl; Quickfix: <leader>sq
  - Man pages: <leader>sM; Marks: <leader>sm
  - Undo: <leader>su
- Mở file theo thư mục buffer: <leader><leader> (mini.pick).

3) Buffer & thoát (buffers.lua)
- Điều hướng: H → bprevious (theo count), L → bnext (theo count).
- Đóng buffer: <leader>bd hoặc <leader>qb (Snacks.bufdelete nếu có, fallback :bd).
- Đóng buffer + window: <leader>qB → :bw.
- Đóng window giữ buffer: <leader>qd → <C-w>q.
- Thoát Neovim: <leader>qq (qa), <leader>qQ (qa!).
- Dọn dẹp:
  - Đóng hidden buffers: <leader>bh.
  - Đóng buffer không tên: <leader>bu.

4) Diagnostics (diagnostics.lua)
- Bật/tắt diagnostics: <leader>td hoặc <C-x>.
- Đẩy vào danh sách: <leader>x → loclist, <leader>cq → quickfix.
- Float tại dòng: <leader>cd.
- Điều hướng:
  - [d / ]d: prev/next bất kỳ, có float.
  - [e / ]e: prev/next ERROR, có float.
  - [w / ]w: prev/next WARN, có float.

5) LSP (lsp.lua, mini.extra)
- grd: goto definition.
- gri: goto implementation.
- grr: references.
- grD: declaration.
- grt: type definition.
- gO: document symbols.
- gW: workspace symbols.

6) Files & Git tiện ích (files.lua)
- mini.files:
  - <leader>e: mở dir theo buffer hiện tại nếu hợp lệ, ngược lại cwd.
  - <leader>fm: mở cwd.
  - <leader>N: mở thư mục notes trong config.
- Files (config):
  - <leader>fC: Snacks.picker.files cwd=stdpath('config').
  - <leader>fc: khai báo hai lần; map thứ 2 thắng → mini.pick files cwd=stdpath('config').
- Registers/Marks (Pick): <leader>fR / <leader>fM.
- Buffers (Snacks):
  - <leader>fb: buffers hiện hữu.
  - <leader>fF: tất cả buffers (kể cả hidden/nofile).
- Đổi tên file: grN (Snacks.rename.rename_file()).
- Git theo thư mục file (Pick + đổi cwd):
  - <leader>gf: git_files.
  - <leader>gc: git_commits.
  - <leader>go: mini.diff.toggle_overlay(0).

7) Git (git.lua)
- Lazygit: <leader>gg; Logs: <leader>gl.
- Pickers (Snacks):
  - <leader>gs: status; <leader>gd: diff; <leader>gF: log theo file; <leader>gS: stash.
  - <leader>gb: branches; <leader>gB: branches layout 'select'.
  - <leader>gL: log theo dòng hiện tại.
  - <leader>gh: git hunks (Pick) theo thư mục file.

8) UI (ui.lua)
- Wrap: <leader>uw.
- Đổi theme (Snacks colorschemes): <leader>uc.
- Treesitter-context: <leader>tc.
- Mini map: <leader>um (toggle), <leader>uM (focus).
- Dashboard (Snacks): <leader>tD.
- Explorer (Snacks): <leader>E.
- Thông báo:
  - Lịch sử: <leader>n (dùng picker nếu bật, ngược lại mở notifier history).
  - Ẩn tất cả: <leader>un.

9) Extras (extras.lua)
- Điều hướng cửa sổ: <C-h/j/k/l>.
- Oldfiles (Pick): <leader>o.
- Plugin specs (Snacks lazy): <leader>sp.
- Buffer picker (mini.pick) có xoá nhanh bằng <C-d>:
  - <leader>r và <M-r> mở danh sách buffers; nhấn <C-d> để xoá mục đang chọn.
- Toggles khác:
  - <leader>tm: RenderMarkdown toggle.
  - <leader>ti: InlineFold toggle.

10) Terminal (terminal.lua)
- Toggle terminal (Snacks): <C-/> (ở normal/terminal).
- Nhảy tham chiếu từ (Snacks.words): ]] (tiến), [[ (lùi), tôn trọng count.
- Thoát terminal mode: <Esc><Esc>.

11) Misc (misc.lua)
- Mason: <leader>cm.
- DB UI: <leader>D.
- Đổi kích thước split: <C-Up>/<C-Down>/<C-Right>/<C-Left>.

Nhóm which-key (groups.lua)
- Nhãn nhóm: +code, +ai, +find, +git, +ui, +quit, +toggles, +search, +LSP, +mark group, +buffers, +debug, +refactor, +notes, +Obsidian, +markdown org, +visits.
- Dùng để hiển thị menu which-key; không gắn chức năng.

Lưu ý quan trọng
- Một số map thay đổi cwd phiên làm việc bằng :cd trước khi gọi Pick/Git. Nếu không muốn, xoá các dòng vim.cmd('cd ' .. ...).
- <leader>fc bị định nghĩa hai lần trong files.lua; map sau (mini.pick) sẽ ghi đè map Snacks trước đó.
- Nhiều map phụ thuộc Snacks/mini; nếu plugin không sẵn sàng, map an toàn và sẽ không gây lỗi (nhưng không có tác dụng).
- Một số phím có thể trùng thói quen của bạn (vd. <C-x> dùng toggle diagnostics). Tuỳ biến như bên dưới.

Tuỳ biến nhanh
- Thêm map mới:
  - require('custom.keymaps.core').map('n', '<leader>x', func_or_cmd, { desc = '...' })
- Vô hiệu hoá map:
  - map('n', '<key>', '<Nop>') hoặc xoá map trong file tương ứng.
- Đổi hành vi cwd:
  - Bỏ các lệnh vim.cmd('cd ' .. ...) trong search.lua, files.lua, git.lua.
- Xoá trùng <leader>fc:
  - Giữ map Snacks: xoá đoạn thứ hai (mini.pick).
  - Hoặc đổi một trong hai sang phím khác (vd. <leader>fC cho Snacks, <leader>fc cho mini).

Khắc phục sự cố
- Lỗi “module not found”: đảm bảo đã cài plugin tương ứng (Snacks/mini/refactoring/...).
- Lệnh :Pick không tồn tại: kiểm tra snacks.nvim đã nạp và tính năng picker đã bật.
- Lazygit không mở: kiểm tra lazygit đã cài (lazygit --version).
- Diagnostics toggle không hoạt động: cần Neovim 0.10+.

Gợi ý phím nổi bật
- Lưu nhanh: <C-s>
- Tìm file: <leader>ff (cwd), <leader><leader> (theo thư mục buffer)
- Grep nhanh: <leader>fg (Snacks), <leader>sG (cwd), <leader>sg (dir buffer)
- Buffer: H/L chuyển, <leader>bd xoá, <leader>r liệt kê + <C-d> xoá
- Git: <leader>gg, <leader>gs, <leader>gd, <leader>gb
- Files UI: <leader>e (mini.files), <leader>fm (cwd)
- Terminal: <C-/> toggle, <Esc><Esc> thoát
