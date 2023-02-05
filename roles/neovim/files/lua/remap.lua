
vim.g.mapleader = " "

local key = vim.keymap.set

-- just learn to use "+ ... not so hard is it?
-- if vim.fn.has('mac') == 1 then
    -- Interact with system clipboard (works in normal or visual modes)
    -- key({"n", "x"}, "<leader>y", '"+y')
    -- key({"n", "x"}, "<leader>p", '"+p')
    -- key({"n", "x"}, "<leader>P", '"+P')
-- end

-- better j,k line navigation when lines are wrapped
key({"n", "x"}, "j", "gj", {noremap = true})
key({"n", "x"}, "k", "gk", {noremap = true})

-- an Esc key when I don't feel like stretching my delicate pinky
--key("i", "kj", "<esc>", {})
--key("i", "jj", "<esc>", {})

-- use J/K in visual mode to move lines (and re-indent)
key("v", "J", ":m '>+1<CR>gv=gv")
key("v", "K", ":m '<-2<CR>gv=gv")

-- keep cursor position when joining lines, using ^D / ^U
-- or when using search navigation (n, N)
key("n", "J", "mzJ`z")
key("n", "<C-d>", "<C-d>zz")
key("n", "<C-u>", "<C-u>zz")
key("n", "n", "nzzzv")
key("n", "N", "Nzzzv")

-- explorer
key("n", "<leader>e", vim.cmd.Ex)

--key("n", "<leader>w", "<cmd>write<cr>", {desc = "Save"})

-- an Esc key when I don't feel like stretching my delicate pinky
--key("i", "kj", "<esc>", {})
--key("i", "jj", "<esc>", {})

-- terminal toggle
key('n', '<C-t>', '<CMD>lua require("FTerm").toggle()<CR>')
key('t', '<C-t>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

-- not sure yet how to write this in lua
-- allows C-r <register> to paste into a terminal pane
vim.cmd([[
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
]])
