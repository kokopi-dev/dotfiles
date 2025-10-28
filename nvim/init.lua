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
        branch = 'master',
        -- tag = "0.1.5",
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
    -- search and replace
    {
        "nvim-pack/nvim-spectre",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            {
                "<leader>S",
                function()
                    local root = vim.fs.root(0, { ".git" })
                    require("spectre").open_visual({
                        cwd = root or vim.fn.getcwd(),
                        select_word = true,
                    })
                end,
                desc = "Search current word at project root"
            },
            {
                "<leader>s",
                function()
                    require("spectre").open_file_search({
                        select_word = true,
                    })
                end,
                desc = "Search on current file"
            },
        },
        opts = {
            default = {
                find = {
                    cmd = "rg",
                    options = { "case-sensitive", "word-regexp" } -- This makes rg case-sensitive
                },
                replace = {
                    cmd = "sed"
                }
            },
            mapping = {
                ['toggle_word_regexp'] = {
                    map = "tw",
                    cmd = "<cmd>lua require('spectre').change_options('word-regexp')<CR>",
                    desc = "toggle word boundary"
                },
                ['toggle_case_sensitive'] = {
                    map = "tc",
                    cmd = "<cmd>lua require('spectre').change_options('case-sensitive')<CR>",
                    desc = "toggle case sensitive"
                },
                ['toggle_ignore_case'] = {
                    map = 'ti',
                    cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
                    desc = 'toggle ignore case',
                },
                ['toggle_ignore_hidden'] = {
                    map = 'th',
                    cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
                    desc = 'toggle search hidden',
                },
            },
            find_engine = {
                ['rg'] = {
                    cmd = 'rg',
                    -- default args
                    args = {
                        '--color=never',
                        '--no-heading',
                        '--with-filename',
                        '--line-number',
                        '--column',
                    },
                    options = {
                        ['ignore-case'] = {
                            value = '--ignore-case',
                            icon = '[I]',
                            desc = 'ignore case match',
                        },
                        ['hidden'] = {
                            value = '--hidden',
                            desc = 'hidden file',
                            icon = '[H]',
                        },
                        ['word-regexp'] = {
                            value = '-w',
                            desc = 'match word only',
                            icon = '[W]',
                        },
                        ['case-sensitive'] = {
                            value = '--case-sensitive',
                            desc = 'case sensitive match',
                            icon = '[C]',
                        }
                    },
                },
            }
        },
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
    -- usage/references
    {
        'Wansmer/symbol-usage.nvim',
        event = 'BufReadPre', -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
    },
    -- errors visibility
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
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
                jsonc = { "prettierd" },
            },
        },
        formatters = {
            prettierd_json = {
                command = vim.fn.stdpath("data") .. "~/.local/share/nvim/mason/bin/prettierd",
                args = {
                    "--stdin-filepath", "$FILENAME",
                    "--parser", "json",
                    "--trailing-comma", "none"
                },
                stdin = true,
            },
            prettierd = {
                command = vim.fn.stdpath("data") .. "~/.local/share/nvim/mason/bin/prettierd",
                args = function(self, ctx)
                    local args = { "--stdin-filepath", "$FILENAME" }

                    if vim.bo[ctx.buf].filetype == "jsonc" then
                        table.insert(args, "--parser")
                        table.insert(args, "json")
                        table.insert(args, "--trailing-comma")
                        table.insert(args, "none")
                    end

                    return args
                end,
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

-- usage hints formatter
local function h(name) return vim.api.nvim_get_hl(0, { name = name }) end

-- hl-groups can have any name
vim.api.nvim_set_hl(0, 'SymbolUsageRounding', { fg = h('CursorLine').bg, italic = true })
vim.api.nvim_set_hl(0, 'SymbolUsageContent', { bg = h('CursorLine').bg, fg = h('Comment').fg, italic = true })
vim.api.nvim_set_hl(0, 'SymbolUsageRef', { fg = h('Function').fg, bg = h('CursorLine').bg, italic = true })
vim.api.nvim_set_hl(0, 'SymbolUsageDef', { fg = h('Type').fg, bg = h('CursorLine').bg, italic = true })
vim.api.nvim_set_hl(0, 'SymbolUsageImpl', { fg = h('@keyword').fg, bg = h('CursorLine').bg, italic = true })

local function text_format(symbol)
    local res = {}

    local round_start = { '', 'SymbolUsageRounding' }
    local round_end = { '', 'SymbolUsageRounding' }

    -- Indicator that shows if there are any other symbols in the same line
    local stacked_functions_content = symbol.stacked_count > 0
        and ("+%s"):format(symbol.stacked_count)
        or ''

    if symbol.references then
        local usage = symbol.references <= 1 and 'usage' or 'usages'
        local num = symbol.references == 0 and 'no' or symbol.references
        table.insert(res, round_start)
        table.insert(res, { '󰌹 ', 'SymbolUsageRef' })
        table.insert(res, { ('%s %s'):format(num, usage), 'SymbolUsageContent' })
        table.insert(res, round_end)
    end

    if symbol.definition then
        if #res > 0 then
            table.insert(res, { ' ', 'NonText' })
        end
        table.insert(res, round_start)
        table.insert(res, { '󰳽 ', 'SymbolUsageDef' })
        table.insert(res, { symbol.definition .. ' defs', 'SymbolUsageContent' })
        table.insert(res, round_end)
    end

    if symbol.implementation then
        if #res > 0 then
            table.insert(res, { ' ', 'NonText' })
        end
        table.insert(res, round_start)
        table.insert(res, { '󰡱 ', 'SymbolUsageImpl' })
        table.insert(res, { symbol.implementation .. ' impls', 'SymbolUsageContent' })
        table.insert(res, round_end)
    end

    if stacked_functions_content ~= '' then
        if #res > 0 then
            table.insert(res, { ' ', 'NonText' })
        end
        table.insert(res, round_start)
        table.insert(res, { ' ', 'SymbolUsageImpl' })
        table.insert(res, { stacked_functions_content, 'SymbolUsageContent' })
        table.insert(res, round_end)
    end

    return res
end
require('symbol-usage').setup({
    text_format = text_format,
    references = { enabled = true, include_declaration = false },
    definition = { enabled = true },
    kinds = {
        vim.lsp.protocol.SymbolKind.Function,
        vim.lsp.protocol.SymbolKind.Method,
        vim.lsp.protocol.SymbolKind.Constant,
        vim.lsp.protocol.SymbolKind.Struct,    -- Add this for Go structs
        vim.lsp.protocol.SymbolKind.Interface, -- You might also want interfaces
        vim.lsp.protocol.SymbolKind.Class,     -- Some languages use Class
    }
})
-- end usage hints formatter

-- lsp stuff
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.offsetEncoding = { "utf-16", "utf-8" }
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
        "pyright",
        "templ",
        "gopls",
        "emmet_ls", -- for cmp mainly, helps with auto quotes in html
    },
    automatic_installation = true,
    automatic_enable = false
})
-- Tailwind CSS
vim.lsp.config('tailwindcss', {
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
    filetypes = { "htmldjango", "templ" },
})
vim.lsp.enable('tailwindcss')

-- Python
vim.lsp.config('pyright', {
    capabilities = capabilities,
})
vim.lsp.enable('pyright')

-- Bash
vim.lsp.config('bashls', {
    capabilities = capabilities,
})
vim.lsp.enable('bashls')

-- Astro
vim.lsp.config('astro', {
    capabilities = capabilities,
})
vim.lsp.enable('astro')

-- Typescript
vim.lsp.config('ts_ls', {
    capabilities = capabilities,
})
vim.lsp.enable('ts_ls')

-- Emmet
vim.lsp.config('emmet_ls', {
    capabilities = capabilities,
})
vim.lsp.enable('emmet_ls')

-- HTML
vim.lsp.config('html', {
    capabilities = capabilities,
    filetypes = { "htmldjango", "templ" },
})
vim.lsp.enable('html')

-- Templ
vim.lsp.config('templ', {
    capabilities = capabilities,
})
vim.lsp.enable('templ')

-- Gopls
vim.lsp.config('gopls', {
    capabilities = capabilities,
    -- settings = {
    --     gopls = {
    --         -- directoryFilters = { "-**/*_templ.go" },
    --     },
    -- },
})
vim.lsp.enable('gopls')

-- Lua LS
vim.lsp.config('lua_ls', {
    capabilities = capabilities,
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
vim.lsp.enable('lua_ls')

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
-- vim.cmd(
--     [[autocmd CursorHold,CursorHoldI * lua if not require("cmp").visible() then vim.diagnostic.open_float(nil, {focus=false}) end]]
-- )
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    callback = function()
        -- Don't show diagnostic if completion menu is visible
        if require("cmp").visible() then
            return
        end

        -- Don't show diagnostic if a hover/signature window is already open
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local config = vim.api.nvim_win_get_config(win)
            if config.relative ~= '' then
                local buf = vim.api.nvim_win_get_buf(win)
                local ft = vim.bo[buf].filetype
                -- Check if it's a hover window (usually has 'markdown' filetype)
                if ft == 'markdown' or config.focusable == true then
                    return
                end
            end
        end

        vim.diagnostic.open_float(nil, { focus = false })
    end
})
-- ## end lsp diagnostics

-- override gopls qualified template definition jumping
local function custom_go_to_definition()
    -- Early exit for non-Go/templ files
    local ft = vim.bo.filetype
    -- if ft == "python" then
    --     vim.lsp.buf.definition()
    --     return
    if ft ~= "go" and ft ~= "templ" then
        require('telescope.builtin').lsp_definitions()
        return
    end
    -- Early exit if no gopls client attached
    local clients = vim.lsp.get_clients({ bufnr = 0, name = "gopls" })
    if #clients == 0 then
        require('telescope.builtin').lsp_definitions()
        return
    end
    -- Use the gopls client for position encoding
    local gopls_client = clients[1]
    local params = vim.lsp.util.make_position_params(0, gopls_client.offset_encoding)
    vim.lsp.buf_request(0, 'textDocument/definition', params, function(err, result, ctx, config)
        if err or not result or vim.tbl_isempty(result) then
            require('telescope.builtin').lsp_definitions()
            return
        end
        -- Convert single result to array
        if result.uri then
            result = { result }
        end
        -- Quick check: do we have any _templ.go files in results?
        local has_templ_generated = false
        for _, location in ipairs(result) do
            local uri = location.uri or location.targetUri
            local filepath = vim.uri_to_fname(uri)
            if filepath:match("_templ%.go$") then
                has_templ_generated = true
                break
            end
        end
        -- If no generated templ files, use normal telescope
        if not has_templ_generated then
            require('telescope.builtin').lsp_definitions()
            return
        end
        -- Only do the heavy processing if we found generated files
        local word_under_cursor = vim.fn.expand('<cword>')
        local processed_results = {}
        for _, location in ipairs(result) do
            local uri = location.uri or location.targetUri
            local filepath = vim.uri_to_fname(uri)
            if filepath:match("_templ%.go$") then
                local templ_file = filepath:gsub("_templ%.go$", ".templ")
                if vim.fn.filereadable(templ_file) == 1 then
                    -- Simple search for the symbol
                    local cmd = string.format("grep -n 'templ %s\\|func %s' %s",
                        word_under_cursor, word_under_cursor, vim.fn.shellescape(templ_file))
                    local output = vim.fn.system(cmd)
                    if vim.v.shell_error == 0 and output ~= "" then
                        local lnum = output:match("^(%d+)")
                        if lnum then
                            table.insert(processed_results, {
                                uri = vim.uri_from_fname(templ_file),
                                range = {
                                    start = { line = tonumber(lnum) - 1, character = 0 },
                                    ["end"] = { line = tonumber(lnum) - 1, character = 0 }
                                }
                            })
                        end
                    else
                        -- Keep original if not found in templ
                        table.insert(processed_results, location)
                    end
                else
                    table.insert(processed_results, location)
                end
            else
                table.insert(processed_results, location)
            end
        end
        local final_results = #processed_results > 0 and processed_results or result
        if #final_results == 1 then
            -- Use modern API instead of deprecated jump_to_location
            local location = final_results[1]
            local uri = location.uri or location.targetUri
            local range = location.range or location.targetRange
            -- Open the file
            vim.cmd('edit ' .. vim.fn.fnameescape(vim.uri_to_fname(uri)))
            -- Jump to position
            local row = range.start.line + 1
            local col = range.start.character + 1
            vim.api.nvim_win_set_cursor(0, { row, col - 1 })
            -- Center the view
            vim.cmd('normal! zz')
        else
            local qf_items = {}
            for _, location in ipairs(final_results) do
                local filename = vim.uri_to_fname(location.uri or location.targetUri)
                local range = location.range or location.targetRange
                table.insert(qf_items, {
                    filename = filename,
                    lnum = range.start.line + 1,
                    col = range.start.character + 1,
                    text = "",
                })
            end
            vim.fn.setqflist(qf_items)
            require('telescope.builtin').quickfix()
        end
    end)
end

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

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
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
        vim.keymap.set("n", "gd", custom_go_to_definition, opts)
        vim.keymap.set("n", "gr", require('telescope.builtin').lsp_references, opts)
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
            find_command = {
                "rg",
                "--files",
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                "--glob", "!**/.git/*",
                -- "--hidden",
            },
        },
        live_grep = {
            additional_args = function()
                return {
                    "--glob", "!**/.git/*",
                    "--glob", "!**/go.sum",
                    "--glob", "!**/go.mod",
                }
            end
        },
        lsp_definitions = {
            show_line = false,
            file_ignore_patterns = { ".*_templ.go" },
            theme = "dropdown",
        },
        lsp_references = {
            show_line = false,
            include_declaration = false,
            file_ignore_patterns = { ".*_templ.go" },
            theme = "dropdown",
        },
    },
})
local telescope_builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, {})
vim.keymap.set("n", "<leader>f", telescope_builtin.find_files, {})
vim.keymap.set("n", "<C-f>", function()
    -- Handling error to output 1 line instead of several
    if pcall(telescope_builtin.git_files, { show_untracked = true }) then
    else
        print("Not a git project. Try running git init in root.")
    end
end)
-- end telescope

-- commenter
local ft = require("Comment.ft")
ft.set("typescriptreact", "{/* %s */}")
ft.htmldjango = "{# %s #}"
ft.templ = "// %s"
-- end commenter
