local colors = {
	bg = "#0a0e14",
	fg = "#b3b1ad",
	black = "#01060e",
	red = "#ea6c73",
	green = "#91b362",
	yellow = "#f9af4f",
	blue = "#53bdfa",
	magenta = "#fae994",
	cyan = "#90e1c6",
	white = "#c7c7c7",
	brightblack = "#686868",
	brightred = "#f07178",
	brightgreen = "#c2d94c",
	brightyellow = "#ffb454",
	brightblue = "#59c2ff",
	brightmagenta = "#ffee99",
	brightcyan = "#95e6cb",
	brightwhite = "#ffffff",
	selection_bg = "#253340",
	comment = "#4a5568",
	line_bg = "#0d1117",
}

local hackerman_theme = {
	normal = {
		a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
		b = { fg = colors.fg, bg = colors.black },
		c = { fg = colors.fg, bg = colors.bg },
	},
	insert = {
		a = { fg = colors.bg, bg = colors.green, gui = "bold" },
		b = { fg = colors.fg, bg = colors.black },
		c = { fg = colors.fg, bg = colors.bg },
	},
	visual = {
		a = { fg = colors.bg, bg = colors.magenta, gui = "bold" },
		b = { fg = colors.fg, bg = colors.black },
		c = { fg = colors.fg, bg = colors.bg },
	},
	replace = {
		a = { fg = colors.bg, bg = colors.red, gui = "bold" },
		b = { fg = colors.fg, bg = colors.black },
		c = { fg = colors.fg, bg = colors.bg },
	},
	command = {
		a = { fg = colors.bg, bg = colors.cyan, gui = "bold" },
		b = { fg = colors.fg, bg = colors.black },
		c = { fg = colors.fg, bg = colors.bg },
	},
	inactive = {
		a = { fg = colors.fg, bg = colors.selection_bg },
		b = { fg = colors.fg, bg = colors.selection_bg },
		c = { fg = colors.fg, bg = colors.selection_bg },
	},
}

local function setup_hackerman_theme()
	vim.cmd("hi clear")
	if vim.fn.exists("syntax_on") then
		vim.cmd("syntax reset")
	end

	vim.o.background = "dark"
	vim.g.colors_name = "hackerman"

	local function highlight(group, color)
		local style = color.style and "gui=" .. color.style or "gui=NONE"
		local fg = color.fg and "guifg=" .. color.fg or "guifg=NONE"
		local bg = color.bg and "guibg=" .. color.bg or "guibg=NONE"
		local sp = color.sp and "guisp=" .. color.sp or ""
		vim.cmd(string.format("highlight %s %s %s %s %s", group, style, fg, bg, sp))
	end

	-- Editor highlights
	highlight("Normal", { fg = colors.fg, bg = colors.bg })
	highlight("NormalFloat", { fg = colors.fg, bg = colors.line_bg })
	highlight("Comment", { fg = colors.comment, style = "italic" })
	highlight("Cursor", { fg = colors.bg, bg = colors.cyan })
	highlight("CursorLine", { bg = colors.line_bg })
	highlight("CursorLineNr", { fg = colors.blue, style = "bold" })
	highlight("LineNr", { fg = colors.comment })
	highlight("Visual", { bg = colors.selection_bg })
	highlight("VisualNOS", { bg = colors.selection_bg })

	-- Syntax highlighting
	highlight("Constant", { fg = colors.cyan })
	highlight("String", { fg = colors.green })
	highlight("Character", { fg = colors.green })
	highlight("Number", { fg = colors.cyan })
	highlight("Boolean", { fg = colors.cyan })
	highlight("Float", { fg = colors.cyan })

	highlight("Identifier", { fg = colors.cyan })
	highlight("Function", { fg = colors.magenta })

	highlight("Statement", { fg = colors.blue })
	highlight("Conditional", { fg = colors.blue })
	highlight("Repeat", { fg = colors.blue })
	highlight("Label", { fg = colors.blue })
	highlight("Operator", { fg = colors.cyan })
	highlight("Keyword", { fg = colors.blue })
	highlight("Exception", { fg = colors.red })

	highlight("PreProc", { fg = colors.yellow })
	highlight("Include", { fg = colors.blue })
	highlight("Define", { fg = colors.blue })
	highlight("Macro", { fg = colors.red })
	highlight("PreCondit", { fg = colors.yellow })

	highlight("Type", { fg = colors.yellow })
	highlight("StorageClass", { fg = colors.yellow })
	highlight("Structure", { fg = colors.yellow })
	highlight("Typedef", { fg = colors.yellow })

	highlight("Special", { fg = colors.brightcyan })
	highlight("SpecialChar", { fg = colors.brightcyan })
	highlight("Tag", { fg = colors.magenta })
	highlight("Delimiter", { fg = colors.white })
	highlight("SpecialComment", { fg = colors.comment })
	highlight("Debug", { fg = colors.red })

	highlight("Underlined", { style = "underline" })
	highlight("Error", { fg = colors.red, bg = colors.bg })
	highlight("Todo", { fg = colors.yellow, bg = colors.bg, style = "bold" })

	-- UI elements
	highlight("Pmenu", { fg = colors.fg, bg = colors.line_bg })
	highlight("PmenuSel", { fg = colors.black, bg = colors.blue })
	highlight("PmenuSbar", { bg = colors.brightblack })
	highlight("PmenuThumb", { bg = colors.blue })

	highlight("StatusLine", { fg = colors.blue, bg = colors.brightblack })
	highlight("StatusLineNC", { fg = colors.comment, bg = colors.brightblack })

	highlight("TabLine", { fg = colors.white, bg = colors.brightblack })
	highlight("TabLineFill", { bg = colors.black })
	highlight("TabLineSel", { fg = colors.black, bg = colors.blue })

	highlight("VertSplit", { fg = colors.brightblack })
	highlight("SignColumn", { bg = colors.bg })
	highlight("ColorColumn", { bg = colors.line_bg })

	-- Search
	highlight("Search", { fg = colors.black, bg = colors.yellow })
	highlight("IncSearch", { fg = colors.black, bg = colors.cyan })

	-- Diff
	highlight("DiffAdd", { fg = colors.green, bg = colors.line_bg })
	highlight("DiffChange", { fg = colors.yellow, bg = colors.line_bg })
	highlight("DiffDelete", { fg = colors.red, bg = colors.line_bg })
	highlight("DiffText", { fg = colors.blue, bg = colors.line_bg })

	-- Git signs
	highlight("GitSignsAdd", { fg = colors.green })
	highlight("GitSignsChange", { fg = colors.yellow })
	highlight("GitSignsDelete", { fg = colors.red })

	-- Treesitter highlights
	highlight("@variable", { fg = colors.fg })
	highlight("@variable.builtin", { fg = colors.cyan })
	highlight("@function", { fg = colors.magenta })
	highlight("@function.builtin", { fg = colors.magenta })
	highlight("@keyword", { fg = colors.blue })
	highlight("@keyword.function", { fg = colors.blue })
	highlight("@keyword.operator", { fg = colors.blue })
	highlight("@string", { fg = colors.green })
	highlight("@number", { fg = colors.cyan })
	highlight("@boolean", { fg = colors.cyan })
	highlight("@constant", { fg = colors.cyan })
	highlight("@constant.builtin", { fg = colors.cyan })
	highlight("@operator", { fg = colors.cyan })
	highlight("@type", { fg = colors.yellow })
	highlight("@type.builtin", { fg = colors.yellow })
	highlight("@parameter", { fg = colors.cyan })
	highlight("@property", { fg = colors.cyan })
	highlight("@comment", { fg = colors.comment, style = "italic" })

	-- Diagnostic
	highlight("DiagnosticError", { fg = colors.red })
	highlight("DiagnosticWarn", { fg = colors.yellow })
	highlight("DiagnosticInfo", { fg = colors.blue })
	highlight("DiagnosticHint", { fg = colors.cyan })

	-- Terminal colors
	vim.g.terminal_color_0 = colors.black
	vim.g.terminal_color_1 = colors.red
	vim.g.terminal_color_2 = colors.green
	vim.g.terminal_color_3 = colors.yellow
	vim.g.terminal_color_4 = colors.blue
	vim.g.terminal_color_5 = colors.magenta
	vim.g.terminal_color_6 = colors.cyan
	vim.g.terminal_color_7 = colors.white
	vim.g.terminal_color_8 = colors.brightblack
	vim.g.terminal_color_9 = colors.brightred
	vim.g.terminal_color_10 = colors.brightgreen
	vim.g.terminal_color_11 = colors.brightyellow
	vim.g.terminal_color_12 = colors.brightblue
	vim.g.terminal_color_13 = colors.brightmagenta
	vim.g.terminal_color_14 = colors.brightcyan
	vim.g.terminal_color_15 = colors.brightwhite
end

return {
	{
		-- "dummy/hackerman.nvim",
		name = "hackerman",
		dir = vim.fn.stdpath("config"),
		priority = 1000,
		config = function()
			setup_hackerman_theme()
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = hackerman_theme,
				component_separators = "",
				section_separators = { left = "", right = "" },
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
