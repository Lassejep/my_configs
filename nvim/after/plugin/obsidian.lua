require("obsidian").setup({
  lazy = true,
  event = {
    "BufReadPre /home/tinspring/ws/notes/notes/**.md",
    "BufNewFile /home/tinspring/ws/notes/notes/**.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    open_app_foreground = true,
  },
})

vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<cr>", { silent = true })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>")
vim.keymap.set("n", "<leader>og", "<cmd>ObsidianFollowLink<cr>")
vim.keymap.set("n", "<leader>ol", "viw<cmd>ObsidianLink<cr>")
vim.keymap.set("n", "<leader>oln", "viw<cmd>ObsidianLinkNew<cr>")
vim.keymap.set("n", "<leader>of", "<cmd>ObsidianQuickSwitch<cr>")
vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<cr>")
vim.keymap.set("n", "<leader>or", "<cmd>ObsidianRename<cr>")
