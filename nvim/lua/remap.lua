vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Oil)

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- move lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- don't move cursor after join
vim.keymap.set("n", "J", "mzJ`z")
-- keep cursor centered when jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- keep cursor centered when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- paste without overwriting vim paste register
vim.keymap.set("x", "p", [["+P]])
-- paste from system clipboard
vim.keymap.set({ "n", "v" }, "y", [["+y]])
vim.keymap.set("n", "Y", [["+Y]])

-- never press Q
vim.keymap.set("n", "Q", "<nop>")

-- formats the whole file
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- quickfix list navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- change all instances of selected word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- navigate between windows with leader key
vim.keymap.set("n", "<leader>h", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<leader>j", "<C-w><C-j>", { desc = "Move focus to the bottom window" })
vim.keymap.set("n", "<leader>k", "<C-w><C-k>", { desc = "Move focus to the top window" })
vim.keymap.set("n", "<leader>l", "<C-w><C-l>", { desc = "Move focus to the right window" })
