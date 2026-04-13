local M = {}

local pack = require("utils.pack")

function M.setup()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "html", "xml", "javascriptreact", "typescriptreact", "astro", "templ" },
		once = true,
		callback = function()
			pack.add({ "nvim-ts-autotag" })
			require("nvim-ts-autotag").setup({
				aliases = {
					astro = "html",
				},
			})
		end,
	})
end

return M
