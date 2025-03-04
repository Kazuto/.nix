-- Align text by characters
-- https://github.com/tommcdo/vim-lion
return {
	"tommcdo/vim-lion",
	config = function()
		vim.g.lion_squeeze_spaces = 1 -- Remove as many spaces as possible when aligning
	end,
}
