vim.api.nvim_set_keymap("n", ":", "<cmd>FineCmdline<CR>", { noremap = true })

return {
	"VonHeikemen/fine-cmdline.nvim",
	requires = {
		{ "MunifTanjim/nui.nvim" },
	},
}
