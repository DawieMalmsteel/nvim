return {
  'Kurama622/markdown-org',
  ft = 'markdown',
  lazy = false,
  config = function()
    vim.g.language_path = {
      python = 'python',
      python3 = 'python3',
      go = 'go',
      c = 'gcc -Wall',
      cpp = 'g++ -std=c++11 -Wall',
      bash = 'bash',
      lua = 'lua',

      javascript = 'cat > v21L0nKoNCkoz.js && bun run v21L0nKoNCkoz.js; rm -f v21L0nKoNCkoz.js',
      js = 'cat > v21L0nKoNCkoz.js && bun run v21L0nKoNCkoz.js; rm -f v21L0nKoNCkoz.js',
      typescript = 'cat > v21L0nKoNCkoz.ts && bun run v21L0nKoNCkoz.ts; rm -f v21L0nKoNCkoz.ts',
      ts = 'cat > v21L0nKoNCkoz.ts && bun run v21L0nKoNCkoz.ts; rm -f v21L0nKoNCkoz.ts',

      cs = 'cat > v21L0nKoNCkoz.csx && dotnet-script v21L0nKoNCkoz.csx; rm -f v21L0nKoNCkoz.csx',
      fsharp = 'cat > v21L0nKoNCkoz.fsx && dotnet fsi v21L0nKoNCkoz.fsx; rm -f v21L0nKoNCkoz.fsx',
      rust = 'cat > v21L0nKoNCkoz.rs && rustc v21L0nKoNCkoz.rs -o v21L0nKoNCkoz && ./v21L0nKoNCkoz; rm -f v21L0nKoNCkoz v21L0nKoNCkoz.rs',
      ocaml = 'cat > v21L0nKoNCkoz.ml && ocaml v21L0nKoNCkoz.ml; rm -f v21L0nKoNCkoz.ml',
      java = 'cat > Main.java && javac Main.java && java Main; rm -f Main.java Main.class',

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
    { '<leader>mr', '<cmd>call org#main#runCodeBlock()<cr>', desc = 'Run code block' },
    { '<leader>ml', '<cmd>call org#main#runLanguage()<cr>', desc = 'Run code block language' },
  },
}
