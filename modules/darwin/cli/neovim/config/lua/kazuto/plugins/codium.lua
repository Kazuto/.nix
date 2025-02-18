vim.g.codeium_disable_bindings = 1

return {
	"Exafunction/codeium.vim",
	lazy = false,
	keys = {
		{
			"<C-CR>",
			function()
				return vim.fn["codeium#Accept"]()
			end,
			desc = "Accept Suggestion",
			expr = true,
			mode = "i",
		},
		{
			"<C-;>",
			function()
				return vim.fn["codeium#CycleCompletions"](1)
			end,
			desc = "Next Suggestion",
			expr = true,
			noremap = true,
			mode = "i",
		},
		{
			"<C-,>",
			function()
				return vim.fn["codeium#CycleCompletions"](-1)
			end,
			desc = "Previous Suggestion",
			expr = true,
			mode = "i",
		},
		{
			"<C-x>",
			function()
				return vim.fn["codeium#Clear"]()
			end,
			desc = "Clear Suggestions",
			expr = true,
			mode = "i",
		},
	},
}
