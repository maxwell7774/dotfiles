return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    config = function()
        local harpoon = require "harpoon"
        harpoon:setup()

        --vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Add file to harpoon" })
        vim.keymap.set("n", "<leader>hq", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Show harpoon quick menu" })
        vim.keymap.set("n", "<leader><C-n>", function() harpoon:list():prev() end, { desc = "Go to next harpoon" })
        vim.keymap.set("n", "<leader><C-p>", function() harpoon:list():next() end, { desc = "Go to prev harpoon" })
        vim.keymap.set("n", "<leader>h1", function() harpoon:list():replace_at(1) end, { desc = "Replace harpoon 1" })
        vim.keymap.set("n", "<leader>h2", function() harpoon:list():replace_at(2) end, { desc = "Replace harpoon 2" })
        vim.keymap.set("n", "<leader>h3", function() harpoon:list():replace_at(3) end, { desc = "Replace harpoon 3" })
        vim.keymap.set("n", "<leader>h4", function() harpoon:list():replace_at(4) end, { desc = "Replace harpoon 4" })
        vim.keymap.set("n", "<leader>h5", function() harpoon:list():replace_at(5) end, { desc = "Replace harpoon 5" })

        for _, idx in ipairs { 1, 2, 3, 4, 5 } do
            vim.keymap.set("n", string.format("<space>%d", idx), function() harpoon:list():select(idx) end,
                { desc = string.format("Go to harpoon %d", idx) })
        end
    end
}
