-- Plugin for Neovim to enhance the development experience of Laravel projects
-- https://github.com/adalessa/laravel.nvim
return {
	"adalessa/laravel.nvim",
	dependencies = {
		"tpope/vim-dotenv",
		"nvim-telescope/telescope.nvim",
		"MunifTanjim/nui.nvim",
		"nvimtools/none-ls.nvim",
		"kevinhwang91/promise-async",
	},
	cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
	keys = {
		{ "<leader>aa", ":Laravel artisan<CR>", desc = "Laravel Artisan" },
		{ "<leader>ar", ":Laravel routes<CR>", desc = "Laravel Application Routes" },
		{ "<leader>am", ":Laravel make<CR>", desc = "Laravel Make" },
		{ "<leader>ac", ":Laravel related<CR>", desc = "Laravel Related" },
		{
			"<leader>at",
			function()
				require("laravel.tinker").send_to_tinker()
			end,
			mode = "v",
			desc = "Laravel Application Routes",
		},
	},
	event = { "VeryLazy" },
	config = function()
		require("laravel").setup()
		-- require("telescope").load_extension("laravel")
	end,
}
