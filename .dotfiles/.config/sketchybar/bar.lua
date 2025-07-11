local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
	height = 42,
	display = "main",
	blur_radius = 0,
	position = "top",
	sticky = false,
	corner_radius = 10,
	margin = 10,
	y_offset = 4,
	color = colors.bar.bg,
})
