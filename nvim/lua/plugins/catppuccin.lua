local M = {}

local ui = require("utils.ui")
local pack = require("utils.pack")

local function apply_theme_overrides()
	local transparent_groups = {
		"NormalFloat",
		"FloatBorder",
		"TelescopeNormal",
		"TelescopeBorder",
		"TelescopePromptNormal",
		"TelescopePromptBorder",
		"TelescopeResultsNormal",
		"TelescopeResultsBorder",
		"TelescopePreviewNormal",
		"TelescopePreviewBorder",
	}
	for _, g in ipairs(transparent_groups) do
		vim.api.nvim_set_hl(0, g, { bg = "none" })
	end

	for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
		local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group })
		if ok and hl and hl.italic then
			hl.italic = nil
			vim.api.nvim_set_hl(0, group, hl)
		end
	end
end

function M.setup()
	pack.add({ "catppuccin", "nvim-web-devicons" })

	local theme_group = vim.api.nvim_create_augroup("UserThemeTweaks", { clear = true })
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = theme_group,
		callback = apply_theme_overrides,
	})

	require("catppuccin").setup({
		flavour = "macchiato",
		transparent_background = true,
		compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
		integrations = {
			cmp = true,
			treesitter = true,
		},
		telescope = {
			enabled = true,
		},
	})

	vim.cmd.colorscheme("catppuccin")
	apply_theme_overrides()

	local orig = vim.lsp.util.open_floating_preview
	vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or ui.border("FloatBorder")
		return orig(contents, syntax, opts, ...)
	end
end

return M
