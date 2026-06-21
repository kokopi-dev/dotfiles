local M = {}

local pack = require("commands.pack")
local mason_utils = require("commands.mason")
local lsp_tools = require("plugins.lsp-manager")

local templ_lsp_refresh_timer

local function uniq(items)
	local seen = {}
	local out = {}
	for _, item in ipairs(items) do
		if item and item ~= "" and not seen[item] then
			seen[item] = true
			table.insert(out, item)
		end
	end
	return out
end

local function any_active_client(names)
	for _, name in ipairs(names) do
		if #vim.lsp.get_clients({ name = name }) > 0 then
			return true
		end
	end
	return false
end

local function lsp_names_for_buf(bufnr)
	local names = {}
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		table.insert(names, client.name)
	end

	local ft = vim.bo[bufnr].filetype
	if ft == "templ" then
		vim.list_extend(names, { "templ", "gopls", "html", "tailwindcss" })
	elseif ft == "go" then
		table.insert(names, "gopls")
	end

	return uniq(names)
end

local function restart_lsp_configs(names, reason)
	names = uniq(names)
	if #names == 0 or not any_active_client(names) then
		return
	end

	vim.cmd("silent! checktime")
	vim.lsp.document_color.enable(false)
	vim.lsp.enable(names, false)
	vim.defer_fn(function()
		vim.lsp.enable(names)
		vim.lsp.document_color.enable(true)
		vim.cmd("silent! checktime")
		if reason then
			vim.notify(("LSP refreshed: %s (%s)"):format(table.concat(names, ", "), reason), vim.log.levels.INFO)
		end
	end, 150)
end

local function schedule_templ_lsp_refresh()
	local names = { "templ", "gopls" }
	if not any_active_client(names) then
		return
	end

	if templ_lsp_refresh_timer then
		templ_lsp_refresh_timer:stop()
		templ_lsp_refresh_timer:close()
	end

	templ_lsp_refresh_timer = vim.uv.new_timer()
	templ_lsp_refresh_timer:start(250, 0, function()
		templ_lsp_refresh_timer:stop()
		templ_lsp_refresh_timer:close()
		templ_lsp_refresh_timer = nil
		vim.schedule(function()
			restart_lsp_configs(names)
		end)
	end)
end

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

	vim.keymap.set("n", "<leader>l", function()
		restart_lsp_configs(lsp_names_for_buf(vim.api.nvim_get_current_buf()), "manual")
	end, { desc = "Refresh relevant LSP" })

	mason_utils.setup_install_defaults_command(lsp_tools.tools)

	vim.diagnostic.config({ virtual_text = false })
	vim.lsp.document_color.enable(true, nil, { style = "virtual" })

	local function pause_diagnostic_float_until_move(bufnr)
		vim.b[bufnr].pause_diagnostic_float = true
		vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
			buffer = bufnr,
			once = true,
			callback = function()
				vim.b[bufnr].pause_diagnostic_float = false
			end,
		})
	end

	local diag_float_group = vim.api.nvim_create_augroup("UserDiagnosticFloat", { clear = true })
	vim.api.nvim_create_autocmd("CursorHold", {
		group = diag_float_group,
		callback = function(ev)
			if vim.b[ev.buf].pause_diagnostic_float then
				return
			end
			if vim.fn.pumvisible() == 1 then
				return
			end
			vim.diagnostic.open_float(nil, {
				focusable = false,
				scope = "line",
			})
		end,
	})

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

	local templ_lsp_group = vim.api.nvim_create_augroup("UserTemplLspRefresh", { clear = true })
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = templ_lsp_group,
		pattern = "*.templ",
		callback = schedule_templ_lsp_refresh,
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

			local map = function(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, {
					buffer = bufnr,
					silent = true,
					noremap = true,
					desc = desc,
				})
			end

			map("n", "gD", vim.lsp.buf.declaration, "LSP declaration")
			map("n", "K", function()
				pause_diagnostic_float_until_move(bufnr)
				vim.lsp.buf.hover()
			end, "LSP hover")
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
