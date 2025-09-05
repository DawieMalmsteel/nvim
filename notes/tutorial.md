### 1. **Tiêu đề (Headers)**
Để tạo tiêu đề, sử dụng ký tự `#`. Số lượng `#` xác định cấp độ tiêu đề (từ 1 đến 6).

- Cấp 1: `# Tiêu đề 1`
- Cấp 2: `## Tiêu đề 2`
- Cấp 3: `### Tiêu đề 3`

Ví dụ:
```markdown
# Tiêu đề lớn nhất
## Tiêu đề phụ
### Tiêu đề nhỏ hơn
```

---

### 2. **Đoạn văn bản**
Chỉ cần viết văn bản bình thường, không cần ký tự đặc biệt.

Ví dụ:
```markdown
Đây là một đoạn văn bản.
```

---

### 3. **In đậm và in nghiêng**
- **In đậm**: Bao quanh văn bản bằng hai dấu `**` hoặc `__`.
- *In nghiêng*: Bao quanh văn bản bằng một dấu `*` hoặc `_`.
- ***Kết hợp***: Dùng ba dấu `***`.

Ví dụ:
```markdown
**In đậm**
*In nghiêng*
***In đậm và nghiêng***
```

---

### 4. **Danh sách**
- **Danh sách không thứ tự**: Sử dụng `-`, `*`, hoặc `+`.
- **Danh sách có thứ tự**: Sử dụng số và dấu chấm `1.`.

Ví dụ:
```markdown
- Mục 1
- Mục 2
  - Mục con

1. Mục 1
2. Mục 2
```

---

### 5. **Liên kết (Links)**
Để tạo liên kết, sử dụng cú pháp sau:
```markdown
[Text hiển thị](URL)
```

Ví dụ:
```markdown
[Google](https://www.google.com)
```
Kết quả: [Google](https://www.google.com)

---

### 6. **Hình ảnh (Images)**
Để chèn hình ảnh, sử dụng cú pháp tương tự liên kết, nhưng thêm dấu `!` ở đầu:
```markdown
![Mô tả hình ảnh](URL hình ảnh)
```

Ví dụ:
```markdown
![Logo Markdown](https://markdown-here.com/img/icon256.png)
```

---

### 7. **Trích dẫn (Blockquotes)**
Để tạo trích dẫn, sử dụng ký tự `>` ở đầu dòng.

Ví dụ:
```markdown
> Đây là một trích dẫn.
```
Kết quả:
> Đây là một trích dẫn.

---

### 8. **Đoạn mã (Code)**
- **Mã trong dòng**: Bao quanh đoạn mã bằng dấu `` ` ``.
- **Khối mã**: Bao quanh đoạn mã bằng ba dấu `` ``` ``.

Ví dụ:
```markdown
`print("Hello, World!")`  // Mã trong dòng

```
print("Hello, World!")
```
```

---


---

### 9. **Đường kẻ ngang (Horizontal Rules)**
Để tạo đường kẻ ngang, sử dụng ba hoặc nhiều dấu `-`, `*`, hoặc `_` trên một dòng riêng biệt.

Ví dụ:
```markdown
---
___
```

### 10. **Bảng (Tables)**
Để tạo bảng, sử dụng dấu `|` để ngăn cách các cột và dấu `-` để tạo hàng tiêu đề.

Ví dụ:
```markdown
| Cột 1 | Cột 2 | Cột 3 |
|-------|-------|-------|
| Dữ liệu 1 | Dữ liệu 2 | Dữ liệu 3 |
| Dữ liệu 4 | Dữ liệu 5 | Dữ liệu 6 |
```
Kết quả:

| Cột 1     | Cột 2     | Cột 3     |
|-----------|-----------|-----------|
| Dữ liệu 1 | Dữ liệu 2 | Dữ liệu 3 |
| Dữ liệu 4 | Dữ liệu 5 | Dữ liệu 6 |

---

### 11. **Danh sách nhiệm vụ (Task Lists)**
Để tạo danh sách nhiệm vụ, sử dụng dấu `- [ ]` cho mục chưa hoàn thành và `- [x]` cho mục đã hoàn thành.

Ví dụ:
```markdown
- [ ] Việc 1
- [x] Việc 2
```
Kết quả:
- [ ] Việc 1
- [x] Việc 2

---

### 12. **Chú thích (Footnotes)**
Để thêm chú thích, sử dụng cú pháp:
```markdown
Câu này có chú thích.[^1]

[^1]: Đây là nội dung chú thích.
```

Kết quả:
Câu này có chú thích.[^1]

[^1]: Đây là nội dung chú thích.


---

### 13. **Thoát ký tự đặc biệt**
Nếu bạn muốn hiển thị các ký tự đặc biệt như `*`, `_`, `#`, hoặc `` ` ``, bạn cần thêm dấu `\` trước chúng.

Ví dụ:
```markdown
\*Không in nghiêng\*
\# Không phải tiêu đề
```
Kết quả:
\*Không in nghiêng\*  
\# Không phải tiêu đề

---

### 14. **HTML trong Markdown**
Markdown hỗ trợ nhúng HTML trực tiếp. Điều này hữu ích khi bạn cần các tính năng không có sẵn trong Markdown.

Ví dụ:
```markdown
<p style="color: red;">Đây là một đoạn văn bản màu đỏ.</p>
```
Kết quả:  
<p style="color: red;">Đây là một đoạn văn bản màu đỏ.</p>

---

### 15. **Gạch ngang chữ (Strikethrough)**
Để gạch ngang chữ, bao quanh văn bản bằng hai dấu `~~`.

Ví dụ:
```markdown
~~Văn bản bị gạch ngang~~
```
Kết quả: ~~Văn bản bị gạch ngang~~

---

### 16. **Tạo danh mục (TOC - Table of Contents)**
Một số trình biên dịch Markdown tự động tạo danh mục dựa trên các tiêu đề. Bạn chỉ cần sử dụng các tiêu đề `#`, `##`, `###` đúng cách.

---

### 17. **Tích hợp với công cụ khác**
Markdown thường được sử dụng với các công cụ như:
- **GitHub**: Để viết README.md hoặc tài liệu dự án.
- **Pandoc**: Chuyển đổi Markdown sang PDF, Word, HTML, v.v.
- **Obsidian/Notion**: Ghi chú cá nhân.

---
