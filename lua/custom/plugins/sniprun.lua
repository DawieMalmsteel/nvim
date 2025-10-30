return {
  'michaelb/sniprun',
  build = 'sh install.sh',
  opts = {
    interpreter_options = {
      TypeScript_original = {
        interpreter = 'node', -- NOTE: sudo npm install -g ts-node typescript
      },
    },
  },
}
