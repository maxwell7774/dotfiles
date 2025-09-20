local colors = {
	bg = "#121212",
	fg = "#bebebe",
	red = "#D35F5F",
	yellow = "#FFC107",
	darkred = "#b91c1c",
	orange = "#e68e0d",
	brightred = "#B91C1C",
	brightyellow = "#FFC107",
	white = "#bebebe",
	brightbg = "#8a8a8d",
}

local matteblack_theme = {
	normal = {
		a = { fg = colors.bg, bg = colors.yellow, gui = "bold" },
		b = { fg = colors.fg, bg = colors.brightbg },
		c = { fg = colors.fg, bg = colors.bg },
	},
	insert = {
		a = { fg = colors.bg, bg = colors.green or colors.yellow, gui = "bold" },
		b = { fg = colors.fg, bg = colors.brightbg },
		c = { fg = colors.fg, bg = colors.bg },
	},
	visual = {
		a = { fg = colors.bg, bg = colors.red, gui = "bold" },
		b = { fg = colors.fg, bg = colors.brightbg },
		c = { fg = colors.fg, bg = colors.bg },
	},
	replace = {
		a = { fg = colors.bg, bg = colors.darkred, gui = "bold" },
		b = { fg = colors.fg, bg = colors.brightbg },
		c = { fg = colors.fg, bg = colors.bg },
	},
	command = {
		a = { fg = colors.bg, bg = colors.orange, gui = "bold" },
		b = { fg = colors.fg, bg = colors.brightbg },
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
		"tahayvr/matteblack.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("matteblack")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = matteblack_theme,
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
