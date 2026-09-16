-- Snacks helper logic extracted from the plugin spec so it can be unit-tested
-- with injected dependencies (no live nvim / Snacks required). The plugin spec
-- in lua/plugins/snacks.lua provides the real bindings.

local M = {}

--- Working directory for pickers/lazygit: the directory of the current buffer
--- when it is a readable saved file, otherwise the process cwd.
--- @param deps table|nil with:
---   buf_get_name: fun(bufnr?): string (reads the given/current buffer)
---   filereadable: fun(path): boolean
---   fnamemodify:  fun(path, mod): string
---   uv_cwd:       fun(): string
--- @return string
function M.cwd(deps)
  deps = deps
    or {
      buf_get_name = function()
        return vim.api.nvim_buf_get_name(0)
      end,
      filereadable = function(path)
        return vim.fn.filereadable(path) == 1
      end,
      fnamemodify = function(path, mod)
        return vim.fn.fnamemodify(path, mod)
      end,
      uv_cwd = function()
        return vim.uv.cwd()
      end,
    }

  local file = deps.buf_get_name(0)
  if file ~= '' and deps.filereadable(file) then
    return deps.fnamemodify(file, ':h')
  end
  return deps.uv_cwd()
end

--- Build a buffer-scoped inline-image toggle over injected `deps`.
---
--- Mechanics: wrap Snacks.image.doc.find_visible so a buffer flagged with
--- `vim.b[buf].snacks_image_hidden` renders no images. Toggling flips the flag,
--- then re-triggers the per-buffer BufWinEnter autocmd (or attaches the image
--- doc when the buffer was never attached) and notifies the user.
---
--- `deps.image` is a function resolved lazily on each use, so it may reference
--- the `Snacks` global safely even though it is nil while the plugin spec loads.
--- @param deps table:
---   image:           fun(): module with `.doc.find_visible` / `.doc.attach`
---   get_bvar:        fun(buf, key): any
---   set_bvar:        fun(buf, key, value)
---   get_current_buf: fun(): bufnr
---   exec_autocmds:   fun(event, opts): unknown  (may raise)
---   notify:          fun(msg, level, opts)
---   info_level:      any
--- @return table { toggle(), refresh(buf), setup_patch(), state }
function M.inline_image_toggle(deps)
  local state = { patched = false, original = nil }

  local function image_doc()
    return deps.image().doc
  end

  --- Wrap find_visible once (idempotent). Returns the state object.
  local function setup_patch()
    if state.patched then
      return state
    end

    local doc = image_doc()
    state.original = doc.find_visible
    doc.find_visible = function(buf, callback)
      if deps.get_bvar(buf, 'snacks_image_hidden') then
        callback {}
        return
      end
      return state.original(buf, callback)
    end

    state.patched = true
    return state
  end

  --- Ask Snacks to redraw this buffer's inline images.
  local function refresh(buf)
    local group = 'snacks.image.inline.' .. buf
    local ok = pcall(deps.exec_autocmds, 'BufWinEnter', {
      group = group,
      buffer = buf,
      modeline = false,
    })

    -- Buffer was never attached to images: attach it (unless hidden).
    if not ok and not deps.get_bvar(buf, 'snacks_image_hidden') then
      image_doc().attach(buf)
    end
  end

  --- Flip the hide flag for the current buffer and re-render.
  local function toggle()
    setup_patch()

    local buf = deps.get_current_buf()
    -- When currently hidden, this toggle re-shows.
    local show_images = deps.get_bvar(buf, 'snacks_image_hidden') == true

    deps.set_bvar(buf, 'snacks_image_hidden', not show_images)

    refresh(buf)

    deps.notify(
      show_images and 'Inline images enabled for current buffer' or 'Inline images disabled for current buffer',
      deps.info_level,
      { title = 'Snacks.image' }
    )
  end

  return {
    toggle = toggle,
    refresh = refresh,
    setup_patch = setup_patch,
    state = state,
  }
end

return M
