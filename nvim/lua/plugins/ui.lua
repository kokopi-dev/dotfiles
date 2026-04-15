local M = {}

local pack = require("commands.pack")

function M.setup()
	pack.add({ "nvim-web-devicons", "indent-blankline.nvim", "lualine.nvim", "bufferline.nvim" })

	require("ibl").setup({
		indent = { char = "▏" },
		scope = { enabled = false },
	})

	require("lualine").setup()
	require("bufferline").setup({
		options = { mode = "tabs", separator_style = "thin" },
	})

	vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", {})
	vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", {})
end

return M
