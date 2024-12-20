local lualine = {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"arkav/lualine-lsp-progress",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				section_separators = "",
				component_separators = "",
				globalstatus = true,
				theme = {
					normal = {
						a = "StatusLine",
						b = "StatusLine",
						c = "StatusLine",
					},
				},
			},
			sections = {
				lualine_a = {
					"mode",
				},
				lualine_b = {
					"branch",
					{
						"diff",
						symbols = { added = " ", modified = " ", removed = " " },
					},
					function()
						return "󰅭 " .. vim.pesc(tostring(#vim.tbl_keys(vim.lsp.get_clients())) or "")
					end,
					{ "diagnostics", sources = { "nvim_diagnostic" } },
				},
				lualine_c = {
					"filename",
				},
				lualine_x = {
					{
						require("lazy.status").updates,
						cond = require("lazy.status").has_updates,
						color = { fg = "#ff9e64" },
					},
				},
				lualine_y = {
					"filetype",
					"encoding",
					"fileformat",
					'(vim.bo.expandtab and "␠ " or "⇥ ") .. vim.bo.shiftwidth',
				},
				lualine_z = {
					"searchcount",
					"selectioncount",
					"location",
					"progress",
				},
			},
		})
	end,
}

local indent_blankline = {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	config = function()
		require("ibl").setup({
			exclude = {
				filetypes = {
					"dashboard",
				},
			},
			scope = { enabled = false },
		})
	end,
}

local bufferline = {
	"akinsho/bufferline.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("bufferline").setup({
			options = {
				indicator = {
					icon = " ",
				},
				show_close_icon = true,
				tab_size = 0,
				max_name_length = 25,
				offsets = {
					{
						filetype = "NvimTree",
						text = "  Files",
						highlight = "StatusLine",
						text_align = "left",
					},
					{
						filetype = "undotree",
						text = "  History",
						highlight = "StatusLine",
						text_align = "left",
					},
				},
				hover = {
					enabled = true,
					delay = 0,
					reveal = { "close" },
				},
				modified_icon = "",
				custom_areas = {
					left = function()
						return {
							{ text = "    ", fg = "#8fff6d" },
						}
					end,
				},
				diagnostics = "nvim_lsp",
				vim.diagnostic.config({ update_in_insert = true }),
				diagnostics_update_on_event = true,
				diagnostics_indicator = function(count, level)
					local icon = level:match("error") and " " or " "
					return icon .. count
				end,
				highlights = {
					fill = {
						bg = { attribute = "bg", highlight = "StatusLine" },
					},
					buffer_selected = {
						italic = false,
					},
					separator = {
						fg = { attribute = "bg", highlight = "StatusLine" },
						bg = { attribute = "bg", highlight = "BufferlineInactive" },
					},
				},
			},
		})
	end,
}

local shortcuts = {
	{
		icon = " ",
		icon_hl = "@variable",
		group = "Label",
		desc = "New File ",
		key = "n",
		key_format = " %s", -- remove default surrounding `[]`
		action = "enew",
	},
	{
		icon = " ",
		icon_hl = "@variable",
		group = "Label",
		desc = "Find File ",
		key = "f",
		key_format = " %s", -- remove default surrounding `[]`
		action = "Telescope find_files cwd=",
	},
	{
		icon = " ",
		icon_hl = "@variable",
		desc = "Find Text ",
		group = "Label",
		key = "F",
		key_format = " %s", -- remove default surrounding `[]`
		action = "Telescope live_grep",
	},
	{
		icon = " ",
		icon_hl = "@variable",
		desc = "Update Plugins ",
		group = "Label",
		key = "u",
		key_format = " %s", -- remove default surrounding `[]`
		action = "Lazy update",
	},
}

local dashboard = {
	"glepnir/dashboard-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("dashboard").setup({
			config = {
				header = {
					"                                        ",
					"                                        ",
					"        ..............    ......        ",
					"         ............    ......         ",
					"              ................          ",
					"             ................           ",
					"            ......  ....                ",
					"             ....   .....               ",
					"              ..    .....               ",
					"                  ......                ",
					"                 ......                 ",
					"                 .....                  ",
					"                   ..                   ",
					"                                        ",
					"                                        ",
				},
				center = shortcuts,
				packages = { enable = true }, -- show how many plugins neovim loaded
				project = { enable = true, icon = " ", limit = 3 },
				mru = { limit = 3, icon = " ", label = "Recent files", cwd_only = true },
				shortcut = shortcuts,
				footer = { "" },
			},
		})
	end,
	event = "VimEnter",
}

return {
	lualine,
	indent_blankline,
	bufferline,
	dashboard,
}
