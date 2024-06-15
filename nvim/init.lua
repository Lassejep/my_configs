require("remap")
require("set")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Automatically detect tab width.
	"tpope/vim-sleuth",
	-- Commenting plugin.
	{ "numToStr/Comment.nvim", opts = {} },
	-- Change the sign in the left margin to reflect git changes.
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	-- Telescope plugin, for fuzzy finding.
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "[P]roject [F]iles" })
			vim.keymap.set("n", "<leader>pw", builtin.grep_string, { desc = "[P]roject [W]ord" })
			vim.keymap.set("n", "<leader>ps", builtin.live_grep, { desc = "[P]roject [S]earch" })
		end,
	},
	-- LSP plugin.
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					-- LSP keybindings
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end
					if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			}
			require("mason").setup()
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
	-- Formatter plugin.
	{
		"stevearc/conform.nvim",
		lazy = false,
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
			},
		},
	},
	-- Completion plugin.
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {},
			},
			"saadparwaiz1/cmp_luasnip",

			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },

				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),

					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					["<C-y>"] = cmp.mapping.confirm({ select = true }),

					["<C-Space>"] = cmp.mapping.complete({}),

					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
				},
			})
		end,
	},
	-- Todo highlighting plugin.
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	-- Colorscheme plugin.
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavor = "mocha",
			transparent_background = true,
		},
		init = function()
			vim.cmd.colorscheme("catppuccin")
			vim.cmd.hi("Comment gui=none")
		end,
	},
	-- Collection of smaller QOL plugins.
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.surround").setup()
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},
	-- Treesitter plugin, for syntax highlighting.
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = { "bash", "c", "html", "lua", "luadoc", "markdown", "vim", "vimdoc", "markdown_inline" },
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
		config = function(_, opts)
			require("nvim-treesitter.install").prefer_git = true
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	-- Copilot integration
	{
		"github/copilot.vim",
		opt = {
			filetypes = { markdown = true },
		},
	},
	-- Git integration
	{
		"tpope/vim-fugitive",
		vim.keymap.set("n", "<leader>gs", vim.cmd.Git),
	},
	-- Fast file navigation
	{
		"theprimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("harpoon"):setup()
		end,
		keys = {
			{
				"<leader>a",
				function()
					require("harpoon"):list():add()
				end,
				desc = "harpoon file",
			},
			{
				"<C-e>",
				function()
					local harpoon = require("harpoon")
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "harpoon quick menu",
			},
			{
				"<leader>1",
				function()
					require("harpoon"):list():select(1)
				end,
				desc = "harpoon to file 1",
			},
			{
				"<leader>2",
				function()
					require("harpoon"):list():select(2)
				end,
				desc = "harpoon to file 2",
			},
			{
				"<leader>3",
				function()
					require("harpoon"):list():select(3)
				end,
				desc = "harpoon to file 3",
			},
			{
				"<leader>4",
				function()
					require("harpoon"):list():select(4)
				end,
				desc = "harpoon to file 4",
			},
			{
				"<leader>5",
				function()
					require("harpoon"):list():select(5)
				end,
				desc = "harpoon to file 5",
			},
		},
	},
	-- Undo tree plugin
	{
		"mbbill/undotree",
		keys = {
			{
				"<leader>u",
				vim.cmd.UndotreeToggle,
				desc = "Toggle [U]ndo tree",
			},
		},
	},
	-- Obsidian plugin
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			workspaces = {
				{
					name = "notes",
					path = "~/ws/notes",
				},
			},
			daily_notes = {
				folder = "daily",
				date_format = "%y-%m-%d",
				alias_format = "%y-%m-%d",
				template = "daily.md",
			},
			templates = {
				subdir = "templates",
				date_format = "%y-%m-%d",
				time_format = "%h:%m",
				substitutions = {},
			},
			completion = {
				complete = true,
				min_chars = 2,
			},
			picker = {
				name = "telescope.nvim",
				mappings = {
					new = "<C-x>",
					insert_link = "<C-l>",
				},
			},
			ui = {
				enable = false,
			},
			open_notes_in = "current",
			attachments = {
				img_folder = "screenshots",
				---@param client obsidian.Client
				---@param path obsidian.Path the absolute path to the image file
				---@return string
				img_text_func = function(client, path)
					path = client:vault_relative_path(path) or path
					return string.format("![%s](%s)", path.name, path)
				end,
			},
			---@param title string|?
			---@return string
			note_id_func = function(title)
				local name = ""
				if title ~= nil then
					name = title:gsub(" ", "_"):gsub("[^A-Za-z0-9-]", ""):lower()
				else
					name = tostring(os.time())
				end
				return name
			end,

			---@return string
			image_name_func = function()
				return tostring(os.date("%Y-%m-%d-%H-%M-%S"))
			end,
		},
		keys = {
			{
				"<leader>oo",
				vim.cmd.ObsidianOpen,
				desc = "Obsidian [O]pen",
			},
			{
				"<leader>on",
				vim.cmd.ObsidianNew,
				desc = "Obsidian [N]ew",
			},
			{
				"<leader>og",
				vim.cmd.ObsidianFollowLink,
				desc = "Obsidian [G]o to link",
			},
			{
				"<leader>ol",
				function()
					vim.cmd([[normal! viw]])
					vim.cmd.ObsidianLink()
				end,
				desc = "Obsidian [L]ink",
			},
			{
				"<leader>oln",
				function()
					vim.cmd([[normal! viw]])
					vim.cmd.ObsidianLinkNew()
				end,
				desc = "Obsidian [L]ink [N]ew",
			},
			{
				"<leader>of",
				vim.cmd.ObsidianQuickSwitch,
				desc = "Obsidian [Q]uick [S]witch",
			},
			{
				"<leader>os",
				vim.cmd.ObsidianSearch,
				desc = "Obsidian [S]earch",
			},
			{
				"<leader>or",
				vim.cmd.ObsidianRename,
				desc = "Obsidian [R]ename",
			},
			{
				"<leader>op",
				vim.cmd.ObsidianPasteImg,
				desc = "Obsidian [P]aste Image",
			},
			{
				"<leader>od",
				vim.cmd.ObsidianToday,
				desc = "Obsidian [D]aily note",
			},
			{
				"<leader>ot",
				vim.cmd.ObsidianTemplate,
				desc = "Obsidian [T]emplate",
			},
		},
	},
	-- Tmux navigation
	{
		"christoomey/vim-tmux-navigator",
		keys = {
			{
				"<C-h>",
				vim.cmd.TmuxNavigateLeft,
				desc = "Tmux Navigate [L]eft",
			},
			{
				"<C-j>",
				vim.cmd.TmuxNavigateDown,
				desc = "Tmux Navigate [D]own",
			},
			{
				"<C-k>",
				vim.cmd.TmuxNavigateUp,
				desc = "Tmux Navigate [U]p",
			},
			{
				"<C-l>",
				vim.cmd.TmuxNavigateRight,
				desc = "Tmux Navigate [R]ight",
			},
		},
	},
	-- Horizontal scrolling while writing
	{
		"Aasim-A/scrollEOF.nvim",
		config = function()
			require("scrollEOF").setup()
		end,
	},
	-- Better File Explorer
	{
		"stevearc/oil.nvim",
		opts = {
			default_file_explorer = true,
			view_options = {
				show_hidden = true,
			},
			use_default_keymaps = false,
			keymaps = {
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["<C-p>"] = "actions.preview",
				["<C-c>"] = "actions.close",
				["<leader>r"] = "actions.refresh",
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["~"] = "actions.tcd",
				["gs"] = "actions.change_sort",
				["gx"] = "actions.open_external",
				["g."] = "actions.toggle_hidden",
				["g\\"] = "actions.toggle_trash",
			},
		},
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.cmd([[
			function OpenMarkdownPreview (url)
				execute "silent ! firefox --new-window " . a:url
			endfunction
			]])
			vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
		end,
		ft = { "markdown" },
		keys = {
			{
				"<leader>mp",
				vim.cmd.MarkdownPreview,
				desc = "Markdown [P]review",
			},
		},
	},
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			task = "📌",
		},
	},
})
