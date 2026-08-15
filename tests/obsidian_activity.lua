-- Unit tests for lua/obsidian/activity.lua.
--
-- Run from the repo root:
--     luajit tests/obsidian_activity.lua      (or: lua tests/obsidian_activity.lua)
-- The module is dependency-injected, so it needs no nvim — only plain Lua.
-- Expected outputs are asserted exactly (deterministic), not by fuzzy membership.

package.path = 'lua/?.lua;lua/?/init.lua;' .. package.path

local activity = require 'obsidian.activity'

local failures = 0
local tests = 0

local function dump(t)
  local out = {}
  for _, v in ipairs(t) do
    out[#out + 1] = string.format('%q', v)
  end
  return '{' .. table.concat(out, ', ') .. '}'
end

local function eq(a, b)
  if type(a) ~= type(b) then
    return false
  end
  if type(a) ~= 'table' then
    return a == b
  end
  for k, v in pairs(a) do
    if not eq(v, b[k]) then
      return false
    end
  end
  for k in pairs(b) do
    if a[k] == nil then
      return false
    end
  end
  return true
end

local function check(name, cond)
  tests = tests + 1
  if cond then
    return
  end
  failures = failures + 1
  io.write('  FAIL  ' .. name .. '\n')
end

local function check_lines(name, expected, got)
  if eq(expected, got) then
    tests = tests + 1
    return
  end
  failures = failures + 1
  io.write('  FAIL  ' .. name .. '\n')
  io.write('        expected: ' .. dump(expected) .. '\n')
  io.write('        got:      ' .. dump(got) .. '\n')
end

-- ===========================================================================
-- normalize_day
-- ===========================================================================

check('normalize_day: ISO timestamp passes through unchanged', activity.normalize_day '2026-08-16T10:30:00' == '2026-08-16T10:30:00')
check('normalize_day: date expands to midnight ISO', activity.normalize_day '2026-08-16' == '2026-08-16T00:00:00')
check('normalize_day: date zero-pads parts', activity.normalize_day '2026-02-03' == '2026-02-03T00:00:00')
check('normalize_day: DD-MM-YYYY (unused vault format) passes through', activity.normalize_day '16-08-2026' == '16-08-2026')
check('normalize_day: non-date string passes through', activity.normalize_day 'garbage' == 'garbage')
check('normalize_day: empty string passes through', activity.normalize_day '' == '')
check('normalize_day: nil passes through', activity.normalize_day(nil) == nil)
check('normalize_day: number passes through', activity.normalize_day(16) == 16)
check('normalize_day: short/invalid date passes through', activity.normalize_day '2026-8-6' == '2026-8-6')

-- ===========================================================================
-- template_lines
-- ===========================================================================

local tmpl = { '---', 'title: {{date}}', 'day: {{date:DD-MM-YYYY}}', '---' }
local tmpl_out = activity.template_lines(tmpl, '16-08-2026', '2026-08-16T12:00:00')
check_lines('template_lines: substitutes {{date}} and {{date:DD-MM-YYYY}}', {
  '---',
  'title: 2026-08-16T12:00:00',
  'day: 16-08-2026',
  '---',
}, tmpl_out)
check('template_lines: does not mutate the input template', tmpl[2] == 'title: {{date}}' and tmpl[3] == 'day: {{date:DD-MM-YYYY}}')

local fallback = activity.template_lines(nil, '16-08-2026', '2026-08-16T12:00:00')
check_lines('template_lines: fallback body matches vault convention', {
  '---',
  'tags: [daily]',
  'created_day: 2026-08-16T12:00:00',
  'updated_day: 2026-08-16T12:00:00',
  '---',
  '',
  '# 16-08-2026',
  '',
  '## Activity',
  '',
}, fallback)

-- ===========================================================================
-- append_activity (pure insert/dedup)
-- ===========================================================================

check_lines('inserts entry under existing ## Activity heading', {
  '# 16-08-2026',
  '',
  '## Activity',
  '- 10:30 [[My Note]]',
  '',
}, activity.append_activity({ '# 16-08-2026', '', '## Activity', '' }, 'My Note', '10:30'))

check_lines('creates heading + entry when heading missing', {
  '# 16-08-2026',
  '',
  '',
  '## Activity',
  '- 09:05 [[A]]',
}, activity.append_activity({ '# 16-08-2026', '' }, 'A', '09:05'))

local dup = { '## Activity', '- 10:30 [[My Note]]', '' }
check('returns nil when link already present (dedup)', activity.append_activity(dup, 'My Note', '11:00') == nil)
check('dedup leaves the array untouched', #dup == 3)
check('dedup catches bare link in prose', activity.append_activity({ 'see [[Plan]] here' }, 'Plan', '12:00') == nil)
check('appends when a different note is present', activity.append_activity({ '## Activity', '- 10:30 [[Other]]', '' }, 'Plan', '12:00') ~= nil)

-- ===========================================================================
-- append (full flow) — fake deps
-- ===========================================================================

local ROOT = '/tmp/vault'
local DAILY = '/tmp/vault/Dailies'

-- Record the exact os.date formats the flow asked for.
local function fake_clock()
  local calls = {}
  return function(format)
    calls[#calls + 1] = format
    if format == '%d-%m-%Y' then
      return '16-08-2026'
    elseif format == '%Y-%m-%dT%H:%M:%S' then
      return '2026-08-16T10:05:00'
    elseif format == '%H:%M' then
      return '10:05'
    end
    error('unexpected date format ' .. tostring(format))
  end,
    calls
end

local function clone(t)
  local out = {}
  for i, v in ipairs(t) do
    out[i] = v
  end
  return out
end

-- Fresh fake deps. `overrides` may set d.daily / d.template to simulate
-- pre-existing content; the dirty test-specific state is always reset.
local function fake_deps()
  local d = {
    root = ROOT,
    daily_dir = DAILY,
    day_format = '%d-%m-%Y',
    iso_format = '%Y-%m-%dT%H:%M:%S',
    time_format = '%H:%M',
    ignored = { Dailies = true, Templates = true, bases = true },
    daily = nil, -- nil => note does not exist yet
    template = nil,
    dir_mkdirs = {},
    writes = {},
    written_lines = nil,
  }
  d.read_daily = function()
    if d.daily then
      return clone(d.daily)
    end
  end
  d.write_daily = function(path, lines)
    d.writes[#d.writes + 1] = path
    d.written_lines = clone(lines)
    d.daily = clone(lines)
  end
  d.read_template = function()
    return d.template and clone(d.template) or nil
  end
  d.ensure_daily_dir = function()
    d.dir_mkdirs[#d.dir_mkdirs + 1] = DAILY
  end
  return d
end

local DAYLY_FILE = DAILY .. '/16-08-2026.md'

-- New note, no daily file yet => created from the fallback template.
local d1 = fake_deps()
local clock1f, clock1_calls = fake_clock()
local status1 = activity.append(d1, ROOT .. '/Inbox/First Note.md', clock1f)
check('new: status is appended', status1 == 'appended')
check('new: ensures Dailies dir once', eq(d1.dir_mkdirs, { DAILY }))
check('new: clock asks for day, iso and time formats', eq(clock1_calls, { '%d-%m-%Y', '%Y-%m-%dT%H:%M:%S', '%H:%M' }))
check('new: writes to the correct daily path', eq(d1.writes, { DAYLY_FILE }))
check_lines('new: fallback body with entry inserted under heading', {
  '---',
  'tags: [daily]',
  'created_day: 2026-08-16T10:05:00',
  'updated_day: 2026-08-16T10:05:00',
  '---',
  '',
  '# 16-08-2026',
  '',
  '## Activity',
  '- 10:05 [[First Note]]',
  '',
}, d1.written_lines)

-- Existing daily on disk => keep old entries, add new one under the heading.
local d2 = fake_deps()
d2.daily = { '## Activity', '- 09:00 [[Old]]', '' }
local status2 = activity.append(d2, ROOT .. '/Projects/Zet.md', fake_clock())
check('existing: status is appended', status2 == 'appended')
-- Newest entry is inserted directly under the heading (existing entries shift down).
check_lines('existing: keeps old entry, prepends newest under heading', {
  '## Activity',
  '- 10:05 [[Zet]]',
  '- 09:00 [[Old]]',
  '',
}, d2.written_lines)

-- Duplicate: same note already logged today => no write.
local d3 = fake_deps()
d3.daily = { '## Activity', '- 10:05 [[Zet]]', '' }
local status3 = activity.append(d3, ROOT .. '/Projects/Zet.md', fake_clock())
check('duplicate: status is duplicate', status3 == 'duplicate')
check('duplicate: no write issued', #d3.writes == 0)
check('duplicate: no dir ensured', #d3.dir_mkdirs == 0)

-- Custom template present => note body comes from the substituted template.
local d4 = fake_deps()
d4.template = { '---', 'created: {{date}}', 'day: {{date:DD-MM-YYYY}}', '---', '## Activity', '' }
local status4 = activity.append(d4, ROOT .. '/Books/Gone.md', fake_clock())
check('template: status is appended', status4 == 'appended')
check_lines('template: body from custom template with placeholders filled', {
  '---',
  'created: 2026-08-16T10:05:00',
  'day: 16-08-2026',
  '---',
  '## Activity',
  '- 10:05 [[Gone]]',
  '',
}, d4.written_lines)

-- Nested path: note_name is the basename without extension.
local d4b = fake_deps()
local status4b = activity.append(d4b, ROOT .. '/A/B/C.topic.md', fake_clock())
check('nested: status is appended', status4b == 'appended')
local nested_entry
for _, line in ipairs(d4b.written_lines) do
  if line == '- 10:05 [[C.topic]]' then
    nested_entry = true
  end
end
check('nested: note_name strips directory and extension', nested_entry == true)

-- Ignored folders.
for _, folder in ipairs { 'Dailies', 'Templates', 'bases' } do
  local d5 = fake_deps()
  local s = activity.append(d5, ROOT .. '/' .. folder .. '/whatever.md', fake_clock())
  check('folder ' .. folder .. ': status is ignored', s == 'ignored')
  check('folder ' .. folder .. ': nothing written or created', #d5.writes == 0 and #d5.dir_mkdirs == 0)
end

-- Markdown requirement + vault boundary.
local d6 = fake_deps()
check('non-md inside vault: ignored', activity.append(d6, ROOT .. '/Inbox/notes.txt', fake_clock()) == 'ignored')
check('non-md inside vault: nothing written', #d6.writes == 0)

local d7 = fake_deps()
check('file outside vault: ignored', activity.append(d7, '/etc/hosts.md', fake_clock()) == 'ignored')
check('file outside vault: nothing written', #d7.writes == 0)

local d8 = fake_deps()
check('vault-adjacent prefix is not inside: ignored', activity.append(d8, ROOT .. '-sibling/a.md', fake_clock()) == 'ignored')

-- Dedup must also apply when heading exists but note was already added today.
local d9 = fake_deps()
d9.daily = { '## Activity', '- 10:05 [[Zet]]', '' }
check('existing duplicate: status is duplicate', activity.append(d9, ROOT .. '/Projects/Zet.md', fake_clock()) == 'duplicate')
check('existing duplicate: no write issued', #d9.writes == 0)

-- ===========================================================================
-- summary
-- ===========================================================================

io.write('\n' .. (tests - failures) .. '/' .. tests .. ' assertions passed')
if failures > 0 then
  io.write('   (' .. failures .. ' FAILED)\n')
  os.exit(1)
end
io.write '\n'
os.exit(0)
