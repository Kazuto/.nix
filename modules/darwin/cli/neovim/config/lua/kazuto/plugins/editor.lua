vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- File explorer
-- https://github.com/nvim-tree/nvim-tree.lua
local nvimtree = {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("nvim-tree").setup({
			disable_netrw = true,
			hijack_netrw = true,
			open_on_tab = false,
			hijack_cursor = false,
			update_cwd = true,
			hijack_directories = {
				enable = true,
				auto_open = true,
			},
			diagnostics = {
				enable = true,
				icons = {
					hint = "",
					info = "",
					warning = "",
					error = "",
				},
			},
			update_focused_file = {
				enable = true,
				update_cwd = true,
				ignore_list = {},
			},
			git = {
				enable = true,
				ignore = false,
				timeout = 500,
			},
			view = {
				width = 30,
				adaptive_size = true,
			},
			renderer = {
				highlight_git = true,
				root_folder_modifier = ":t",
				root_folder_label = false,
				group_empty = true,
				icons = {
					show = {
						file = true,
						folder = true,
						folder_arrow = false,
						git = true,
					},
					glyphs = {
						default = "",
						symlink = "",
						git = {
							unstaged = "",
							staged = "S",
							unmerged = "",
							renamed = "➜",
							deleted = "",
							untracked = "U",
							ignored = "◌",
						},
						folder = {
							default = "",
							open = "",
							empty = "",
							empty_open = "",
							symlink = "",
						},
					},
				},
				indent_markers = {
					enable = true,
					inline_arrows = true,
					icons = {
						corner = "└",
						edge = "│",
						item = "│",
						none = " ",
					},
				},
			},
		})
	end,
	keys = {
		{ "<leader>e", vim.cmd.NvimTreeToggle, desc = "Toggle Nvim Tree" },
	},
}

-- Fuzzy finder
-- https://github.com/nvim-telescope/telescope.nvim
local telescope = {
	"nvim-telescope/telescope.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { truncate = 1 },
				prompt_prefix = "   ",
				selection_caret = " ",
				entry_prefix = "",
				layout_config = {
					prompt_position = "top",
				},
				sorting_strategy = "ascending",
				mappings = {
					i = {
						["<esc>"] = actions.close,
						["<C-Down>"] = actions.cycle_history_next,
						["<C-Up>"] = actions.cycle_history_prev,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
					},
				},
				file_ignore_patterns = { "node_modules", ".git", "vendor" },
			},
			pickers = {
				find_files = {
					hidden = true,
				},
			},
		})

		telescope.load_extension("fzf")
	end,
	keys = {
		{ "<leader>ff", ":Telescope find_files<CR>", desc = "[F]ind [F]iles" },
		{ "<leader>fa", ":Telescope find_files follow=true no_ingore=true hidden=true<CR>", desc = "[F]ind [A]ll" },
		{ "<leader>fs", ":Telescope live_grep<CR>", desc = "[F]ind [S]tring" },
		{ "<leader>fc", ":Telescope grep_string<CR>", desc = "[F]ind [C]ursor" },
		{ "<leader>fb", ":Telescope buffers<CR>", desc = "[F]ind [B]uffer" },
		{ "<leader>fh", ":Telescope oldfiles<CR>", desc = "[F]ind [H]istory" },
	},
}

-- Useful plugin to show you pending keybinds
-- https://github.com/folke/which-key.nvim
vim.o.timeout = true
vim.o.timeoutlen = 300

local which_key = {
	"folke/which-key.nvim",
	dependencies = {
		"echasnovski/mini.icons",
	},
	opts = {
		preset = "modern",
	},
	keys = { "<leader>", '"', "'", "`", "c", "v" },
	event = { "VeryLazy" },
}

-- Show changes to a file
-- https://github.com/mbbill/undotree
local undotree = {
	"mbbill/undotree",
	keys = {
		{ "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "[U]ndo Tree" },
	},
}

-- Show definitions etc. !required ctags!
-- https://github.com/preservim/tagbar
local tagbar = {
	"preservim/tagbar",
	keys = {
		{ "<F8>", ":TagbarToggle<CR>", desc = "Toggle Tagbar" },
	},
}

-- Super fast git decorations
-- https://github.com/lewis6991/gitsigns.nvim
local gitsigns = {
	"lewis6991/gitsigns.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("gitsigns").setup({})
	end,
	keys = {
		{ "<leader>gp", ":Gitsigns prev_hunk<CR>", desc = "[G]o to [P]revious Hunk" },
		{ "<leader>gn", ":Gitsigns next_hunk<CR>", desc = "[G]o to [N]ext Hunk" },
		{ "<leader>hp", ":Gitsigns preview_hunk<CR>", desc = "[H]unk [P]review" },
		{ "<leader>hr", ":Gitsigns reset_hunk<CR>", desc = "[H]unk [R]eset" },
		{ "<leader>hS", ":Gitsigns stage_buffer<CR>", desc = "[S]tage [B]uffer" },
	},
	event = { "VeryLazy" },
}

-- Highlight other uses of the current word
-- https://github.com/rrethy/vim-illuminate
local illuminate = {
	"RRethy/vim-illuminate",
	config = function()
		require("illuminate").configure({
			under_cursor = false,
		})
	end,
}

-- A fancy, configurable, notification manager for NeoVim
-- https://github.com/rcarriga/nvim-notify
local vim_notify = {
	"rcarriga/nvim-notify",
	config = function()
		local notify = require("notify")
		-- this for transparency
		notify.setup({ background_colour = "#000000" })
		-- this overwrites the vim notify function
		vim.notify = notify.notify
	end,
}

-- Smooth scrolling
-- https://github.com/karb94/neoscroll.nvim
local neoscroll = {
	"karb94/neoscroll.nvim",
	config = function()
		require("neoscroll").setup()
	end,
}

return {
	nvimtree,
	telescope,
	which_key,
	undotree,
	tagbar,
	gitsigns,
	illuminate,
	vim_notify,
	neoscroll,
}
