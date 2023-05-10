
vim.g.mapleader = " "

local key = vim.keymap.set

if vim.fn.has('mac') == 1 then
    -- Interact with system clipboard (works in normal or visual modes)
    key({"n", "x"}, "<leader>y", '"+y')
    key({"n", "x"}, "<leader>p", '"+p')
    key({"n", "x"}, "<leader>P", '"+P')
end

-- better j,k line navigation when lines are wrapped.
-- interacts poorly with (n)j, (n)k jumps if 'wrap' is true.
-- key({"n", "x"}, "j", "gj", {noremap = true})
-- key({"n", "x"}, "k", "gk", {noremap = true})

-- an Esc key when I don't feel like stretching my delicate pinky
key("i", "kj", "<esc>", {})
key("i", "jj", "<esc>", {})

-- use J/K in visual mode to move lines (and re-indent)
key("v", "J", ":m '>+1<CR>gv=gv")
key("v", "K", ":m '<-2<CR>gv=gv")

-- keep cursor position when joining lines, using ^D, ^U, ^F, ^B
-- or when using search navigation (n, N)
-- key("n", "J", "mzJ`z")
-- key("n", "<C-d>", "<C-d>zz")
-- key("n", "<C-u>", "<C-u>zz")
-- key("n", "<C-f>", "<C-f>zz")
-- key("n", "<C-b>", "<C-b>zz")
-- key("n", "n", "nzzzv")
-- key("n", "N", "Nzzzv")

-- explorer
key("n", "<leader>e", vim.cmd.Ex)

--key("n", "<leader>w", "<cmd>write<cr>", {desc = "Save"})

