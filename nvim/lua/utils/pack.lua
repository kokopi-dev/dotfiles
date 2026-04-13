local M = {}

local registry = require("plugins.registry")

function M.registry(names)
	return registry.by_names(names)
end

-- Backward-compatible alias
M.specs = M.registry

function M.add(names, opts)
	vim.pack.add(M.registry(names), opts)
end

function M.names()
	return registry.names()
end

function M.setup()
	local group = vim.api.nvim_create_augroup("UserPackHooks", { clear = true })

	vim.api.nvim_create_autocmd("PackChanged", {
		group = group,
		callback = function(ev)
			local name, kind = ev.data.spec.name, ev.data.kind
			if name == "nvim-treesitter" and kind == "update" then
				if not ev.data.active then
					vim.cmd.packadd("nvim-treesitter")
				end
				pcall(vim.cmd, "TSUpdate")
			end
		end,
	})

	vim.api.nvim_create_user_command("PackInstall", function()
		M.add(M.names(), {
			confirm = false,
			load = function() end,
		})
		vim.notify("PackInstall: ensured all configured plugins are installed", vim.log.levels.INFO)
	end, { desc = "Install all configured vim.pack plugins without loading" })

	vim.api.nvim_create_user_command("PackUpdate", function(opts)
		local names = (#opts.fargs > 0) and opts.fargs or nil
		vim.pack.update(names)
	end, {
		nargs = "*",
		complete = function(arglead)
			local out = {}
			for _, name in ipairs(M.names()) do
				if name:find("^" .. vim.pesc(arglead)) then
					table.insert(out, name)
				end
			end
			return out
		end,
		desc = "Update vim.pack plugins (optionally pass plugin names)",
	})

	vim.api.nvim_create_user_command("PackSync", function()
		vim.pack.update(nil, { target = "lockfile" })
	end, { desc = "Sync installed plugins to nvim-pack-lock.json" })

	vim.api.nvim_create_user_command("PackClean", function()
		local stale = vim.iter(vim.pack.get())
			:filter(function(p)
				return not p.active
			end)
			:map(function(p)
				return p.spec.name
			end)
			:totable()

		if #stale == 0 then
			vim.notify("PackClean: nothing to clean", vim.log.levels.INFO)
			return
		end

		local msg = "PackClean will remove:\n  - " .. table.concat(stale, "\n  - ")
		local choice = vim.fn.confirm(msg, "&Yes\n&No", 2)
		if choice ~= 1 then
			vim.notify("PackClean: cancelled", vim.log.levels.INFO)
			return
		end

		vim.pack.del(stale)
		vim.notify("PackClean: removed " .. #stale .. " plugin(s)", vim.log.levels.INFO)
	end, { desc = "Delete inactive vim.pack plugins from disk" })
end

return M
