-- set language based on vim mode
-- requires macism https://github.com/laishulu/macism
-- recommend installing it by brew
local sysname = vim.uv.os_uname().sysname
local is_mac = sysname == 'Darwin'
local is_linux = sysname == 'Linux'

if is_mac then
  local english_layout = 'com.apple.keylayout.ABC'
  local last_insert_layout = english_layout

  local function get_current_layout()
    local f = io.popen 'macism'
    local layout = nil
    if f ~= nil then
      layout = f:read('*all'):gsub('\n', '')
      f:close()
    end
    print(layout)
    return layout
  end

  vim.api.nvim_create_autocmd('InsertLeave', {
    callback = function()
      last_insert_layout = get_current_layout()
      os.execute('macism ' .. english_layout)
    end,
  })

  vim.api.nvim_create_autocmd({ 'CmdlineEnter' }, {
    callback = function()
      os.execute('macism ' .. english_layout)
    end,
  })

  vim.api.nvim_create_autocmd('InsertEnter', {
    callback = function()
      os.execute('macism ' .. last_insert_layout)
    end,
  })

  vim.api.nvim_create_autocmd('FocusGained', {
    callback = function()
      if vim.fn.mode() == 'i' then
        os.execute('macism ' .. last_insert_layout)
      else
        os.execute('macism ' .. english_layout)
      end
    end,
  })
elseif is_linux then
  local last_layout = 'keyboard-us' -- English is default

  local function get_fcitx_layout()
    local f = io.popen 'fcitx5-remote -n'
    if f ~= nil then
      local result = f:read '*all'
      f:close()
      if result then
        return result:gsub('%s+', '')
      end
    end
    return 'keyboard-us' -- fallback English
  end

  local function set_fcitx_layout(layout)
    os.execute('fcitx5-remote -s ' .. layout)
  end

  vim.api.nvim_create_autocmd('InsertLeave', {
    callback = function()
      last_layout = get_fcitx_layout()
      set_fcitx_layout 'keyboard-us' -- change to English
    end,
  })

  vim.api.nvim_create_autocmd('InsertEnter', {
    callback = function()
      set_fcitx_layout(last_layout)
    end,
  })

  vim.api.nvim_create_autocmd('FocusGained', {
    callback = function()
      if vim.fn.mode() == 'i' then
        set_fcitx_layout(last_layout)
      else
        set_fcitx_layout 'keyboard-us'
      end
    end,
  })
  -- Custom keymaps to trigger layout switching
  vim.keymap.set('i', '<C-c>', function()
    if is_mac then
      last_insert_layout = get_current_layout()
      os.execute('macism ' .. english_layout)
    elseif is_linux then
      last_layout = get_fcitx_layout()
      set_fcitx_layout 'keyboard-us'
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, false, true), 'n', true)
  end, { noremap = true, silent = true })

  vim.keymap.set('i', 'kj', function()
    if is_mac then
      last_insert_layout = get_current_layout()
      os.execute('macism ' .. english_layout)
    elseif is_linux then
      last_layout = get_fcitx_layout()
      set_fcitx_layout 'keyboard-us'
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<ESC>', true, false, true), 'n', true)
  end, { noremap = true, silent = true })
end
