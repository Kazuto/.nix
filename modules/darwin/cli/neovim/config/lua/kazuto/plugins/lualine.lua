-- A blazing fast and easy to configure Neovim statusline written in Lua.
-- https://github.com/nvim-lualine/lualine.nvim
return {
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
