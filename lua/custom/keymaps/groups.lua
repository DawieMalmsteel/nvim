local map = require('custom.keymaps.core').map

-- Khai báo nhóm cho which-key (giữ nguyên như cũ)
local groups = {
  ['<leader>c'] = '+code',
  ['<leader>a'] = '+ai',
  ['<leader>f'] = '+find',
  ['<leader>g'] = '+git',
  ['<leader>u'] = '+ui',
  ['<leader>q'] = '+quit',
  ['<leader>t'] = '+toggles',
  ['<leader>s'] = '+search',
  gr = '+LSP',
  ['<leader>m'] = '+mark group',
  ['<leader>b'] = '+buffers',
  ['<leader>d'] = '+debug',
  ['<leader>r'] = '+refactor',
  ['<leader>N'] = '+notes',
  ['<leader>O'] = '+Obsidian',
  ['<leader>M'] = '+markdown org',
  ['<leader>v'] = '+visits',
}

for lhs, desc in pairs(groups) do
  map({ 'n', 'v' }, lhs, '', { desc = desc })
end
