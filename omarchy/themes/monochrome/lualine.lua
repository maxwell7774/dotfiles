local colors = {
	bg = "#282828",
	fg = "#d4d4d4",
	gray = "#3c3c3c",
	brightgray = "#767676",
	white = "#ffffff",
	dimgray = "#323232",
	mediumgray = "#505050",
}

local monochrome_theme = {
	normal = {
		a = { fg = colors.bg, bg = colors.brightgray, gui = "bold" },
		b = { fg = colors.fg, bg = colors.gray },
		c = { fg = colors.fg, bg = colors.bg },
	},
	insert = {
		a = { fg = colors.bg, bg = colors.fg, gui = "bold" },
		b = { fg = colors.fg, bg = colors.gray },
		c = { fg = colors.fg, bg = colors.bg },
	},
	visual = {
		a = { fg = colors.bg, bg = colors.white, gui = "bold" },
		b = { fg = colors.fg, bg = colors.gray },
		c = { fg = colors.fg, bg = colors.bg },
	},
	replace = {
		a = { fg = colors.bg, bg = colors.gray, gui = "bold" },
		b = { fg = colors.fg, bg = colors.gray },
		c = { fg = colors.fg, bg = colors.bg },
	},
	command = {
		a = { fg = colors.bg, bg = colors.mediumgray, gui = "bold" },
		b = { fg = colors.fg, bg = colors.gray },
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
			theme = monochrome_theme,
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
