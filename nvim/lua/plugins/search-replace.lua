local M = {}

local lazy = require("utils.lazy")
local pack = require("utils.pack")

-- grug guide
-- navigate splits: <C+w><Left> or <Right>
local function with_grug(fn)
	lazy.load_once("grug-far", pack.registry({ "grug-far.nvim" }), function()
		require("grug-far").setup({})
	end)
	fn(require("grug-far"))
end

function M.setup()
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
