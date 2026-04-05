local colors = {
	bg = "#16242d",
	fg = "#d6e2ee",
	black = "#1b2d40",
	red = "#4d86b0",
	green = "#5e95bc",
	yellow = "#6fa4c9",
	blue = "#6fb8e3",
	magenta = "#8bc9eb",
	cyan = "#b4e4f6",
	white = "#d6e2ee",
	brightblack = "#304860",
	brightred = "#73a6cb",
	brightgreen = "#86b7d8",
	brightyellow = "#9dcae5",
	brightblue = "#f2fcff",
	brightmagenta = "#b1d8ee",
	brightcyan = "#d1eef8",
	brightwhite = "#ffffff",
	selection = "#4d9ed3",
	accent = "#f2fcff",
}

local lumon_theme = {
	normal = {
		a = { fg = colors.black, bg = colors.blue, gui = "bold" },
		b = { fg = colors.fg, bg = colors.brightblack },
		c = { fg = colors.fg, bg = colors.bg },
	},
	insert = {
		a = { fg = colors.black, bg = colors.cyan, gui = "bold" },
		b = { fg = colors.fg, bg = colors.brightblack },
		c = { fg = colors.fg, bg = colors.bg },
	},
	visual = {
		a = { fg = colors.black, bg = colors.selection, gui = "bold" },
		b = { fg = colors.fg, bg = colors.brightblack },
		c = { fg = colors.fg, bg = colors.bg },
	},
	replace = {
		a = { fg = colors.black, bg = colors.red, gui = "bold" },
		b = { fg = colors.fg, bg = colors.brightblack },
		c = { fg = colors.fg, bg = colors.bg },
	},
	command = {
		a = { fg = colors.black, bg = colors.accent, gui = "bold" },
		b = { fg = colors.fg, bg = colors.brightblack },
		c = { fg = colors.fg, bg = colors.bg },
	},
	inactive = {
		a = { fg = colors.fg, bg = colors.bg },
		b = { fg = colors.fg, bg = colors.bg },
		c = { fg = colors.fg, bg = colors.bg },
	},
}

return {
	{
		"omacom-io/lumon.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			vim.cmd([[colorscheme lumon]])
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = lumon_theme,
				component_separators = "",
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { { "mode", right_padding = 2 } },
				lualine_b = { "filename", "branch" },
				lualine_c = {
					"%=", --[[ add your center components here in place of this comment ]]
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
