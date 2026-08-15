-- Unit tests for lua/config/snacks-util.lua (Snacks picker cwd helper +
-- inline-image toggle). Dependency-injected, so runs under plain Lua without
-- nvim or Snacks.
--
-- Run from the repo root:
--     luajit tests/snacks_util.lua   (or: lua tests/snacks_util.lua)

package.path = 'lua/?.lua;lua/?/init.lua;' .. package.path

local util = require 'config.snacks-util'

local failures = 0
local tests = 0

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

-- ===========================================================================
-- cwd
-- ===========================================================================

local function cwd_deps(overrides)
  local d = {
    buf_name = '', -- current buffer path
    readable = false,
    dir_out = nil,
    proc_cwd = '/proc/cwd',
  }
  d.buf_get_name = function()
    return d.buf_name
  end
  d.filereadable = function(path)
    return d.readable
  end
  d.fnamemodify = function(path, mod)
    -- :h already returned by the fake dir_out to keep the test deterministic.
    return d.dir_out or (mod == ':h' and path:match '^(.*)[/\\][^/\\]*$' or path)
  end
  d.uv_cwd = function()
    return d.proc_cwd
  end
  for k, v in pairs(overrides or {}) do
    d[k] = v
  end
  return d
end

-- Named, readable buffer -> its directory.
check('cwd: returns buffer dir for readable named buffer', util.cwd(cwd_deps { buf_name = '/a/b/file.md', readable = true }) == '/a/b')

-- Named but not readable -> process cwd fallback.
check('cwd: falls back to process cwd when file unreadable', util.cwd(cwd_deps { buf_name = '/a/b/new.txt', readable = false }) == '/proc/cwd')

-- Unnamed buffer -> process cwd.
check('cwd: uses process cwd for unnamed buffer', util.cwd(cwd_deps { buf_name = '' }) == '/proc/cwd')

-- Default deps path resolves when all sources agree (integration-shaped).
local ddef = cwd_deps { buf_name = '/x/y/z.lua', readable = true, dir_out = '/x/y' }
check('cwd: fnamemodify :h consumed', util.cwd(ddef) == '/x/y')

-- ===========================================================================
-- inline_image_toggle
-- ===========================================================================

local INFO = { level = 'INFO' }

local function toggle_deps(overrides)
  local d = {
    current = 1,
    bvar = {}, -- bvar[buf][key]
    image_total = 0, -- doc.get_image_doc calls? not used
    attach_calls = {},
    exec_calls = {},
    exec_ok = true,
    notify_calls = {},
  }
  d.image = function()
    d.image_queries = (d.image_queries or 0) + 1
    return d.image_module or { doc = d.doc }
  end
  d.doc = {
    find_visible = function(buf, cb)
      return 'FOUND:' .. buf
    end,
    attach = function(buf)
      d.attach_calls[#d.attach_calls + 1] = buf
    end,
  }
  d.set_bvar = function(buf, key, value)
    d.bvar[buf] = d.bvar[buf] or {}
    d.bvar[buf][key] = value
  end
  d.get_bvar = function(buf, key)
    return d.bvar[buf] and d.bvar[buf][key]
  end
  d.get_current_buf = function()
    return d.current
  end
  d.exec_autocmds = function(event, opts)
    d.exec_calls[#d.exec_calls + 1] = { event = event, opts = opts }
    if not d.exec_ok then
      error 'no autocmd group'
    end
    return 0
  end
  d.notify = function(msg, level, opts)
    d.notify_calls[#d.notify_calls + 1] = { msg = msg, level = level, opts = opts }
  end
  d.info_level = INFO
  for k, v in pairs(overrides or {}) do
    if v ~= nil then
      d[k] = v
    end
  end
  return d
end

-- Lazy image getter: never resolved at build time (Snacks nil while spec loads).
local early = toggle_deps()
-- (deliberately do NOT call setup/toggle first — assert no eager resolution happened)
check('image getter is lazy (no resolution before any call)', early.image_queries == nil or early.image_queries == 0)

-- setup_patch idempotency + wrap correctness.
local d = toggle_deps()
local t = util.inline_image_toggle(d)
local orig = d.doc.find_visible

t.setup_patch()
check('patch: state.patched true', t.state.patched == true)
check('patch: saved original identity', t.state.original == orig)
check('patch: wrapping replaced find_visible', d.doc.find_visible ~= orig)

t.setup_patch()
check('patch: second call is a no-op (find_visible unchanged)', d.doc.find_visible ~= orig)
local second_orig_ref = d.doc.find_visible
t.setup_patch()
check('patch: repeated setup keeps the same wrapper', d.doc.find_visible == second_orig_ref)

-- Hidden buffer: short-circuits to callback{} and never calls original.
local cb_ran = {}
local d1 = toggle_deps()
local t1 = util.inline_image_toggle(d1)
t1.setup_patch()
d1.bvar[7] = { snacks_image_hidden = true }
local hidden = d1.doc.find_visible(7, function(payload)
  cb_ran = payload
end)
check('patch: hidden buffer calls callback with empty table', eq(cb_ran, {}))
check('patch: hidden buffer returns nil (original bypassed)', hidden == nil)

-- Visible buffer: forwards to original and returns its value.
local d2 = toggle_deps()
local t2 = util.inline_image_toggle(d2)
t2.setup_patch()
local ret = d2.doc.find_visible(9, function() end)
check('patch: visible buffer forwards to original', ret == 'FOUND:9')

-- refresh: success path calls exec_autocmds with exact opts, no attach.
local d3 = toggle_deps()
local t3 = util.inline_image_toggle(d3)
t3.refresh(42)
check(
  'refresh: exec_autocmds called once with exact args',
  eq(d3.exec_calls, {
    { event = 'BufWinEnter', opts = { group = 'snacks.image.inline.42', buffer = 42, modeline = false } },
  })
)
check('refresh: no attach on success', #d3.attach_calls == 0)

-- refresh: autocmd raises + visible -> attach buffer.
local d4 = toggle_deps()
d4.exec_ok = false
local t4 = util.inline_image_toggle(d4)
t4.refresh(55)
check('refresh: attaches buffer when autocmd group missing + visible', eq(d4.attach_calls, { 55 }))

-- refresh: autocmd raises + hidden -> do NOT attach.
local d5 = toggle_deps()
d5.exec_ok = false
d5.bvar[55] = { snacks_image_hidden = true }
local t5 = util.inline_image_toggle(d5)
t5.refresh(55)
check('refresh: no attach when buffer hidden', #d5.attach_calls == 0)

-- toggle: hiding (flag started nil) flips to true, notifies "disabled", refreshes.
local d6 = toggle_deps()
d6.current = 3
local t6 = util.inline_image_toggle(d6)
t6.toggle()
check('toggle(hide): sets snacks_image_hidden=true', d6.bvar[3]['snacks_image_hidden'] == true)
check(
  'toggle(hide): notifies disabled message at info level',
  eq(d6.notify_calls, {
    { msg = 'Inline images disabled for current buffer', level = INFO, opts = { title = 'Snacks.image' } },
  })
)
check('toggle(hide): refreshed current buffer', d6.exec_calls[1] and d6.exec_calls[1].opts.buffer == 3)
check('toggle(hide): applied the patch (find_visible wrapped)', d6.doc.find_visible ~= nil)

-- toggle: showing (flag started true) flips to false, notifies "enabled".
local d7 = toggle_deps()
d7.current = 4
d7.bvar[4] = { snacks_image_hidden = true }
local t7 = util.inline_image_toggle(d7)
t7.toggle()
check('toggle(show): sets snacks_image_hidden=false', d7.bvar[4]['snacks_image_hidden'] == false)
check('toggle(show): notifies enabled message', d7.notify_calls[1] and d7.notify_calls[1].msg == 'Inline images enabled for current buffer')

-- toggle twice: hide then show, flags toggled independently.
local d8 = toggle_deps()
d8.current = 6
local t8 = util.inline_image_toggle(d8)
t8.toggle()
t8.toggle()
check('toggle: two calls flip back to false', d8.bvar[6]['snacks_image_hidden'] == false)

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
