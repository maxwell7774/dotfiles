return {
	"rose-pine/neovim",
	name = "rose-pine",
	priority = 1000, -- make sure to load this before all the other start plugins
	-- Optional; default configuration will be used if setup isn't called.
	config = function()
		vim.cmd([[colorscheme rose-pine-dawn]])
	end,
}
