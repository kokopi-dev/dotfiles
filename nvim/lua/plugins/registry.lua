local M = {}

M.map = {
	catppuccin = { name = "catppuccin", src = "https://github.com/catppuccin/nvim" },
	["nvim-web-devicons"] = { name = "nvim-web-devicons", src = "https://github.com/nvim-tree/nvim-web-devicons" },
	mason = { name = "mason", src = "https://github.com/mason-org/mason.nvim" },
	["nvim-lspconfig"] = { name = "nvim-lspconfig", src = "https://github.com/neovim/nvim-lspconfig" },
	conform = { name = "conform", src = "https://github.com/stevearc/conform.nvim" },
	["nvim-cmp"] = { name = "nvim-cmp", src = "https://github.com/hrsh7th/nvim-cmp" },
	["cmp-nvim-lsp"] = { name = "cmp-nvim-lsp", src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	["cmp-buffer"] = { name = "cmp-buffer", src = "https://github.com/hrsh7th/cmp-buffer" },
	["cmp-path"] = { name = "cmp-path", src = "https://github.com/hrsh7th/cmp-path" },
	luasnip = { name = "luasnip", src = "https://github.com/L3MON4D3/LuaSnip" },
	cmp_luasnip = { name = "cmp_luasnip", src = "https://github.com/saadparwaiz1/cmp_luasnip" },
	["nvim-treesitter"] = { name = "nvim-treesitter", src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	["mini.nvim"] = { name = "mini.nvim", src = "https://github.com/echasnovski/mini.nvim" },
	["indent-blankline.nvim"] = {
		name = "indent-blankline.nvim",
		src = "https://github.com/lukas-reineke/indent-blankline.nvim",
	},
	["lualine.nvim"] = { name = "lualine.nvim", src = "https://github.com/nvim-lualine/lualine.nvim" },
	["bufferline.nvim"] = { name = "bufferline.nvim", src = "https://github.com/akinsho/bufferline.nvim" },
	["plenary.nvim"] = { name = "plenary.nvim", src = "https://github.com/nvim-lua/plenary.nvim" },
	["telescope.nvim"] = { name = "telescope.nvim", src = "https://github.com/nvim-telescope/telescope.nvim" },
	["trouble.nvim"] = { name = "trouble.nvim", src = "https://github.com/folke/trouble.nvim" },
	["grug-far.nvim"] = { name = "grug-far.nvim", src = "https://github.com/MagicDuck/grug-far.nvim" },
	["nvim-ts-autotag"] = { name = "nvim-ts-autotag", src = "https://github.com/windwp/nvim-ts-autotag" },
	["supermaven-nvim"] = { name = "supermaven-nvim", src = "https://github.com/supermaven-inc/supermaven-nvim" },
}

function M.by_names(names)
	local out = {}
	for _, name in ipairs(names) do
		local entry = M.map[name]
		if not entry then
			error("Unknown plugin registry entry: " .. tostring(name))
		end
		table.insert(out, entry)
	end
	return out
end

function M.names()
	local keys = {}
	for name, _ in pairs(M.map) do
		table.insert(keys, name)
	end
	table.sort(keys)
	return keys
end

function M.all()
	return M.by_names(M.names())
end

return M
