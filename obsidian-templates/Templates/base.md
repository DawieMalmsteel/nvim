# Daily
```base
filters:
  and:
    - or:
        - 'file.ctime.format("YYYY-MM-DD") == this.file.name'
        - 'file.mtime.format("YYYY-MM-DD") == this.file.name'
    - '!file.inFolder("Dailies")'
    - '!file.inFolder("Templates")'
    - '!file.inFolder("bases")'
formulas:
  created_display: 'file.ctime.format("YYYY-MM-DD HH:mm")'
  modified_display: 'file.mtime.format("YYYY-MM-DD HH:mm")'
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
