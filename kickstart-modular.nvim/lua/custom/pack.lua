-- Helpers for the vim.pack-based plugin modules in lua/custom/plugins/.
--
-- Plugins are loaded eagerly (no lazy-loading). `confirm = false` keeps the
-- first-run install from prompting once per plugin.

local M = {}

--- Build a GitHub plugin source string.
---@param repo string e.g. 'folke/snacks.nvim'
---@return string
function M.gh(repo)
  return 'https://github.com/' .. repo
end

--- Add plugins to the current session and load them right away.
---@param specs (string|vim.pack.Spec)[]
function M.add(specs)
  vim.pack.add(specs, { confirm = false, load = true })
end

return M
