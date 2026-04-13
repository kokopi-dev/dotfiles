local M = {}

local loaded = {}

function M.load_once(key, specs, setup)
	if loaded[key] then
		return
	end
	loaded[key] = true
	vim.pack.add(specs)
	if setup then
		setup()
	end
end

return M
