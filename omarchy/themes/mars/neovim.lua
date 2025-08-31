return {
	"steve-lohmeyer/mars.nvim",
	name = "mars",
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd([[colorscheme mars]])
	end,
}
