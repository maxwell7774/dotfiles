vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<leader>x", "<cmd>bd<CR>", { desc = "Move focus to the upper window" })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.keymap.set("n", "<leader>sv", vim.cmd.Ex, { desc = "Opens file explore" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Moves selected lines down one" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Moves selected lines up one" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Joins the current line with the next line" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scrolls down half a page and centers the cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scrolls up half a page and centers the cursor" })

vim.keymap.set(
	"x",
	"<leader>p",
	[["_dP]],
	{ desc = "Replaces selected text with the content from the default register without affecting the yank register" }
)

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yanks the selected text to the system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yanks the entire line to the system clipboard" })

vim.keymap.set(
	{ "n", "v" },
	"<leader>d",
	'"_d',
	{ desc = "Deletes the selected text without affecting the yank register" }
)

vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Ctrl c to exit insert mode" })

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Lsp format file" })
