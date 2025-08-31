return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	config = function()
		require("gruvbox").setup({})
		vim.o.background = "dark" -- or "light" for light mode
		vim.cmd([[colorscheme gruvbox]])
		-- vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
	end,
}
