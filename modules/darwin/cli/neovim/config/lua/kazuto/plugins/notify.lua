-- A fancy, configurable, notification manager for NeoVim
-- https://github.com/rcarriga/nvim-notify
return {
	"rcarriga/nvim-notify",
	config = function()
		local notify = require("notify")
		-- this for transparency
		notify.setup({ background_colour = "#000000" })
		-- this overwrites the vim notify function
		vim.notify = notify.notify
	end,
}
