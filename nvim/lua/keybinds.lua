vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP show documentation" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP goto definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "LSP goto declaration" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Focus split left" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Focus split right" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Focus split down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Focus split up" })

vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Q (Ex mode)" })
vim.keymap.set("n", "E", "ge", { desc = "Select end of word backwards" })
vim.keymap.set("n", "Y", "y$", { desc = "Yank until end of line" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Turn off hlsearch" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Jump to next search result and center view" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Jump to previous search result and center view" })
vim.keymap.set("n", "*", "*zzzv", { desc = "Jump to next word under cursor and center view" })
vim.keymap.set("n", "#", "#zzzv", { desc = "Jump to previous word under cursor and center view" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines" })

vim.keymap.set("i", ",", ",<c-g>u", { desc = "Stop undo at periods" })
vim.keymap.set("i", ".", ".<c-g>u", { desc = "Stop undo at commas" })
vim.keymap.set("i", "!", "!<c-g>u", { desc = "Stop undo at exclamation marks" })
vim.keymap.set("i", "?", "?<c-g>u", { desc = "Stop undo at question marks" })

vim.keymap.set("n", "<c-t>", "<cmd>split | term<CR>", { desc = "Open split terminal buffer" })
vim.keymap.set("t", "<leader>q", [[<C-\><C-n>]], { desc = "Exit terminal to normal mode" })
vim.keymap.set("t", "<c-t>", "<cmd>q<CR>", { desc = "Close terminal" })

vim.keymap.set({ "n", "i", "v" }, "<LeftMouse>", "<nop>", {desc = "Prevent mouse clicks from moving the cursor"})
vim.keymap.set({ "n", "i", "v" }, "<2-LeftMouse>", "<nop>", {desc = "Prevent mouse clicks from moving the cursor"})

vim.keymap.set("n", "<leader>b", function()
    local current_file = vim.fn.expand("%:p")
    if current_file == "" then
        vim.notify("No file open in current buffer", vim.log.levels.WARN)
        return
    end
    vim.fn.jobstart({ "librewolf", current_file }, { detach = true })
end, { desc = "Open current file in browser (Librewolf)" })
