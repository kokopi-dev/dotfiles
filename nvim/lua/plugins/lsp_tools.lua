local M = {}

M.tools = {
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

function M.lsp_names()
	local names = {}
	for _, tool in ipairs(M.tools) do
		if tool.kind == "lsp" then
			table.insert(names, tool.lsp)
		end
	end
	return names
end

function M.formatters_by_ft()
	local by_ft = {}
	for _, tool in ipairs(M.tools) do
		if tool.kind == "formatter" and tool.ft then
			local formatter = tool.conform or tool.mason
			for _, ft in ipairs(tool.ft) do
				by_ft[ft] = by_ft[ft] or {}
				table.insert(by_ft[ft], formatter)
			end
		end
	end
	return by_ft
end

return M
