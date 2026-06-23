1. Xóa snapshot

```bash
  # Xem danh sách snapshot
  sudo snapper -c root list

  # Xóa tất cả (trừ #0 current)
  sudo snapper -c root delete 25-999

  # Xóa từng cái nếu muốn
  sudo snapper -c root delete <id>
```

2. Check snapshot

```bash
  # Danh sách + thời gian
  sudo snapper -c root list

  # Chi tiết 1 snapshot
  sudo snapper -c root status <id>
```

3. Free ổ cứng sau khi xóa

```bash
  # Xem block đang bị giữ
  sudo btrfs filesystem df /

  # Trả block về
  sudo btrfs balance start -dusage=50 /

  # Xác nhận kết quả
  df -h /
```

Thứ tự: xóa snapshot → balance → df -h / thấy chỗ trống tăng lên. Done.
