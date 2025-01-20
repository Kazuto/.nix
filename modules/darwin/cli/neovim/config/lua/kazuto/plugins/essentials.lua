-- A super powerful autopair plugin for Neovim that supports multiple characters.
-- https://github.com/windwp/nvim-autopairs
local autopairs = {
	"windwp/nvim-autopairs",
	dependencies = {
		"hrsh7th/nvim-cmp",
	},
	config = function()
		require("nvim-autopairs").setup({
			disable_filetype = { "TelescopePrompt" },
		})
	end,
	event = "InsertEnter",
}

-- Smart and Powerful commenting plugin
-- -- https://github.com/numToStr/Comment.nvim
local comment = {
	"numToStr/Comment.nvim",
	config = function()
		require("Comment").setup()
	end,
}

-- Quick access to attached files
-- https://github.com/theprimeagen/harpoon
local harpoon = {
	"theprimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local harpoon = require("harpoon")

		harpoon:setup()

		vim.keymap.set("n", "<leader>ha", function()
			harpoon:list():add()
		end, { desc = "[H]arpoon [A]dd" })

		vim.keymap.set("n", "<leader>hd", function()
			harpoon:list():remove()
		end, { desc = "[H]arpoon [R]emove" })

		vim.keymap.set("n", "<leader>hl", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "[H]arpoon [L]ist" })
	end,
}

-- Align text by characters
-- https://github.com/tommcdo/vim-lion
local lion = {
	"tommcdo/vim-lion",
	config = function()
		vim.g.lion_squeeze_spaces = 1 -- Remove as many spaces as possible when aligning
	end,
}

-- Keep indentation when pasting
-- https://github.com/RRethy/vim-pasta
local pasta = {
	"sickill/vim-pasta",
	config = function()
		vim.g.pasta_disabled_filetypes = { "fugitive" }
	end,
}

-- Split or join lines of code
-- https://github.com/AndrewRadev/splitjoin.vim
local splitjoin = {
	"AndrewRadev/splitjoin.vim",
	config = function()
		vim.g.splitjoin_html_attributes_bracket_on_new_line = 1
		vim.g.splitjoin_trailing_comma = 1
		vim.g.splitjoin_php_method_chain_full = 1
	end,
}

-- Show a floating terminal
-- https://github.com/akinsho/toggleterm.nvim
local toggleterm = {
	"akinsho/toggleterm.nvim",
	config = function()
		require("toggleterm").setup({
			size = 20,
			open_mapping = [[<F1>]],
			hide_numbers = true,
			shade_filetypes = {},
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			persist_size = true,
			direction = "float",
			close_on_exit = true,
			shell = vim.o.shell,
			float_opts = {
				border = "curved",
				winblend = 0,
				highlights = {
					border = "Normal",
					background = "Normal",
				},
			},
		})
	end,
}

-- A vim text object for XML/HTML attributes.
-- https://github.com/whatyouhide/vim-textobj-xmlattr
local vim_textobj_xmlattr = {
	"whatyouhide/vim-textobj-xmlattr",
	dependencies = {
		"kana/vim-textobj-user",
	},
}

-- Multi-Cursor selection
-- https://github.com/mg979/vim-visual-multi
local vim_visual_multi = {
	"mg979/vim-visual-multi",
}

return {
	autopairs,
	comment,
	harpoon,
	lion,
	pasta,
	splitjoin,
	toggleterm,
	{
		"tpope/vim-fugitive",
		dependencies = {
			"tpope/vim-rhubarb",
		},
	},
	{ "tpope/vim-repeat" }, -- Allow plugins to hook into repeat (.)
	{ "tpope/vim-surround" }, -- Replace surrounding quotes or tags
	{ "tpope/vim-sleuth" }, -- Automatically detect indentation
	-- { "sheerun/vim-polyglot" },             -- A collection of language packs
	{ "farmergreg/vim-lastplace" }, -- Restore cursor position in files
	{ "nelstrom/vim-visual-star-search" }, -- Enable * for visually selected text
	{ "jessarcher/vim-heritage" }, -- Automatically create parent directories when saving
	{ "airblade/vim-rooter" }, -- Change working directory to project root
	{ "christoomey/vim-tmux-navigator" }, -- tmux & split window navigation
	vim_textobj_xmlattr,
	vim_visual_multi,
}
