-- non-plugin settings
require("remap")
require("settings")

-- lazy package manager setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- finder
    {
        "nvim-telescope/telescope.nvim", tag = "0.1.5",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" }
    },
    -- theme
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    -- add indent lines
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            disable_filetype= {"TelescopePrompt"}
        } -- this is equalent to setup({}) function
    },
    -- commenter
    {
        "numToStr/Comment.nvim",
        opts = {
            toggler = {line = "<leader>cc"},
            opleader = {line = "<leader>cc"}
        },
        lazy = false,
    },
    -- search and replacer
    -- https://github.com/nvim-pack/nvim-spectre
    {
        "nvim-pack/nvim-spectre",
        event = "InsertEnter",
        dependencies = {"nvim-tree/nvim-web-devicons"}
    },
    -- syntax highlighter and stuff
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = { "python", "lua", "vim", "javascript", "html", "toml"},
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
        })
        end
    },
    -- lsp
    -- https://github.com/neovim/nvim-lspconfig
    -- lsp package manager
    -- https://github.com/williamboman/mason-lspconfig.nvim
    {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig"
    },
    -- completion
    {
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp-signature-help"
    },
    -- completion snippets
    {
        "L3MON4D3/LuaSnip",
        event = { "InsertEnter", "CmdlineEnter" }
    },
    -- html auto tags
    -- https://github.com/windwp/nvim-ts-autotag
    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter"
    }
})
-- end lazy package manager setup

-- lsp stuff
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = {
        "lua_ls",
        "ruff_lsp",
        "pyright",
        "tailwindcss",
        "htmx",
        "tsserver",
        "html"
    },
    automatic_installation = false
}
local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup {
   settings = {
       Lua = {
           diagnostics = {
               globals = { "vim" }
           },
           telemetry = {enable = false}
       }
   }
}
local function border(hl_name)
    return {
        {"╭", hl_name}, {"─", hl_name}, {"╮", hl_name}, {"│", hl_name},
        {"╯", hl_name}, {"─", hl_name}, {"╰", hl_name}, {"│", hl_name}
    }
end
local luasnip = require("luasnip")
local cmp = require("cmp")
cmp.setup({
    window = {
        completion = {
            border = border "CmpBorder",
            winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None"
        },
        documentation = {border = border "CmpDocBorder"}
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, {"i", "s"}),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {"i", "s"})
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnips" },
        { name = "buffer" },
        { name = "nvim_lsp_signature_help" },
        { name = "path" },
    },
})
local capabilities = require("cmp_nvim_lsp").default_capabilities()
lspconfig.ruff_lsp.setup { capabilities=capabilities }
lspconfig.pyright.setup { capabilities=capabilities }
lspconfig.tailwindcss.setup { capabilities=capabilities }
lspconfig.htmx.setup { capabilities=capabilities }
lspconfig.tsserver.setup { capabilities=capabilities }
lspconfig.html.setup { capabilities=capabilities }

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
-- end lsp stuff

-- html auto tags
require("nvim-ts-autotag").setup({
  filetypes = { "html" , "xml" },
})
-- end html auto tags

-- theme
require("catppuccin").setup({
    transparent_background = true
})
vim.cmd.colorscheme "catppuccin"

-- telescope
require("telescope").setup({
    pickers = {
		find_files = {
			-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
		},
	},
})
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, {})
vim.keymap.set('n', '<leader>f', telescope_builtin.find_files, {})
vim.keymap.set('n', '<C-f>', function()
    -- Handling error to output 1 line instead of several
    if pcall(telescope_builtin.git_files) then
    else
        print("Not a git project. Try running git init in root.")
    end
end)

-- commenter
local ft = require('Comment.ft')
ft.set("typescriptreact", "{/* %s */}")

-- nvim spectre search and replace
vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre"
})
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word"
})
