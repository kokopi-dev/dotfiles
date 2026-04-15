-- custom mason commands
local M = {}

function M.setup_install_defaults_command(tools)
	pcall(vim.api.nvim_del_user_command, "MasonInstallDefaults")
	vim.api.nvim_create_user_command("MasonInstallDefaults", function()
		local registry = require("mason-registry")
		registry.refresh(function()
			local seen, to_install = {}, {}
			for _, tool in ipairs(tools) do
				if tool.mason and not seen[tool.mason] then
					seen[tool.mason] = true
					local ok, pkg = pcall(registry.get_package, tool.mason)
					if ok and not pkg:is_installed() then
						table.insert(to_install, pkg)
					end
				end
			end

			if #to_install == 0 then
				vim.notify("MasonInstallDefaults: all tools already installed", vim.log.levels.INFO)
				return
			end
			for _, pkg in ipairs(to_install) do
				pkg:install()
			end
			vim.notify(("MasonInstallDefaults: installing %d tool(s)"):format(#to_install), vim.log.levels.INFO)
		end)
	end, { desc = "Install missing Mason tools from tool registry" })
end

return M
