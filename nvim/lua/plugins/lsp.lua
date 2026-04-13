local M = {}

local pack = require("utils.pack")

local tools = {
	{ kind = "lsp", lsp = "lua_ls", mason = "lua-language-server" },
	{ kind = "lsp", lsp = "bashls", mason = "bash-language-server" },
	{ kind = "lsp", lsp = "astro", mason = "astro-language-server" },
	{ kind = "lsp", lsp = "tailwindcss", mason = "tailwindcss-language-server" },
	{ kind = "lsp", lsp = "ts_ls", mason = "typescript-language-server" },
	{ kind = "lsp", lsp = "html", mason = "html-lsp" },
	{ kind = "lsp", lsp = "pyright", mason = "pyright" },
	{ kind = "lsp", lsp = "templ", mason = "templ" },
	{ kind = "lsp", lsp = "gopls", mason = "gopls" },
	{ kind = "lsp", lsp = "emmet_ls", mason = "emmet-language-server" },
	{ kind = "lsp", lsp = "rust_analyzer", mason = "rust-analyzer" },
	{ kind = "formatter", mason = "stylua", ft = { "lua" } },
	{ kind = "formatter", mason = "shfmt", ft = { "sh", "bash" } },
	{ kind = "formatter", mason = "isort", ft = { "python" } },
	{ kind = "formatter", mason = "black", ft = { "python" } },
	{ kind = "formatter", mason = "prettierd", ft = { "javascript", "typescript", "astro", "html", "css", "json", "jsonc" } },
}

function M.setup()
	pack.add({ "mason", "nvim-lspconfig", "conform" })

	require("mason").setup()

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	pcall(function()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
	end)
	vim.lsp.config("*", { capabilities = capabilities })

	vim.lsp.config("tailwindcss", {
		settings = {
			tailwindCSS = {
				experimental = {
					classRegex = {
						"Css = (\\{[^\\{\\}]+\\}|\\[[^\\[\\]]+\\]|'[^']+'|\"[^\"]+\")",
					},
				},
			},
		},
		filetypes = { "htmldjango", "templ", "html", "css", "javascript", "typescript", "jsx", "tsx" },
	})
	vim.lsp.config("html", { filetypes = { "html", "htmldjango", "templ" } })
	vim.lsp.config("lua_ls", {
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
				telemetry = { enable = false },
				workspace = { checkThirdParty = false },
				hint = { enable = true },
			},
		},
	})

	local lsp_names = {}
	for _, t in ipairs(tools) do
		if t.kind == "lsp" then
			table.insert(lsp_names, t.lsp)
		end
	end
	vim.lsp.enable(lsp_names)

	require("conform").setup({
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
	})

	vim.keymap.set("n", "<leader>F", function()
		require("conform").format({ async = true, lsp_fallback = true })
	end, { desc = "Format buffer" })

	vim.api.nvim_create_user_command("MasonInstallDefaults", function()
		local registry = require("mason-registry")
		registry.refresh(function()
			local seen, to_install = {}, {}
			for _, t in ipairs(tools) do
				if t.mason and not seen[t.mason] then
					seen[t.mason] = true
					local ok, pkg = pcall(registry.get_package, t.mason)
					if ok and not pkg:is_installed() then
						table.insert(to_install, pkg)
					end
				end
			end

			if #to_install == 0 then
				vim.notify("MasonInstallDefaults: all tools already installed", vim.log.levels.INFO)
				return
			end
			for _, pkg in ipairs(to_install) do
				pkg:install()
			end
			vim.notify(("MasonInstallDefaults: installing %d tool(s)"):format(#to_install), vim.log.levels.INFO)
		end)
	end, { desc = "Install missing Mason tools from `tools` table" })

	vim.diagnostic.config({ virtual_text = false })

	local lsp_group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true })
	vim.api.nvim_create_autocmd("LspAttach", {
		group = lsp_group,
		callback = function(ev)
			local bufnr = ev.buf
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			if not client then
				return
			end

			if client:supports_method("textDocument/completion") then
				vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
			end
			if client:supports_method("textDocument/definition") then
				vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
			end

			local map = function(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, {
					buffer = bufnr,
					silent = true,
					noremap = true,
					desc = desc,
				})
			end

			map("n", "gD", vim.lsp.buf.declaration, "LSP declaration")
			map("n", "K", vim.lsp.buf.hover, "LSP hover")
			map("n", "gi", vim.lsp.buf.implementation, "LSP implementation")
			map("n", "<C-k>", vim.lsp.buf.signature_help, "LSP signature help")
			map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "LSP add workspace folder")
			map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "LSP remove workspace folder")
			map("n", "<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, "LSP list workspace folders")
			map("n", "<leader>D", vim.lsp.buf.type_definition, "LSP type definition")
			map("n", "<leader>rn", vim.lsp.buf.rename, "LSP rename")
			map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
			map("n", "gd", function()
				require("plugins.telescope").lsp_definitions()
			end, "LSP definitions (Telescope)")
			map("n", "gr", function()
				require("plugins.telescope").lsp_references()
			end, "LSP references (Telescope)")
		end,
	})
end

return M
