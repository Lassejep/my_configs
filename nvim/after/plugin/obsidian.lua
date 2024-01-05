require("obsidian").setup({
    lazy = true,
    ft = "markdown",

    dependencies = {
        "nvim-lua/plenary.nvim",
    },

    workspaces = {
        {
            name = "notes",
            path = "~/ws/notes",
        },
    },

    daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
    },

    templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
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
