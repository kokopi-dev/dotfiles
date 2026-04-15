vim.loader.enable()

-- pack hooks/commands should be defined before plugin modules run
require("commands.pack").setup()

-- editor settings and non-plugin keymaps
require("settings.options")
require("settings.keymaps")

-- plugins
require("plugins.catppuccin").setup()
require("plugins.lsp").setup()
require("plugins.cmp").setup()
require("plugins.treesitter").setup()
require("plugins.telescope").setup_keymaps()
require("plugins.mini").setup()
require("plugins.ui").setup()
require("plugins.autotag").setup()
require("plugins.error-viewer").setup()
require("plugins.search-replace").setup()
require("plugins.ai").setup()
