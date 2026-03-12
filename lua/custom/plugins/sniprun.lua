return {
  'michaelb/sniprun',
  build = 'sh install.sh',
  opts = {
    display = {
      -- 'Classic', --# display results in the command-line  area
      -- 'VirtualTextOk', --# display ok results as virtual text (multiline is shortened)

      -- "VirtualText",             --# display results as virtual text
      -- 'VirtualLine', --# display results as virtual lines
      -- "TempFloatingWindow",      --# display results in a floating window
      -- "LongTempFloatingWindow",  --# same as above, but only long results. To use with VirtualText[Ok/Err]
      'Terminal', --# display results in a vertical split
      -- "TerminalWithCode",        --# display results and code history in a vertical split
      -- "NvimNotify",              --# display with the nvim-notify plugin
      -- "Api"                      --# return output to a programming interface
    },
    live_mode_toggle = 'on',
    repl_enable = { 'Python3_original' },
    selected_interpreters = { 'CSharp_original' },
    interpreter_options = {
      TypeScript_original = {
        interpreter = 'node', -- Note: sudo npm install -g ts-node typescript
      },
      Python3_original = {
        interpreter = 'python3.14',
        venv = { 'venv_project1', 'venv_project2', '../venv_project2' },
      },
    },
  },
}
