# Obsidian templates & dot files

Bản nguồn cho cấu hình Obsidian — dùng để deploy sang máy mới hoặc vault mới.
Vault thật (`~/funthings/notes`) và folder này phải luôn khớp nhau.

## Cấu trúc

| Path | Nội dung |
|---|---|
| `.obsidian/` | Dot files của vault: `types.json` (property types), `hotkeys.json` (keymaps), `appearance.json`, `app.json`, `community-plugins.json`, `core-plugins.json` (daily notes đã cấu hình sẵn), `templates.json`, `hotkeys.json` |
| `Templates/` | Note templates: `Note.md` (note thường), `Daily.md` (daily note) |
| `obsidian.json` | Danh sách vaults của Obsidian Desktop (`~/.config/obsidian/obsidian.json`) — nhớ sửa path nếu username máy khác |

**Không đưa vào đây** (state động, thay đổi liên tục, không nên làm template):
`workspace.json`, `graph.json`, `.obsidian/plugins/*/main.js` (plugin vimrc-support đã track trong vault repo).

## Deploy máy mới

```bash
# 1. Clone 2 repo
git clone https://github.com/DawieMalmsteel/nvim ~/.config/nvim
git clone https://github.com/DawieMalmsteel/obsidian-template ~/funthings/notes

# 2. Copy dot files + templates vào vault (chỉ cần nếu vault clone ra chưa có)
cp -r ~/.config/nvim/obsidian-templates/.obsidian/* ~/funthings/notes/.obsidian/
cp -r ~/.config/nvim/obsidian-templates/Templates/* ~/funthings/notes/Templates/

# 3. Obsidian Desktop: vault list
cp ~/.config/nvim/obsidian-templates/obsidian.json ~/.config/obsidian/obsidian.json
# → mở obsidian.json sửa path cho đúng username (vd /home/tenmay/funthings/notes)

# 4. Mở nvim — lazy tự cài plugin theo lazy-lock.json
```

## Quy ước cập nhật

- Sửa dot files/templates ở **vault** (nơi Obsidian/nvim đọc trực tiếp) → copy ngược về folder này + commit
- Hoặc sửa ở folder này → deploy ra vault
- Cả 2 repo đều commit — đừng để lệch
