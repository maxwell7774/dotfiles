local colors = {
	bg = "#000000",
	fg = "#D9AFA7",
	red = "#E07B5F",
	green = "#7B534E",
	yellow = "#C45A3F",
	blue = "#7B534E",
	magenta = "#A0392F",
	cyan = "#7B534E",
	white = "#D9AFA7",
	brightred = "#FF6B4A",
	darkgray = "#4A2C2C",
}

local mars_theme = {
	normal = {
		a = { fg = colors.bg, bg = colors.brightred, gui = "bold" },
		b = { fg = colors.fg, bg = colors.darkgray },
		c = { fg = colors.fg, bg = colors.bg },
	},
	insert = {
		a = { fg = colors.bg, bg = colors.green, gui = "bold" },
		b = { fg = colors.fg, bg = colors.darkgray },
		c = { fg = colors.fg, bg = colors.bg },
	},
	visual = {
		a = { fg = colors.bg, bg = colors.magenta, gui = "bold" },
		b = { fg = colors.fg, bg = colors.darkgray },
		c = { fg = colors.fg, bg = colors.bg },
	},
	replace = {
		a = { fg = colors.bg, bg = colors.red, gui = "bold" },
		b = { fg = colors.fg, bg = colors.darkgray },
		c = { fg = colors.fg, bg = colors.bg },
	},
	command = {
		a = { fg = colors.bg, bg = colors.yellow, gui = "bold" },
		b = { fg = colors.fg, bg = colors.darkgray },
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
			theme = mars_theme,
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
