local function cwd()
  local file = vim.api.nvim_buf_get_name(0)
  if file ~= '' and vim.fn.filereadable(file) == 1 then
    return vim.fn.fnamemodify(file, ':h')
  end
  return vim.uv.cwd()
end

return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true },
    input = { enabled = true },
    lazygit = { enabled = true },
    notifier = { enabled = true, timeout = 3000 },
    picker = {
      enabled = true,
      ui_select = true,
      layout = {
        preset = 'default',
      },
    },
    quickfile = { enabled = true },
    scratch = {
      width = 100,
      height = 30,
      position = 'right',
    },
    statuscolumn = { enabled = true },
    terminal = {
      win = { position = 'float' },
    },
    words = { enabled = true },
    zen = { enabled = true },
  },
  keys = {
    -- top-level picker/explorer
    { '<leader><space>', function() Snacks.picker.smart() end, desc = 'Smart Find Files' },
    -- { '<leader><leader>', function() Snacks.picker.files { cwd = cwd() } end, desc = 'Files Near Buffer' },
    { '<leader>/', function() Snacks.picker.lines() end, desc = 'Buffer Lines' },
    { '<leader>;', function() Snacks.picker.command_history() end, desc = 'Command History' },
    { '<leader>T', function() Snacks.explorer() end, desc = 'Explorer' },
    { '<leader>e', function() Snacks.explorer() end, desc = 'Explorer' },
    { '<leader>O', function() Snacks.picker.recent() end, desc = 'Recent Files' },
    { '<leader>r', function() Snacks.picker.buffers() end, desc = 'Buffers' },

    -- find
    { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers' },
    { '<leader>fc', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = 'Config Files' },
    { '<leader>ff', function() Snacks.picker.files { cwd = cwd() } end, desc = 'Find Files' },
    { '<leader>fF', function() Snacks.picker.buffers { hidden = true, nofile = true } end, desc = 'All Buffers' },
    { '<leader>fg', function() Snacks.picker.grep { cwd = cwd(), live = true } end, desc = 'Live Grep' },
    { '<leader>fG', function() Snacks.picker.git_files() end, desc = 'Git Files' },
    { '<leader>fp', function() Snacks.picker.projects() end, desc = 'Projects' },
    { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent Files' },
    { '<leader>f"', function() Snacks.picker.registers() end, desc = 'Registers' },
    { "<leader>f'", function() Snacks.picker.marks() end, desc = 'Marks' },
    { '<leader>f/', function() Snacks.picker.search_history() end, desc = 'Search History' },
    { '<leader>f:', function() Snacks.picker.command_history() end, desc = 'Command History' },
    { '<leader>f;', function() Snacks.picker.command_history() end, desc = 'Command History' },

    -- search
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = 'Search History' },
    { '<leader>sB', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers' },
    { '<leader>sc', function() Snacks.picker.commands() end, desc = 'Commands' },
    { '<leader>sD', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics' },
    { '<leader>sd', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics' },
    { '<leader>sG', function() Snacks.picker.grep { cwd = vim.env.PWD or vim.uv.cwd(), live = true } end, desc = 'Grep Global' },
    { '<leader>sg', function() Snacks.picker.grep { cwd = cwd(), live = true } end, desc = 'Grep' },
    { '<leader>sH', function() Snacks.picker.help() end, desc = 'Help Pages' },
    { '<leader>si', function() Snacks.picker.icons() end, desc = 'Icons' },
    { '<leader>sj', function() Snacks.picker.jumps() end, desc = 'Jumps' },
    { '<leader>sk', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
    { '<leader>sM', function() Snacks.picker.man() end, desc = 'Man Pages' },
    { '<leader>sm', function() Snacks.picker.marks() end, desc = 'Marks' },
    { '<leader>sR', function() Snacks.picker.resume() end, desc = 'Resume' },
    { '<leader>sr', function() Snacks.picker.resume() end, desc = 'Resume' },
    { '<leader>ss', function() Snacks.picker.lsp_symbols() end, desc = 'LSP Symbols' },
    { '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'LSP Workspace Symbols' },
    { '<leader>su', function() Snacks.picker.undo() end, desc = 'Undo History' },
    { '<leader>sW', function() Snacks.picker.grep_word() end, desc = 'Grep Word', mode = { 'n', 'x' } },

    -- git
    { '<leader>ga', '<cmd>Git add %<cr>', desc = 'Git Add Current File' },
    { '<leader>gA', '<cmd>Git add .<cr>', desc = 'Git Add All' },
    { '<leader>gb', function() Snacks.picker.git_branches() end, desc = 'Git Branches' },
    { '<leader>gB', function() Snacks.picker.git_branches { layout = 'select', cwd = cwd() } end, desc = 'Git Branches' },
    { '<leader>gd', function() Snacks.picker.git_diff { cwd = cwd() } end, desc = 'Git Diff' },
    { '<leader>gF', function() Snacks.picker.git_log_file { cwd = cwd() } end, desc = 'Git Log File' },
    { '<leader>gG', function() Snacks.lazygit { cwd = cwd() } end, desc = 'Lazygit' },
    { '<leader>gl', function() Snacks.lazygit.log { cwd = cwd() } end, desc = 'Lazygit Log' },
    { '<leader>gL', function() Snacks.picker.git_log_line() end, desc = 'Git Log Line' },
    { '<leader>gs', function() Snacks.picker.git_status { cwd = cwd() } end, desc = 'Git Status' },
    { '<leader>gS', function() Snacks.picker.git_stash { cwd = cwd() } end, desc = 'Git Stash' },

    -- lsp/navigation
    { 'grd', function() Snacks.picker.lsp_definitions() end, desc = 'LSP Definitions' },
    { 'grD', function() Snacks.picker.lsp_declarations() end, desc = 'LSP Declarations' },
    { 'gri', function() Snacks.picker.lsp_implementations() end, desc = 'LSP Implementations' },
    { 'grr', function() Snacks.picker.lsp_references() end, desc = 'LSP References' },
    { 'grt', function() Snacks.picker.lsp_type_definitions() end, desc = 'LSP Type Definitions' },
    { 'gO', function() Snacks.picker.lsp_symbols() end, desc = 'Document Symbols' },
    { 'gW', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'Workspace Symbols' },
    { 'grN', function() Snacks.rename.rename_file() end, desc = 'Rename File' },
    { 'grI', function() Snacks.picker.lsp_incoming_calls() end, desc = 'Incoming Calls' },
    { 'grO', function() Snacks.picker.lsp_outgoing_calls() end, desc = 'Outgoing Calls' },
    { ']]', function() Snacks.words.jump(vim.v.count1) end, desc = 'Next Reference', mode = { 'n', 't' } },
    { '[[', function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev Reference', mode = { 'n', 't' } },

    -- buffers/ui/tools
    { '<leader>.', function() Snacks.scratch() end, desc = 'Scratch Buffer' },
    { '<leader>,', function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer' },
    { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer' },
    { '<leader>n', function() Snacks.picker.notifications() end, desc = 'Notification History' },
    { '<leader>uc', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes' },
    { '<leader>un', function() Snacks.notifier.hide() end, desc = 'Dismiss Notifications' },
    { '<leader>Z', function() Snacks.zen() end, desc = 'Zen' },
    { '<C-/>', function() Snacks.terminal() end, desc = 'Terminal', mode = { 'n', 't' } },
    { '<C-_>', function() Snacks.terminal() end, desc = 'which_key_ignore', mode = { 'n', 't' } },

    -- todo-comments through Snacks picker
    { '<leader>sa', function() Snacks.picker.todo_comments() end, desc = 'All Todo' },
    {
      '<leader>sb',
      function()
        local curr = vim.fn.expand '%:p'
        Snacks.picker.todo_comments {
          transform = function(item)
            return vim.fn.fnamemodify(item.cwd .. '/' .. item.file, ':p') == curr
          end,
        }
      end,
      desc = 'Buffer Todo',
    },
    { '<leader>se', function() Snacks.picker.todo_comments { keywords = { 'ERROR' } } end, desc = 'ERROR' },
    { '<leader>sf', function() Snacks.picker.todo_comments { keywords = { 'FIX' } } end, desc = 'FIX' },
    { '<leader>sh', function() Snacks.picker.todo_comments { keywords = { 'HACK' } } end, desc = 'HACK' },
    { '<leader>sn', function() Snacks.picker.todo_comments { keywords = { 'NOTE' } } end, desc = 'NOTE' },
    { '<leader>sp', function() Snacks.picker.todo_comments { keywords = { 'PERF' } } end, desc = 'PERF' },
    { '<leader>st', function() Snacks.picker.todo_comments { keywords = { 'TODO' } } end, desc = 'TODO' },
    { '<leader>sT', function() Snacks.picker.todo_comments { keywords = { 'TEST' } } end, desc = 'TEST' },
    { '<leader>sw', function() Snacks.picker.todo_comments { keywords = { 'WARN' } } end, desc = 'WARN' },
  },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
      end,
    })
  end,
}
