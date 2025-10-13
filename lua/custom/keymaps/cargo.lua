local map = vim.api.nvim_set_keymap

-- Core Commands
map('n', '<leader>Cb', '<CMD>CargoBench<CR>', { desc = '📊 Run benchmarks' })
map('n', '<leader>CB', '<CMD>CargoBuild<CR>', { desc = '🏗️ Build the project' })
map('n', '<leader>Cc', '<CMD>CargoClean<CR>', { desc = '🧹 Remove generated artifacts' })
map('n', '<leader>Cd', '<CMD>CargoDoc<CR>', { desc = '📚 Generate project documentation' })
map('n', '<leader>CN', '<CMD>CargoNew<CR>', { desc = '✨ Create a new Cargo project' })
map('n', '<leader>CR', '<CMD>CargoRun<CR>', { desc = '▶️ Run the project in a floating window' })
map('n', '<leader>Cr', '<CMD>CargoRunTerm<CR>', { desc = '📟 Run the project in terminal mode' })
map('n', '<leader>Ct', '<CMD>CargoTest<CR>', { desc = '🧪 Run tests' })
map('n', '<leader>Cu', '<CMD>CargoUpdate<CR>', { desc = '🔄 Update dependencies' })

-- Additional Commands
map('n', '<leader>Ck', '<CMD>CargoCheck<CR>', { desc = '🔍 Check the project for errors' })
map('n', '<leader>Cp', '<CMD>CargoClippy<CR>', { desc = '📋 Run the Clippy linter' })
map('n', '<leader>Ca', ':CargoAdd ', { desc = '➕ Add dependency' })
map('n', '<leader>Cx', ':CargoRemove ', { desc = '➖ Remove dependency' })
map('n', '<leader>Cf', '<CMD>CargoFmt<CR>', { desc = '🎨 Format code with rustfmt' })
map('n', '<leader>CF', '<CMD>CargoFix<CR>', { desc = '🔧 Auto-fix warnings' })
map('n', '<leader>CP', '<CMD>CargoPublish<CR>', { desc = '📦 Publish package' })
map('n', '<leader>CI', ':CargoInstall ', { desc = '📥 Install binary' })
map('n', '<leader>CU', ':CargoUninstall ', { desc = '📤 Uninstall binary' })
map('n', '<leader>CS', ':CargoSearch ', { desc = '🔎 Search packages' })
map('n', '<leader>CT', '<CMD>CargoTree<CR>', { desc = '🌲 Show dependency tree' })
map('n', '<leader>CV', '<CMD>CargoVendor<CR>', { desc = '📦 Vendor dependencies' })
map('n', '<leader>CA', '<CMD>CargoAudit<CR>', { desc = '🛡️ Audit dependencies' })
map('n', '<leader>CO', '<CMD>CargoOutdated<CR>', { desc = '📊 Check outdated dependencies' })
map('n', '<leader>CD', '<CMD>CargoAutodd<CR>', { desc = '🤖 Automatically manage dependencies' })
