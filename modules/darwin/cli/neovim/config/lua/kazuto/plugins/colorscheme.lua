local api = vim.api

return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			vim.cmd("colorscheme catppuccin")

			api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = "#313244" })

			api.nvim_set_hl(0, "IndentBlanklineChar", {
				fg = api.nvim_get_hl_by_name("LineNr", true).background,
			})

			api.nvim_set_hl(0, "StatusLineNonText", {
				fg = api.nvim_get_hl_by_name("NonText", true).background,
				bg = api.nvim_get_hl_by_name("StatusLine", true).background,
			})

			api.nvim_set_hl(0, "MiniHipatternsFixme", {
				fg = api.nvim_get_hl_by_name("Normal", true).background,
				bg = api.nvim_get_hl_by_name("DiagnosticError", true).foreground,
			})

			api.nvim_set_hl(0, "MiniHipatternsHack", {
				fg = api.nvim_get_hl_by_name("Normal", true).background,
				bg = api.nvim_get_hl_by_name("DiagnosticWarn", true).foreground,
			})

			api.nvim_set_hl(0, "MiniHipatternsTodo", {
				fg = api.nvim_get_hl_by_name("Normal", true).background,
				bg = api.nvim_get_hl_by_name("DiagnosticInfo", true).foreground,
			})

			api.nvim_set_hl(0, "MiniHipatternsNote", {
				fg = api.nvim_get_hl_by_name("Normal", true).background,
				bg = api.nvim_get_hl_by_name("DiagnosticHint", true).foreground,
			})
		end,
	},
	{
		"echasnovski/mini.hipatterns",
		event = "BufReadPre",
		config = function()
			local hipatterns = require("mini.hipatterns")
			hipatterns.setup({
				highlighters = {
					-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
					fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
					hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
					todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
					note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

					-- Highlight hex color strings (`#ff9900`) using that color
					hex_color = hipatterns.gen_highlighter.hex_color(),

					-- Highlight hsl color strings (`hsl(180, 100, 100)`) using that color
					hsl_color = {
						pattern = "hsl%(%d+,? %d+,? %d+%)",
						group = function(_, match)
							local colors = require("kazuto.utils.colors")
							local h, s, l = match:match("hsl%((%d+),? (%d+),? (%d+)%)")
							h, s, l = tonumber(h), tonumber(s), tonumber(l)

							return hipatterns.compute_hex_color_group(colors.hslToHex(h, s, l), "bg")
						end,
					},
				},
			})
		end,
	},
}
