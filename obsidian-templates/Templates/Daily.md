---
tags: [daily]
created_day: {{date}}
updated_day: {{date}}
---

# {{date:DD-MM-YYYY}}

## Activity

## Notes tạo hoặc cập nhật hôm nay

```base
filters:
  and:
    - or:
        - 'file.ctime.format("DD-MM-YYYY") == this.file.name'
        - 'file.mtime.format("DD-MM-YYYY") == this.file.name'
    - '!file.inFolder("Dailies")'
    - '!file.inFolder("Templates")'
    - '!file.inFolder("bases")'
formulas:
  created_display: 'file.ctime.format("DD/MM/YYYY, HH:mm:ss")'
  modified_display: 'file.mtime.format("DD/MM/YYYY, HH:mm:ss")'
properties:
  formula.created_display:
    displayName: Created
  formula.modified_display:
    displayName: Modified
views:
  - type: table
    name: Today
    order:
      - file.name
      - formula.created_display
      - formula.modified_display
    sort:
      - property: file.mtime
        direction: DESC
```
