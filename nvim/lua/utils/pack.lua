local M = {}

local registry = require("plugins.registry")

function M.registry(names)
	return registry.by_names(names)
end

function M.add(names, opts)
	vim.pack.add(M.registry(names), opts)
end

function M.names()
	return registry.names()
end

return M
