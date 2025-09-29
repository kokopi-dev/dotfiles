-- leader timeout
vim.opt.timeoutlen = 350
-- Vim sets and globals
vim.opt.wrap = true
vim.opt.relativenumber = true
vim.opt.mouse = "nvi"
vim.opt.clipboard = "unnamedplus" -- Able to yank and paste crap from anywhere
vim.opt.guicursor = "i-ci:ver30-iCursor-blinkwait300-blinkon200-blinkoff150"
vim.opt.termguicolors = true
vim.opt.encoding = "utf-8"
vim.opt.cursorline = true -- Current line tracking
vim.opt.number = true -- Current line number display

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.updatetime = 50
vim.opt.signcolumn = "no"
vim.opt.scrolloff = 8

-- Indenting
-- vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = {"typescriptreact", "typescript", "javascript", "css", "html", "htmldjango", "yaml", "json", "md", "toml"},
    command = "setlocal shiftwidth=2 tabstop=2 softtabstop=2"
})

vim.g.grepper = {tools = {"rg"}} -- This is for replace in project, ripgrep required
vim.opt.wildignore:append{"*/node_modules/*", "*/venv/*"}
vim.opt.path:append{"**"} -- find files down subfolders
vim.g.python_host_prog = "/usr/bin/python2"
vim.g.python3_host_prog = "/usr/bin/python3"

-- skeletons
vim.cmd [[autocmd BufNewFile *.py 0r ~/.config/nvim/templates/skeleton.py]]
vim.cmd [[autocmd BufNewFile *.sh 0r ~/.config/nvim/templates/skeleton.sh]]

-- filetypes
vim.filetype.add({
    extension = {
        templ = "templ",
    },
})

-- popout styling
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
  end,
})
vim.keymap.set('n', '<leader>x', function()
  vim.lsp.buf.clear_references()
  local win_ids = vim.fn.getwininfo()
  for _, win in pairs(win_ids) do
    if win.quickfix == 0 and win.loclist == 0 and win.terminal == 0 and win.tabnr == vim.fn.tabpagenr() then
      if vim.api.nvim_win_get_config(win.winid).relative ~= '' then
        vim.api.nvim_win_close(win.winid, false)
      end
    end
  end
end, { desc = "Close LSP floating windows" })

-- disable italics on conditionals
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Get all highlight groups and remove italic styling
    for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
      local hl = vim.api.nvim_get_hl(0, { name = group })
      if hl.italic then
        hl.italic = nil
        vim.api.nvim_set_hl(0, group, hl)
      end
    end
  end,
})
