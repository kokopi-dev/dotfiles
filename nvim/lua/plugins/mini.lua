local M = {}

local pack = require("utils.pack")

function M.setup()
	pack.add({ "mini.nvim" })

	require("mini.comment").setup({
		options = {
			custom_commentstring = function()
				local ft = vim.bo.filetype
				if ft == "templ" then
					return "// %s"
				end
				return nil
			end,
		},
	})

	vim.keymap.set("n", "<leader>cc", function()
		require("mini.comment").toggle_lines(vim.fn.line("."), vim.fn.line("."))
	end, { desc = "Toggle comment line" })

	vim.keymap.set("v", "<leader>cc", function()
		local s, e = vim.fn.line("v"), vim.fn.line(".")
		if s > e then
			s, e = e, s
		end
		require("mini.comment").toggle_lines(s, e)
	end, { desc = "Toggle comment selection" })

	require("mini.pairs").setup()
end

return M
