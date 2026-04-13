local M = {}

local pack = require("utils.pack")

function M.setup()
	pack.add({ "nvim-treesitter" })

	require("nvim-treesitter").setup({
		install_dir = vim.fn.stdpath("data") .. "/site",
	})

	require("nvim-treesitter").install({
		"lua",
		"vim",
		"python",
		"bash",
		"javascript",
		"typescript",
		"html",
		"css",
		"json",
		"toml",
		"go",
		"astro",
		"templ",
	})

	vim.api.nvim_create_autocmd("FileType", {
		pattern = {
			"lua",
			"vim",
			"python",
			"bash",
			"javascript",
			"typescript",
			"html",
			"css",
			"json",
			"toml",
			"go",
			"astro",
			"templ",
		},
		callback = function(args)
			pcall(vim.treesitter.start, args.buf)
		end,
	})
end

return M
