-- Super fast git decorations
-- https://github.com/lewis6991/gitsigns.nvim
return {
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
