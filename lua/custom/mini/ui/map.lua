local M = function()
  local mini_map = require 'mini.map'
  mini_map.setup {
    symbols = {
      encode = mini_map.gen_encode_symbols.dot '4x2',
    },
    integrations = {
      mini_map.gen_integration.builtin_search(),
      mini_map.gen_integration.diagnostic {
        error = 'DiagnosticFloatingError',
        warn = 'DiagnosticFloatingWarn',
        info = 'DiagnosticFloatingInfo',
        hint = 'DiagnosticFloatingHint',
      },
      mini_map.gen_integration.diff(),
      mini_map.gen_integration.gitsigns(),
    },
    window = {
      side = 'right',
      width = 10,
      winblend = 80, -- Độ trong suốt, 80 là hợp lý (100 là tàng hình)
      show_integration_count = true,
    },
  }
end
return M
