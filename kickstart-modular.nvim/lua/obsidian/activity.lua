-- Obsidian daily activity log: append "- HH:MM [[note]]" to Dailies/<day>.md on save.
--
-- The whole module is dependency-injected (pure string/list transforms + explicit
-- `deps` for filesystem/buffer access and time) so it can be unit-tested under
-- plain Lua without a live nvim. The plugin spec in lua/plugins/obsidian.lua
-- supplies the real `deps` wired to vim APIs (buffers, files) and os.date.

local M = {}

--- Normalize "YYYY-MM-DD" to "YYYY-MM-DDTHH:MM:SS"; pass ISO timestamps through.
--- Any other value (nil, other shapes) is returned unchanged.
--- @param value any
--- @return any
function M.normalize_day(value)
  if type(value) == 'string' then
    if value:match '^%d%d%d%d%-%d%d%-%d%dT%d%d:%d%d:%d%d$' then
      return value
    end

    local year, month, day = value:match '^(%d%d%d%d)%-(%d%d)%-(%d%d)$'
    if year then
      return string.format('%s-%s-%sT00:00:00', year, month, day)
    end
  end
  return value
end

--- Build the template daily-note body. `template_lines` is nil when no
--- template file exists, in which case a portable fallback is returned.
--- Placeholders `{{date:DD-MM-YYYY}}` and `{{date}}` are filled from `day`
--- and `timestamp`. The original array is not mutated.
--- @param template_lines string[]|nil
--- @param day string
--- @param timestamp string
--- @return string[]
function M.template_lines(template_lines, day, timestamp)
  if template_lines then
    local out = {}
    for _, line in ipairs(template_lines) do
      out[#out + 1] = line:gsub('{{date:DD%-MM%-YYYY}}', day):gsub('{{date}}', timestamp)
    end
    return out
  end

  return {
    '---',
    'tags: [daily]',
    'created_day: ' .. timestamp,
    'updated_day: ' .. timestamp,
    '---',
    '',
    '# ' .. day,
    '',
    '## Activity',
    '',
  }
end

--- Insert `- <time> [[note]]` under the `## Activity` heading, if the link is
--- not already present anywhere in the note.
--- Returns the new `lines` array on success, or nil when the link is already
--- recorded (no change → caller should not write). `lines` is mutated in place
--- so callers may reuse it; a fresh heading is appended when one is missing.
--- @param lines string[]
--- @param note_name string
--- @param time string
--- @return string[]|nil
function M.append_activity(lines, note_name, time)
  local link = '[[' .. note_name .. ']]'
  for _, line in ipairs(lines) do
    if line:find(link, 1, true) then
      return nil
    end
  end

  local heading
  for index, line in ipairs(lines) do
    if line == '## Activity' then
      heading = index
      break
    end
  end

  if heading == nil then
    lines[#lines + 1] = ''
    lines[#lines + 1] = '## Activity'
    heading = #lines
  end

  table.insert(lines, heading + 1, '- ' .. time .. ' ' .. link)
  return lines
end

--- Decide whether `file_path` should be logged and what its `note_name` is.
--- A path is skipped when it is not markdown, lies outside the vault `root`,
--- or sits in an ignored folder.
--- @param file_path string absolute, normalized path inside the vault
--- @param root string absolute vault root (no trailing slash)
--- @param ignored table<string, true>
--- @return string|false relative path when handled, false otherwise
local function handled_relative(file_path, root, ignored)
  if file_path:sub(-3) ~= '.md' then
    return false
  end
  -- Inside strictly: exactly the root, or the root followed by a separator.
  -- A bare prefix test would wrongly admit siblings like /vault-other.
  local inside = file_path == root or file_path:sub(1, #root + 1) == root .. '/'
  if not inside then
    return false
  end

  local relative = file_path:sub(#root + 2)
  local folder = relative:match '^([^/]+)'
  if folder and ignored[folder] then
    return false
  end
  return relative
end

--- Run the full daily-activity flow for one saved file.
-- @param deps object with:
--   root string                  absolute vault root (no trailing slash)
--   daily_dir string             absolute Dailies directory
--   day_format string            os.date format for the daily filename
--   iso_format string            os.date format for created/updated timestamps
--   time_format string           os.date format for the activity entry time
--   ignored table<string, true>  folders excluded from the log
--   read_daily fun(path): string[]|nil   contents of an existing daily note
--   write_daily fun(path, lines)         persist updated daily note
--   read_template fun(): string[]|nil    raw template file lines
--   ensure_daily_dir fun()               create the Dailies directory
-- @param file_path string absolute path of the just-saved file
-- @param now fun(format: string): string date provider (default os.date)
-- @return string 'appended' | 'duplicate' | 'outside' | 'ignored'
function M.append(deps, file_path, now)
  local relative = handled_relative(file_path, deps.root, deps.ignored)
  if relative == false then
    return 'ignored'
  end

  local day = now(deps.day_format)
  local timestamp = now(deps.iso_format)
  local daily_path = deps.daily_dir .. '/' .. day .. '.md'
  local note_name = file_path:match '([^/]+)%.md$'

  local lines = deps.read_daily(daily_path)
  if lines == nil then
    deps.ensure_daily_dir()
    lines = M.template_lines(deps.read_template(), day, timestamp)
  end

  local result = M.append_activity(lines, note_name, now(deps.time_format))
  if result == nil then
    return 'duplicate'
  end

  deps.write_daily(daily_path, result)
  return 'appended'
end

return M
