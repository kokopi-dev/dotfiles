-- project / netrw
vim.keymap.set("n", "<leader>E", "<cmd>Ex<CR>", { desc = "Open netrw" })
vim.keymap.set("n", "<leader>ER", "<cmd>bw<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>sr", ":cd %:p:h<CR>", { desc = "Set cwd to file dir" })

-- split navigation
vim.keymap.set("n", "<A-Left>", "<C-w>h")
vim.keymap.set("n", "<A-Down>", "<C-w>j")
vim.keymap.set("n", "<A-Up>", "<C-w>k")
vim.keymap.set("n", "<A-Right>", "<C-w>l")

-- netrw duplicate helper (<leader>d)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function()
		vim.keymap.set("n", "<leader>d", function()
			local cwd = vim.fn.getcwd()
			vim.cmd("lcd %:p:h")
			vim.api.nvim_feedkeys("mt", "x", false)
			vim.api.nvim_feedkeys("mf", "x", false)
			vim.api.nvim_feedkeys("mc", "x", false)
			vim.defer_fn(function()
				vim.fn.chdir(cwd)
			end, 500)
		end, { buffer = true, desc = "Duplicate file in netrw" })
	end,
})

-- buffer history (per-tab)
local hist_by_tab = {}
local navigating = false

local function tab_hist()
	local t = vim.fn.tabpagenr()
	hist_by_tab[t] = hist_by_tab[t] or { bufs = {}, idx = 1 }
	return hist_by_tab[t]
end

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		if navigating then
			return
		end
		local b = vim.fn.bufnr("%")
		if not vim.bo[b].buflisted then
			return
		end
		local h = tab_hist()

		for i = #h.bufs, 1, -1 do
			if h.bufs[i] == b then
				table.remove(h.bufs, i)
				if i <= h.idx then
					h.idx = math.max(1, h.idx - 1)
				end
			end
		end

		while h.idx < #h.bufs do
			table.remove(h.bufs)
		end

		table.insert(h.bufs, b)
		h.idx = #h.bufs
	end,
})

vim.keymap.set("n", "<A-b>", function()
	local h = tab_hist()
	if h.idx <= 1 then
		return
	end
	navigating = true
	h.idx = h.idx - 1
	local b = h.bufs[h.idx]
	if vim.fn.bufexists(b) == 1 and vim.bo[b].buflisted then
		vim.cmd("buffer " .. b)
	else
		table.remove(h.bufs, h.idx)
		h.idx = math.max(1, h.idx - 1)
	end
	vim.schedule(function()
		navigating = false
	end)
end, { desc = "Prev buffer (history)" })

vim.keymap.set("n", "<A-n>", function()
	local h = tab_hist()
	if h.idx >= #h.bufs then
		return
	end
	navigating = true
	h.idx = h.idx + 1
	local b = h.bufs[h.idx]
	if vim.fn.bufexists(b) == 1 and vim.bo[b].buflisted then
		vim.cmd("buffer " .. b)
	else
		table.remove(h.bufs, h.idx)
		h.idx = math.min(#h.bufs, h.idx)
	end
	vim.schedule(function()
		navigating = false
	end)
end, { desc = "Next buffer (history)" })

vim.keymap.set("n", "<A-c>", function()
	local h = tab_hist()
	h.bufs = { vim.fn.bufnr("%") }
	h.idx = 1
	vim.notify("Buffer history cleared")
end, { desc = "Clear buffer history" })

vim.keymap.set("n", "<A-q>", function()
	local current = vim.fn.bufnr("%")
	local h = tab_hist()

	for i = #h.bufs, 1, -1 do
		if h.bufs[i] == current then
			table.remove(h.bufs, i)
			if i <= h.idx then
				h.idx = math.max(1, h.idx - 1)
			end
		end
	end

	if #h.bufs > 0 and h.idx <= #h.bufs then
		navigating = true
		vim.cmd("buffer " .. h.bufs[h.idx])
		vim.schedule(function()
			navigating = false
		end)
	end

	vim.cmd("bd " .. current)
end, { desc = "Close buffer + keep history" })

vim.api.nvim_create_autocmd("TabClosed", {
	callback = function()
		local closed = tonumber(vim.fn.expand("<afile>"))
		if closed then
			hist_by_tab[closed] = nil
		end
	end,
})

-- editing helpers
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<leader>j", "gJdw:j!<CR>", { silent = true, desc = "Collapse tag line" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- centered paging
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- close floats + clear refs
vim.keymap.set("n", "<leader>x", function()
	vim.lsp.buf.clear_references()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local cfg = vim.api.nvim_win_get_config(win)
		if cfg.relative ~= "" then
			pcall(vim.api.nvim_win_close, win, false)
		end
	end
end, { desc = "Close floating windows" })
