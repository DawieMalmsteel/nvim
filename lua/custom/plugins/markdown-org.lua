return {
  'Kurama622/markdown-org',
  ft = 'markdown',
  lazy = false,
  config = function()
    vim.g.language_path = {
      python = 'python',
      python3 = 'python3',
      javascript = 'node',
      go = 'go',
      c = 'gcc -Wall',
      cpp = 'g++ -std=c++11 -Wall',
      bash = 'bash',
      cs = 'tee temp.csx | dotnet-script temp.csx && rm temp.csx',
      fsharp = 'tee temp.fsx | dotnet fsi temp.fsx && rm temp.fsx',
      rust = 'tee temp.rs | rustc temp.rs -o temp && ./temp && rm temp temp.rs',
      -- fsharp = 'dotnet fsi',
      ['c++'] = 'g++ -std=c++11 -Wall',
    }
    return {
      default_quick_keys = 0,
      vim.api.nvim_set_var('org#style#border', 2),
      vim.api.nvim_set_var('org#style#bordercolor', 'FloatBorder'),
      vim.api.nvim_set_var('org#style#color', 'String'),
    }
  end,
  keys = {
    { '<leader>Mr', '<cmd>call org#main#runCodeBlock()<cr>' },
    { '<leader>Ml', '<cmd>call org#main#runLanguage()<cr>' },
  },
}
