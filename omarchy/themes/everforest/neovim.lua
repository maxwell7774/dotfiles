return {
	"neanias/everforest-nvim",
	version = false,
	lazy = false,
	priority = 1000, -- make sure to load this before all the other start plugins
	-- Optional; default configuration will be used if setup isn't called.
	config = function()
		require("everforest").setup({
			background = "medium",
			transparent_background_level = 0,
			italics = true,
			disable_italic_comments = false,
			sign_column_background = "none",
			ui_contrast = "low",
			dim_inactive_windows = false,
			diagnostic_text_highlight = true,
			diagnostic_virtual_text = "coloured",
			spell_foreground = false,
			diagnostic_line_highlight = true,
		})
		vim.cmd([[colorscheme everforest]])
	end,
}
