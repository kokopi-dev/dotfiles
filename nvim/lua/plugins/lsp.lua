local M = {}

local pack = require("utils.pack")
local mason_utils = require("utils.mason")
local lsp_tools = require("plugins.lsp_tools")

function M.setup()
	pack.add({ "mason", "nvim-lspconfig", "conform", "symbol-usage" })

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
		filetypes = {
			"htmldjango",
			"templ",
			"html",
			"css",
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
		},
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

	vim.lsp.enable(lsp_tools.lsp_names())

	require("conform").setup({
		formatters_by_ft = lsp_tools.formatters_by_ft(),
	})

	vim.keymap.set("n", "<leader>F", function()
		require("conform").format({ async = true, lsp_fallback = true })
	end, { desc = "Format buffer" })

	mason_utils.setup_install_defaults_command(lsp_tools.tools)

	vim.diagnostic.config({ virtual_text = false })

	local function text_format(symbol)
		local fragments = {}

		-- Indicator that shows if there are any other symbols in the same line
		local stacked_functions = symbol.stacked_count > 0 and (" | +%s"):format(symbol.stacked_count) or ""

		if symbol.references then
			local usage = symbol.references <= 1 and "usage" or "usages"
			local num = symbol.references == 0 and "no" or symbol.references
			table.insert(fragments, ("%s %s"):format(num, usage))
		end

		-- if symbol.definition then
		-- 	table.insert(fragments, symbol.definition .. " defs")
		-- end

		if symbol.implementation then
			table.insert(fragments, symbol.implementation .. " impls")
		end

		return table.concat(fragments, ", ") .. stacked_functions
	end
	require("symbol-usage").setup({
        text_format = text_format,
	})

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
			if client:supports_method("textDocument/documentColor") then
				vim.lsp.document_color.enable(true, { bufnr = bufnr }, { style = "virtual" })
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
