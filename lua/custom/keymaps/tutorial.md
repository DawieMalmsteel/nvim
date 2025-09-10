# Hướng dẫn đầy đủ: Đặt Keymaps và cấu trúc bộ keymaps (custom/keymaps)

Mục tiêu
- Hiểu cách nạp và tổ chức keymaps dạng mô-đun.
- Biết đặt/đổi/xoá keymaps đúng chỗ.
- Nắm chức năng của từng file trong thư mục lua/custom/keymaps.
- Vận hành tốt cùng Snacks.nvim và mini.nvim (có fallback an toàn).

Yêu cầu
- Neovim 0.10+ (đang dùng vim.diagnostic.is_enabled/enable).
- Plugin (khuyến nghị):
  - snacks.nvim (picker, lazygit, terminal, words, notifications, dashboard, explorer)
  - mini.nvim: mini.pick, mini.files, mini.diff, mini.extra, mini.map
  - refactoring.nvim
  - treesitter-context
  - vim-dadbod-ui
  - RenderMarkdown, InlineFold
- Công cụ ngoài: lazygit (cho <leader>gg/<leader>gl).

Cách nạp nhanh
- Gọi một lần sớm trong config của bạn (ví dụ: init.lua):
  - require('custom.keymaps')

Triết lý & quy ước
- Mỗi nhóm phím được tách thành một file mô-đun cho dễ bảo trì.
- Dùng core.map() bọc vim.keymap.set để có mặc định silent=true và cú pháp thống nhất.
- Dùng core.sr() (safe require) để không lỗi khi plugin chưa có.
- Dùng desc để which-key hiển thị rõ ràng.
- Ưu tiên Snacks pickers; có fallback mini.nvim khi cần.

Tổng quan helpers (core.lua)
- map(mode, lhs, rhs, opts)
  - Bọc vim.keymap.set với mặc định opts.silent=true.
  - Hỗ trợ mode: 'n', 'i', 'v/x', 't', hoặc mảng mode.
  - Gợi ý: luôn truyền opts.desc để which-key gợi ý.
- sr(mod)
  - Safe require: trả module hoặc nil, không ném lỗi.
- file_dir()
  - Trả thư mục của file hiện tại nếu hợp lệ; ngược lại cwd hiện tại.
- toggle_diagnostics()
  - Bật/tắt diagnostics toàn cục (nvim 0.10+).
- lsp_scope(scope)
  - Trả hàm mở mini.extra.pickers.lsp theo scope (definition/references/...).
- git_pick(name), pick(name, opts)
  - Mở Snacks.picker theo tên (có kiểm tra tồn tại).

Cấu trúc mô-đun (mỗi file làm gì)
- init.lua
  - Danh sách mô-đun và vòng lặp require an toàn (pcall + notify lỗi).
- core.lua
  - Bộ helper dùng chung (map, sr, file_dir, toggle_diagnostics, pick helpers).
- groups.lua
  - Khai báo nhãn nhóm cho which-key (chỉ đặt desc cho prefix, không gán hành vi).
- editing.lua
  - Phím chỉnh sửa nền tảng: di chuyển dòng bọc, lưu nhanh, giữ register khi x/c, dán không ghi đè, di chuyển block chọn, nhảy theo cặp, tạo file mới,...
- files.lua
  - mini.files mở theo file/cwd, mở config/notes, registers/marks (Pick), buffers (Snacks), rename file (Snacks), Git files/commits (Pick), mini.diff overlay.
- git.lua
  - Lazygit + log; Git pickers (status, diff, log file, stash, branches, log line, hunks).
- search.lua
  - Pickers tìm kiếm: files, recent, buffer lines, grep (live), grep theo dir file, history, registers, help, keymaps, diagnostics, undo, resume,...
- diagnostics.lua
  - Bật/tắt diagnostics, mở float, điều hướng lỗi/cảnh báo, đẩy vào loclist/quickfix.
- lsp.lua
  - LSP scopes (mini.extra) như definition, references, symbols,...
- buffers.lua
  - Điều hướng buffers H/L, đóng buffer hiện tại, đóng hidden/nameless, quit nhanh.
- ui.lua
  - Toggle wrap, đổi theme (Snacks colorschemes), TS context toggle, mini.map, dashboard, explorer, lịch sử thông báo, ẩn thông báo.
- terminal.lua
  - Toggle terminal (Snacks), nhảy tham chiếu từ (Snacks.words), thoát terminal mode nhanh.
- refactor.lua
  - Map refactoring.nvim (extract/inine/select...) cho normal/visual.
- misc.lua
  - Mở Mason, DBUI, đổi kích thước cửa sổ.
- README.md
  - Bản tóm tắt các phím đã có, ghi chú, khắc phục sự cố.
- tutorial.md (file này)
  - Hướng dẫn chi tiết cách thêm/sửa/xoá và mở rộng.

Cách đặt keymap mới (đúng chỗ)
1) Xác định chủ đề để chọn file:
   - Sửa văn bản → editing.lua
   - Tìm kiếm/picker → search.lua
   - File/explorer/buffers → files.lua hoặc buffers.lua
   - Git → git.lua
   - Giao diện/toggle UI → ui.lua
   - Terminal → terminal.lua
   - LSP chung (pickers.lsp) → lsp.lua
   - Refactor → refactor.lua
   - Nhóm khác/lặt vặt → misc.lua hoặc extras.lua

2) Thêm map bằng core.map:
   - Ví dụ: thêm toggle số dòng tương đối (ui.lua)
     local map = require('custom.keymaps.core').map
     map('n', '<leader>ur', function()
       vim.wo.relativenumber = not vim.wo.relativenumber
     end, { desc = 'Toggle Relative Number' })

   - Ví dụ: thêm mở quickfix (misc.lua)
     local map = require('custom.keymaps.core').map
     map('n', '<leader>oq', '<CMD>copen<CR>', { desc = 'Open Quickfix' })

3) Dùng desc rõ ràng cho which-key:
   - desc giúp hiển thị gợi ý và tự tài liệu hoá phím tắt.

4) Khi phụ thuộc plugin, dùng core.sr để an toàn:
   local core = require 'custom.keymaps.core'
   local map = core.map
   map('n', '<leader>xx', function()
     local Snacks = core.sr 'snacks'
     if Snacks and Snacks.picker then
       Snacks.picker.commands()
     else
       vim.notify('Snacks chưa sẵn sàng', vim.log.levels.WARN)
     end
   end, { desc = 'Lệnh (Snacks)' })

Đổi/Xoá keymap
- Đổi phím: sửa lhs trong file tương ứng.
- Vô hiệu hoá tạm thời: map('n', '<key>', '<Nop>').
- Xoá hẳn: gỡ dòng map.
- Kiểm tra map hiện tại: :map <key> hoặc mở picker keymaps (<leader>sk).
- Xung đột: phím sau cùng được đặt sẽ “thắng”. Với 2 map giống nhau ở nhiều file, map định nghĩa sau (trong thứ tự modules ở init.lua) sẽ ghi đè.

Thêm nhóm which-key mới (groups.lua)
- Thêm vào bảng groups:
  ['<leader>z'] = '+my group',
- Sau đó có thể đặt các phím con dưới prefix <leader>z ở các mô-đun khác.

Đặt map theo buffer/filetype (nâng cao)
- Tạo map cục bộ khi attach LSP hoặc theo filetype:
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'lua', 'python' },
    callback = function(args)
      local map = require('custom.keymaps.core').map
      map('n', 'go', 'o<ESC>', { buffer = args.buf, desc = 'Open line below' })
    end,
  })

- Khi dùng trong LSP (attach):
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local map = require('custom.keymaps.core').map
      map('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf, desc = 'LSP: Goto Definition' })
    end,
  })

Các tuỳ chọn map hữu ích
- nowait = true: tránh chờ thêm phím (ví dụ ; → :).
- expr = true: rhs là biểu thức Lua (trả về chuỗi lệnh).
- buffer = bufnr: map cục bộ buffer (dùng trong autocmd).
- silent: mặc định true trong core.map (không hiện status command).
- noremap: mặc định vim.keymap.set là noremap; hiếm khi cần đổi.

Về cwd và “cd …”
- Một số map gọi vim.cmd('cd ' .. ...) để đặt cwd tạm thời trước khi chạy Pick/Git.
- Nếu không muốn thay đổi cwd phiên làm việc, xoá các dòng cd, hoặc truyền cwd trực tiếp (khi picker hỗ trợ).
- Ví dụ thay vì :cd rồi Pick, có thể gọi Snacks.picker.files { cwd = core.file_dir() } (đã áp dụng ở nhiều nơi trong code).

Ví dụ nhanh (tự thêm mới)
1) Mở toggle spell cho cửa sổ hiện tại (ui.lua):
   local map = require('custom.keymaps.core').map
   map('n', '<leader>us', function()
     vim.wo.spell = not vim.wo.spell
   end, { desc = 'Toggle Spell' })

2) Xoá dòng không sao chép vào register (editing.lua):
   local map = require('custom.keymaps.core').map
   map('n', '<leader>dd', [["_dd]], { desc = 'Delete line (blackhole)' })

3) Grep từ visual selection (search.lua + mini.pick):
   local map = require('custom.keymaps.core').map
   map('v', '<leader>sv', function()
     local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
     vim.api.nvim_feedkeys(esc, 'x', false)
     local sel = vim.fn.getreg('v') -- nếu đã thiết lập copy visual vào "v"
     require('mini.pick').builtin.grep { pattern = sel }
   end, { desc = 'Search visual text' })

Khắc phục sự cố
- “module not found”: kiểm tra đã cài plugin tương ứng (Snacks/mini/refactoring/...).
- :Pick không tồn tại: kiểm tra snacks.nvim đã nạp và picker.enabled.
- Lazygit không mở: cài lazygit (lazygit --version).
- Toggle diagnostics không chạy: cần Neovim 0.10+.
- Trùng phím: dùng :verbose map <lhs> để xem map nào thắng và file nguồn.
- which-key không hiện mô tả: đảm bảo có opts.desc và đã khai báo nhóm (nếu cần).

Thứ tự nạp mô-đun (ảnh hưởng “ghi đè”)
- Xem lua/custom/keymaps/init.lua. Mô-đun xuất hiện sau có thể ghi đè phím trùng.
- Thứ tự hiện tại: core → groups → editing → files → git → diagnostics → lsp → search → ui → buffers → extras → refactor → terminal → misc.

Tài liệu nhanh các phím nổi bật (tham khảo)
- Lưu: <C-s>
- Tìm file: <leader>ff (cwd), <leader><leader> (theo thư mục buffer)
- Grep: <leader>fg (Snacks live), <leader>sG (cwd), <leader>sg (dir file)
- Buffer: H/L chuyển, <leader>bd xoá, <leader>r mini.pick + <C-d> xoá
- Git: <leader>gg, <leader>gs, <leader>gd, <leader>gb
- Files UI: <leader>e (mini.files), <leader>fm (cwd)
- Diagnostics: <leader>td toggle, [d ]d nhảy
- UI: <leader>uw wrap, <leader>uc đổi theme
- Terminal: <C-/> toggle, <Esc><Esc> thoát

Mở rộng module mới
- Tạo file lua/custom/keymaps/mymodule.lua, viết map theo chủ đề.
- Thêm 'custom.keymaps.mymodule' vào bảng modules trong init.lua (sau core/groups).
- Quy ước đặt desc, dùng core.sr cho plugin tuỳ chọn, giữ map tối giản và an toàn.

Gợi ý thực hành tốt
- Viết map ngắn gọn, có desc, không ràng buộc plugin cứng (safe require).
- Gom đúng chủ đề, tránh file “tạp”.
- Dọn map trùng/phím không dùng; xem README.md để biết map sẵn có.
- Kiểm thử phím mới bằng :map và chạy thực tế, sửa mô tả nếu khó hiểu.

