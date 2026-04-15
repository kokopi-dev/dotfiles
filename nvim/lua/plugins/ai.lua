local M = {}

local pack = require("commands.pack")

function M.setup()
	vim.api.nvim_create_autocmd("InsertEnter", {
		once = true,
		callback = function()
			pack.add({ "supermaven-nvim" })
			require("supermaven-nvim").setup({})
		end,
	})
end

return M
