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
