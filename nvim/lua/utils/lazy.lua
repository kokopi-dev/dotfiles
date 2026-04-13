local M = {}

local loaded = {}

function M.load_once(key, plugins, setup)
	if loaded[key] then
		return
	end
	loaded[key] = true
	vim.pack.add(plugins)
	if setup then
		setup()
	end
end

return M
