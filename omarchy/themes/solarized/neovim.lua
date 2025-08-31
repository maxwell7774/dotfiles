return {
	-- add solarized
	"maxmx03/solarized.nvim",
	priority = 1000,
	opts = {
		palette = "solarized",
		variant = "autumn",
		styles = {
			constants = { bold = true },
		},
	},
	config = function()
		vim.cmd([[colorscheme solarized]])
	end,
}
