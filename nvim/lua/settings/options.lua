vim.g.mapleader = " "

vim.opt.timeoutlen = 350
vim.opt.updatetime = 50

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "no"
vim.opt.scrolloff = 8
vim.opt.mouse = "nvi"
vim.opt.guicursor = "i-ci:ver30-iCursor-blinkwait300-blinkon200-blinkoff150"

vim.opt.clipboard = "unnamedplus"

vim.opt.backup = false
vim.opt.writebackup = false

local undo_dir = vim.fs.joinpath(vim.fn.stdpath("state"), "undo")
vim.fn.mkdir(undo_dir, "p")
vim.opt.undodir = undo_dir
vim.opt.undofile = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"typescriptreact",
		"typescript",
		"javascript",
		"css",
		"html",
		"htmldjango",
		"yaml",
		"json",
		"markdown",
		"toml",
	},
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
	end,
})

vim.opt.wildignore:append({ "*/node_modules/*", "*/venv/*" })
vim.opt.path:append({ "**" })

vim.g.python3_host_prog = "/usr/bin/python3"

vim.filetype.add({
	extension = { templ = "templ" },
})

vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = "*.py",
	callback = function()
		vim.cmd("0r " .. vim.fn.fnameescape(vim.fs.joinpath(vim.fn.stdpath("config"), "templates", "skeleton.py")))
	end,
})

vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = "*.sh",
	callback = function()
		vim.cmd("0r " .. vim.fn.fnameescape(vim.fs.joinpath(vim.fn.stdpath("config"), "templates", "skeleton.sh")))
	end,
})
