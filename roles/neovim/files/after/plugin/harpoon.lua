local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
local key = vim.keymap.set

key("n", "<leader>a", mark.add_file)
key("n", "<leader><leader>", ui.toggle_quick_menu)

key("n", "<C-j>", function() ui.nav_file(1) end)
key("n", "<C-k>", function() ui.nav_file(2) end)
key("n", "<C-l>", function() ui.nav_file(3) end)
key("n", "<C-;>", function() ui.nav_file(4) end)

