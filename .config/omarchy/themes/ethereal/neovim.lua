local colors = {
	bg = "#060B1E",
	fg = "#ffcead",
	black = "#060B1E",
	red = "#ED5B5A",
	green = "#92a593",
	yellow = "#E9BB4F",
	blue = "#7d82d9",
	magenta = "#c89dc1",
	cyan = "#a3bfd1",
	orange = "#F99957",
	brightblack = "#6d7db6",
	brightred = "#faaaa9",
	brightgreen = "#c4cfc4",
	brightyellow = "#f7dc9c",
	brightblue = "#c2c4f0",
	brightmagenta = "#ead7e7",
	brightcyan = "#dfeaf0",
	brightwhite = "#ffcead",
	accent = "#7d82d9",
	selection_bg = "#ffcead",
	selection_fg = "#060B1E",
}

local ethereal_theme = {
	normal = {
		a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
		b = { fg = colors.fg, bg = colors.brightblack },
		c = { fg = colors.fg, bg = colors.bg },
	},
	insert = {
		a = { fg = colors.bg, bg = colors.green, gui = "bold" },
		b = { fg = colors.fg, bg = colors.brightblack },
		c = { fg = colors.fg, bg = colors.bg },
	},
	visual = {
		a = { fg = colors.bg, bg = colors.magenta, gui = "bold" },
		b = { fg = colors.fg, bg = colors.brightblack },
		c = { fg = colors.fg, bg = colors.bg },
	},
	replace = {
		a = { fg = colors.bg, bg = colors.red, gui = "bold" },
		b = { fg = colors.fg, bg = colors.brightblack },
		c = { fg = colors.fg, bg = colors.bg },
	},
	command = {
		a = { fg = colors.bg, bg = colors.yellow, gui = "bold" },
		b = { fg = colors.fg, bg = colors.brightblack },
		c = { fg = colors.fg, bg = colors.bg },
	},
	inactive = {
		a = { fg = colors.fg, bg = colors.brightblack },
		b = { fg = colors.fg, bg = colors.brightblack },
		c = { fg = colors.fg, bg = colors.brightblack },
	},
}

return {
	{
		"bjarneo/ethereal.nvim",
		priority = 1000,
		opts = {
			transparent = false,
		},
		config = function(_, opts)
			require("ethereal").setup({})
			vim.cmd([[colorscheme ethereal]])
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = ethereal_theme,
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
