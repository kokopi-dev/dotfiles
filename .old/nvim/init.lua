-- All plugin settings are in after/plugin
require("harukai.packer")
require("harukai.remap")
require("harukai.settings")

-- Clears jump list (check with :ju)
vim.api.nvim_create_autocmd({"VimEnter"}, {command = "clearjumps"})

vim.api.nvim_create_autocmd({"BufNewFile"}, {
    pattern = "*.py",
    command = "0r ~/.config/nvim/skel/py.skel"
})
-- Refreshers:
-- <leader>pv = open project folder navigation view (netrw)
--   - % in pv creates a new file in the directory
--   - D deletes file
-- :so = sourcing root file
--
-- Hoverdocs: CTRL-f = forward, CTRL-d = backwards
