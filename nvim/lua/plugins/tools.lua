local M = {}

local lazy = require("utils.lazy")
local pack = require("utils.pack")

local function with_trouble(fn)
	lazy.load_once("trouble", pack.registry({ "trouble.nvim" }), function()
		require("trouble").setup({})
	end)
	fn()
end

-- grug guide
-- navigate splits: <C+w><Left> or <Right>
local function with_grug(fn)
	lazy.load_once("grug-far", pack.registry({ "grug-far.nvim" }), function()
		require("grug-far").setup({})
	end)
	fn(require("grug-far"))
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

	vim.keymap.set("n", "<leader>S", function()
		with_grug(function()
			vim.cmd("GrugFar")
		end)
	end, { desc = "Search/replace project" })

	vim.keymap.set("n", "<leader>s", function()
		with_grug(function(grug)
			grug.open({ prefills = { paths = vim.fn.expand("%") } })
		end)
	end, { desc = "Search/replace current file" })

	vim.keymap.set("x", "<leader>s", function()
		with_grug(function(grug)
			grug.open({ visualSelectionUsage = "operate-within-range" })
		end)
	end, { desc = "Search/replace in selection" })
end

return M
