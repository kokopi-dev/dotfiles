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
    -- icons
    { "nvim-tree/nvim-web-devicons",         lazy = true },
    -- finder
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    -- looks
    { "catppuccin/nvim",                     name = "catppuccin", priority = 1000 },
    { "nvim-lualine/lualine.nvim" },
    { "akinsho/bufferline.nvim",             version = "*" },
    -- add indent lines
    { "lukas-reineke/indent-blankline.nvim", main = "ibl",        opts = {} },
    -- auto brackets
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            disable_filetype = { "TelescopePrompt" },
        }, -- this is equalent to setup({}) function
    },
    -- html auto tags
    -- https://github.com/windwp/nvim-ts-autotag
    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter",
    },
    -- commenter
    {
        "numToStr/Comment.nvim",
        opts = {
            toggler = { line = "<leader>cc" },
            opleader = { line = "<leader>cc" },
        },
        lazy = false,
    },
    -- search and replacer
    -- https://github.com/nvim-pack/nvim-spectre
    {
        "nvim-pack/nvim-spectre",
        event = "InsertEnter",
    },
    -- syntax highlighter and stuff
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = {
                    "python",
                    "lua",
                    "vim",
                    "javascript",
                    "typescript",
                    "html",
                    "htmldjango",
                    "toml",
                    "tsx",
                    "templ",
                    "go",
                    "astro"
                },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
    -- lsp
    -- https://github.com/neovim/nvim-lspconfig
    -- lsp package manager
    -- https://github.com/williamboman/mason-lspconfig.nvim
    {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    },
    -- completion
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp-signature-help",
        },
    },
    -- completion snippets
    {
        "L3MON4D3/LuaSnip",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
        },
    },
    -- formatter
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                -- Customize or remove this keymap to your liking
                "<leader>F",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                sh = { "shfmt" },
                bash = { "shfmt" },
                python = { "isort", "black" },
                javascript = { "prettierd" },
                typescript = { "prettierd" },
                astro = { "prettierd" },
                html = { "prettierd" },
                css = { "prettierd" },
                json = { "prettierd" },
            },
        },
        formatters = {
            prettierd = {
                command = vim.fn.stdpath("data") .. "~/.local/share/nvim/mason/bin/prettierd",
            },
        },
    },
    -- css color picker
    {
        "eero-lehtinen/oklch-color-picker.nvim",
        event = "VeryLazy",
        version = "*",
        keys = {
            -- One handed keymap recommended, you will be using the mouse
            {
                "<leader>v",
                function() require("oklch-color-picker").pick_under_cursor() end,
                desc = "Color pick under cursor",
            },
        },
        ---@type oklch.Opts
        opts = {},
    },
})
-- end lazy package manager setup


-- lsp stuff
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "bashls",
        -- "python-lsp-server",
        "astro",
        "tailwindcss",
        "ts_ls",
        "html",
        -- "templ",
        -- "gopls",
        "emmet_ls", -- for cmp mainly, helps with auto quotes in html
    },
    automatic_installation = false,
})
local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local function border(hl_name)
    return {
        { "╭", hl_name },
        { "─", hl_name },
        { "╮", hl_name },
        { "│", hl_name },
        { "╯", hl_name },
        { "─", hl_name },
        { "╰", hl_name },
        { "│", hl_name },
    }
end
local luasnip = require("luasnip")
luasnip.add_snippets("all", {
    luasnip.s("html", {
        luasnip.t({
            "<!DOCTYPE html>",
            "<html lang=\"en\">",
            "  <head>",
            "    <meta charset=\"UTF-8\">",
            "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">",
            "    <link href=\"css/app.css\" rel=\"stylesheet\">",
            "    <title></title>",
            "  </head>",
            "  <body>",
            "",
            "  </body>",
            "</html>"
        })
    })
})

local cmp = require("cmp")
cmp.setup({
    window = {
        completion = {
            border = border("CmpBorder"),
            winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
        },
        documentation = { border = border("CmpDocBorder") },
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = {
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- <CR> = enter key
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lsp_signature_help" },
        { name = "path" },
    },
})
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            telemetry = { enable = false },
            workspace = { checkThirdParty = false },
            hint = { enable = true },
        },
    },
})
-- lspconfig.pylsp.setup({ capabilities = capabilities })
lspconfig.pyright.setup({ capabilities = capabilities })
-- lspconfig.ruff_lsp.setup({
-- 	capabilities = capabilities,
-- 	commands = {
-- RuffAutofix = {
--     function()
--         vim.lsp.buf.execute_command {
--             command = 'ruff.applyAutofix',
--             arguments = {
--                 { uri = vim.uri_from_bufnr(0) },
--             },
--         }
--     end,
--     description = 'Ruff: Fix all auto-fixable problems',
-- },
-- 		RuffOrganizeImports = {
-- 			function()
-- 				vim.lsp.buf.execute_command({
-- 					command = "ruff.applyOrganizeImports",
-- 					arguments = {
-- 						{ uri = vim.uri_from_bufnr(0) },
-- 					},
-- 				})
-- 			end,
-- 			description = "Ruff: Format imports",
-- 		},
-- 	},
-- })
lspconfig.tailwindcss.setup({
    capabilities = capabilities,
    settings = {
        tailwindCSS = {
            experimental = {
                -- this will capture any variable assignment in single/double quotes and encased in brackets as well
                classRegex = {
                    "Css = (\\{[^\\{\\}]+\\}|\\[[^\\[\\]]+\\]|'[^']+'|\"[^\"]+\")",
                },
            },
        },
    },
})
lspconfig.html.setup({ capabilities = capabilities, filetypes = { "htmldjango" } })
lspconfig.eslint.setup({ capabilities = capabilities })
-- lspconfig.gopls.setup({ capabilities = capabilities })
-- lspconfig.templ.setup({ capabilities = capabilities })

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- ## lsp diagnostics
-- virtual_text = inline diagnostics
vim.diagnostic.config({ virtual_text = false })

-- apply global float border
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or border("FloatBorder")
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- show diagnostics on cursor hover
vim.o.updatetime = 250
vim.cmd(
    [[autocmd CursorHold,CursorHoldI * lua if not require("cmp").visible() then vim.diagnostic.open_float(nil, {focus=false}) end]]
)
-- ## end lsp diagnostics

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- auto on_attach on lspconfig server setup
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        -- Enable completion triggered by <c-x><c-o>
        if client.server_capabilities.completionProvider then
            vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        end
        if client.server_capabilities.definitionProvider then
            vim.bo[ev.buf].tagfunc = "v:lua.vim.lsp.tagfunc"
        end

        local opts = { noremap = true, silent = true, buffer = ev.buf }

        -- formatting
        -- local method = "textDocument/formatting"
        -- if client.supports_method(method) then
        --     vim.keymap.set('n', '<leader>F', function()
        --         vim.lsp.buf.format { async = true }
        --     end, opts)
        -- end

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    end,
})
-- end lsp stuff

-- html auto tags
require('nvim-ts-autotag').setup({
    aliases = {
        ["astro"] = "html"
    }
})
-- end html auto tags

-- theme
require("catppuccin").setup({
    compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
    flavour = "macchiato",
    transparent_background = true,
    integrations = {
        cmp = true,
        treesitter = true,
    },
    telescope = {
        enabled = true,
    },
})
vim.cmd.colorscheme("catppuccin")
-- end theme

-- bufferline
require("bufferline").setup({
    options = { mode = "tabs", separator_style = "thin" },
})
vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", {})
vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", {})
-- end bufferline

-- lualine
require("lualine").setup({})
-- end lualine

-- telescope
require("telescope").setup({
    pickers = {
        find_files = {
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
    },
})
local telescope_builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, {})
vim.keymap.set("n", "<leader>f", telescope_builtin.find_files, {})
vim.keymap.set("n", "<C-f>", function()
    -- Handling error to output 1 line instead of several
    if pcall(telescope_builtin.git_files) then
    else
        print("Not a git project. Try running git init in root.")
    end
end)
-- end telescope

-- commenter
local ft = require("Comment.ft")
ft.set("typescriptreact", "{/* %s */}")
ft.htmldjango = "{# %s #}"
-- end commenter

-- nvim spectre search and replace
vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre",
})
vim.keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word",
})
vim.keymap.set("n", "<leader>sc", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
    desc = "Search on current file",
})
