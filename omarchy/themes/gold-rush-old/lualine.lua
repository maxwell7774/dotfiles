local colors = {
	bg = "#121212",
	fg = "#D9D9D9",
	yellow = "#FAD643",
	gold = "#DBB42C",
	darkgold = "#926C15",
	brown = "#805B10",
	bright = "#FFEE69",
}

local gold_theme = {
	normal = {
		a = { fg = colors.bg, bg = colors.gold, gui = "bold" },
		b = { fg = colors.fg, bg = colors.darkgold },
		c = { fg = colors.fg, bg = colors.bg },
	},
	insert = {
		a = { fg = colors.bg, bg = colors.yellow, gui = "bold" },
		b = { fg = colors.fg, bg = colors.darkgold },
		c = { fg = colors.fg, bg = colors.bg },
	},
	visual = {
		a = { fg = colors.bg, bg = colors.bright, gui = "bold" },
		b = { fg = colors.fg, bg = colors.darkgold },
		c = { fg = colors.fg, bg = colors.bg },
	},
	replace = {
		a = { fg = colors.bg, bg = "#C9A227", gui = "bold" },
		b = { fg = colors.fg, bg = colors.darkgold },
		c = { fg = colors.fg, bg = colors.bg },
	},
	command = {
		a = { fg = colors.bg, bg = colors.brown, gui = "bold" },
		b = { fg = colors.fg, bg = colors.darkgold },
		c = { fg = colors.fg, bg = colors.bg },
	},
	inactive = {
		a = { fg = colors.fg, bg = colors.bg },
		b = { fg = colors.fg, bg = colors.bg },
		c = { fg = colors.fg, bg = colors.bg },
	},
}

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			theme = gold_theme,
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
}
