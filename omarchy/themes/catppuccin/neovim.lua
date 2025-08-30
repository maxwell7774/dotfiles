return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "macchiato", -- other options: "mocha", "frappe", "macchiato"
		})
		vim.cmd.colorscheme("catppuccin-macchiato")
	end,
}
