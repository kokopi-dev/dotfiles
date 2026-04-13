local M = {}

local lazy = require("utils.lazy")
local pack = require("utils.pack")

local function with_telescope(fn)
	lazy.load_once("telescope", pack.registry({ "plenary.nvim", "telescope.nvim" }), function()
		require("telescope").setup({
			defaults = { file_ignore_patterns = { "%.git/" } },
			pickers = {
				find_files = {
					find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
				},
				live_grep = {
					additional_args = function()
						return { "--glob", "!**/.git/*", "--glob", "!**/go.sum", "--glob", "!**/go.mod" }
					end,
				},
				lsp_definitions = {
					show_line = false,
					theme = "dropdown",
					file_ignore_patterns = { ".*_templ.go" },
				},
				lsp_references = {
					show_line = false,
					include_declaration = false,
					theme = "dropdown",
					file_ignore_patterns = { ".*_templ.go" },
				},
			},
		})
	end)
	fn(require("telescope.builtin"))
end

function M.lsp_definitions()
	with_telescope(function(builtin)
		builtin.lsp_definitions()
	end)
end

function M.lsp_references()
	with_telescope(function(builtin)
		builtin.lsp_references()
	end)
end

function M.setup_keymaps()
	vim.keymap.set("n", "<leader>f", function()
		with_telescope(function(builtin)
			builtin.find_files()
		end)
	end, { desc = "Find files" })

	vim.keymap.set("n", "<leader>fg", function()
		with_telescope(function(builtin)
			builtin.live_grep()
		end)
	end, { desc = "Live grep" })

	vim.keymap.set("n", "<C-f>", function()
		with_telescope(function(builtin)
			if not pcall(builtin.git_files, { show_untracked = true }) then
				vim.notify("Not a git project. Try running git init in root.", vim.log.levels.WARN)
			end
		end)
	end, { desc = "Git files" })
end

return M
