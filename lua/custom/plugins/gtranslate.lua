return {
  dir = '/home/dwcks/Projects/gtranslate',
  -- this is for local plugin development
  name = 'gtranslate',
  config = function()
    require('gtranslate').setup {
      target_lang = 'vi',
    }
  end,
}
