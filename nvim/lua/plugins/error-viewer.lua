local M = {}

local lazy = require("utils.lazy")
local pack = require("utils.pack")

local function with_trouble(fn)
	lazy.load_once("trouble", pack.registry({ "trouble.nvim" }), function()
		require("trouble").setup({})
	end)
	fn()
end

function M.setup()
	vim.keymap.set("n", "<leader>xx", function()
		with_trouble(function()
			vim.cmd("Trouble diagnostics toggle")
		end)
	end, { desc = "Diagnostics (Trouble)" })

	vim.keymap.set("n", "<leader>xX", function()
		with_trouble(function()
			vim.cmd("Trouble diagnostics toggle filter.buf=0")
		end)
	end, { desc = "Buffer diagnostics" })

	vim.keymap.set("n", "<leader>xQ", function()
		with_trouble(function()
			vim.cmd("Trouble qflist toggle")
		end)
	end, { desc = "Quickfix list" })
end

return M
