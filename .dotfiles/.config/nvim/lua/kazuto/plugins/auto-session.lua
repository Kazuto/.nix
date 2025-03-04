return {
	"rmagatti/auto-session",
	config = function()
		local auto_session = require("auto-session")

		auto_session.setup({
			auto_restore_enabled = false,
			log_level = "error",
			auto_session_suppress_dirs = { "~/", "~/Development" },
		})

		local keymap = vim.keymap

		keymap.set("n", "<leader>wr", ":SessionRestore<CR>", { desc = "[W]orkspace [R]estore" })
		keymap.set("n", "<leader>ws", ":SessionSave<CR>", { desc = "[W]orkspace [S]ave" })
	end,
}
