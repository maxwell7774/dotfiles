return {
	{
		"neanias/everforest-nvim",
		version = false,
		lazy = false,
		priority = 1000, -- make sure to load this before all the other start plugins
		-- Optional; default configuration will be used if setup isn't called.
		config = function()
			require("everforest").setup({
				background = "hard",
				transparent_background_level = 1,
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
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = "everforest",
				component_separators = "",
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { { "mode", right_padding = 2 } },
				lualine_b = { "filename", "branch" },
				lualine_c = {
					"%=", --[[ add your center compoentnts here in place of this comment ]]
				},
				lualine_x = {},
				lualine_y = { "filetype", "progress" },
				lualine_z = {
					{ "location", left_padding = 2 },
				},
			},
			inactive_sections = {
				lualine_a = { "filename" },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = { "location" },
			},
			tabline = {},
			extensions = {},
		},
	},
}
