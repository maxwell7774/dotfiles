return {
	"fxn/vim-monochrome",
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd([[colorscheme monochrome]])
		-- Make background transparent
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
	end,
}
