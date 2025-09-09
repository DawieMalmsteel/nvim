-- Keymaps được tách module để dễ bảo trì.
-- Thêm/bớt nhóm chỉ cần chỉnh danh sách modules bên dưới.
local modules = {
  'custom.keymaps.core', -- helpers phải nạp đầu
  'custom.keymaps.groups', -- khai báo nhóm (<leader>c ... )
  'custom.keymaps.editing',
  'custom.keymaps.files',
  'custom.keymaps.git',
  'custom.keymaps.diagnostics',
  'custom.keymaps.lsp',
  'custom.keymaps.search',
  'custom.keymaps.ui',
  'custom.keymaps.buffers',
  'custom.keymaps.extras', -- bổ sung (window nav, oldfiles, plugin spec, buffer picker xoá,...)
  'custom.keymaps.refactor',
  'custom.keymaps.terminal',
  'custom.keymaps.misc',
}

for _, m in ipairs(modules) do
  local ok, err = pcall(require, m)
  if not ok then
    vim.schedule(function()
      vim.notify('Không nạp được keymaps module: ' .. m .. ' -> ' .. err, vim.log.levels.WARN)
    end)
  end
end
