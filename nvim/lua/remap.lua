vim.g.mapleader = " "

-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
-- Open project folder view
vim.keymap.set('n', '<leader>E', '<cmd>:Ex<CR>')
vim.keymap.set('n', '<leader>ER', '<cmd>:bw<CR>')
-- Set current window as current root directory for searching
vim.keymap.set("n", "<leader>sr", ":cd %:p:h<CR>")

-- Split window movement
vim.keymap.set("n", "<A-Left>", "<C-w>h")
vim.keymap.set("n", "<A-Down>", "<C-w>j")
vim.keymap.set("n", "<A-Up>", "<C-w>k")
vim.keymap.set("n", "<A-Right>", "<C-w>l")

-- netrw duplicate file, <leader>d
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'netrw',
    callback = function()
        vim.keymap.set('n', '<leader>d', function()
            -- Save current directory
            local original_dir = vim.fn.getcwd()

            -- Change to the directory shown in netrw
            vim.cmd('lcd %:p:h')

            -- Feed the keys with proper mode flag
            vim.api.nvim_feedkeys('mt', 'x', false)
            vim.api.nvim_feedkeys('mf', 'x', false)
            vim.api.nvim_feedkeys('mc', 'x', false)

            -- Return to original directory after delay
            vim.defer_fn(function()
                vim.fn.chdir(original_dir)
            end, 500)
        end, { buffer = true, desc = 'Duplicate file in netrw' })
    end,
})

-- Jump buffers movement
local tab_buffer_histories = {}
local is_navigating = false

local function get_current_tab_history()
    local tab = vim.fn.tabpagenr()
    if not tab_buffer_histories[tab] then
        tab_buffer_histories[tab] = {
            buffers = {},
            index = 1
        }
    end
    return tab_buffer_histories[tab]
end

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        if is_navigating then return end
        local buf = vim.fn.bufnr('%')
        if not vim.bo[buf].buflisted then return end
        local history = get_current_tab_history()

        -- Remove any existing occurrence of this buffer from history
        for i = #history.buffers, 1, -1 do
            if history.buffers[i] == buf then
                table.remove(history.buffers, i)
                if i < history.index then
                    history.index = history.index - 1
                elseif i == history.index then
                    history.index = math.max(1, history.index - 1)
                end
            end
        end

        -- If we're in the middle of history and switch to a new buffer,
        -- truncate future history
        if history.index < #history.buffers then
            for i = #history.buffers, history.index + 1, -1 do
                table.remove(history.buffers)
            end
        end

        -- Add the buffer to history
        table.insert(history.buffers, buf)
        history.index = #history.buffers
    end
})

vim.keymap.set("n", "<A-b>", function()
    local history = get_current_tab_history()
    if history.index > 1 then
        is_navigating = true
        history.index = history.index - 1
        local target_buf = history.buffers[history.index]

        -- Check if buffer still exists and is valid
        if vim.fn.bufexists(target_buf) == 1 and vim.bo[target_buf].buflisted then
            vim.cmd('buffer ' .. target_buf)
        else
            -- Skip invalid buffers
            table.remove(history.buffers, history.index)
            history.index = math.max(1, history.index - 1)
        end

        vim.schedule(function() is_navigating = false end)
    end
end)

vim.keymap.set("n", "<A-n>", function()
    local history = get_current_tab_history()
    if history.index < #history.buffers then
        is_navigating = true
        history.index = history.index + 1
        local target_buf = history.buffers[history.index]

        -- Check if buffer still exists and is valid
        if vim.fn.bufexists(target_buf) == 1 and vim.bo[target_buf].buflisted then
            vim.cmd('buffer ' .. target_buf)
        else
            -- Skip invalid buffers
            table.remove(history.buffers, history.index)
            history.index = math.min(#history.buffers, history.index)
        end

        vim.schedule(function() is_navigating = false end)
    end
end)

vim.keymap.set("n", "<A-c>", function()
    local current_buf = vim.fn.bufnr('%')
    local history = get_current_tab_history()
    history.buffers = { current_buf }
    history.index = 1
    print("Buffer history cleared")
end)

vim.keymap.set("n", "<A-q>", function()
    local current_buf = vim.fn.bufnr('%')
    local history = get_current_tab_history()
    -- Remove current buffer from history
    for i = #history.buffers, 1, -1 do
        if history.buffers[i] == current_buf then
            table.remove(history.buffers, i)
            if i <= history.index then
                history.index = math.max(1, history.index - 1)
            end
        end
    end
    -- Navigate to previous buffer in history if available
    if #history.buffers > 0 and history.index <= #history.buffers then
        is_navigating = true
        vim.cmd('buffer ' .. history.buffers[history.index])
        vim.schedule(function() is_navigating = false end)
    end
    -- Delete the buffer
    vim.cmd('bd ' .. current_buf)
end)

-- Clean up history when a tab is closed
vim.api.nvim_create_autocmd("TabClosed", {
    callback = function()
        local closed_tab = tonumber(vim.fn.expand("<afile>"))
        if closed_tab then
            tab_buffer_histories[closed_tab] = nil
        end
    end
})

-- Makes shift+j not move cursor to the end
vim.keymap.set("n", "J", "mzJ`z")
-- collapse a tag with the cursor at the start of the tag
vim.keymap.set("n", "<leader>j", "gJdw:j!<CR>", { silent = true })

-- nnoremap <silent> <C-l> :nohl<CR><C-l>
-- vim.keymap.set("n", "<C-l>", vim.cmd(":nohl<CR><C-l>"))

-- Visual Mode: Move blocks of lines up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv'")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv'")

-- Autopairs sometimes wraps things, and sometimes doesnt
-- This is for wrapping a word in a pair
vim.keymap.set("n", "<leader>e{", "bcw{}<ESC>P")
vim.keymap.set("n", "<leader>e[", "bcw[]<ESC>P")
vim.keymap.set("n", "<leader>e<", "bcw<><ESC>P")
vim.keymap.set("n", "<leader>e(", "bcw()<ESC>P")
vim.keymap.set("n", "<leader>e'", "bcw''<ESC>P")
vim.keymap.set("n", "<leader>e\"", "bcw\"\"<ESC>P")
vim.keymap.set("n", "<leader>e`", "bcw``<ESC>P")

-- vertical movements
-- center cursor after going up or down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")


-- lsp restart
vim.keymap.set('n', '<leader>l', function()
  vim.cmd('LspRestart')
  vim.defer_fn(function()
    -- Reload the plugin module
    package.loaded['symbol-usage'] = nil
    require('symbol-usage').refresh()
  end, 1000)
end, { desc = 'Restart LSP and reload symbol-usage' })
