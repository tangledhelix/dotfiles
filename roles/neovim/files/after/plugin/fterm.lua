require('FTerm').setup({
    border = 'double',
    blend = 0,
})

-- terminal toggle
vim.keymap.set('n', '<C-t>', '<CMD>lua require("FTerm").toggle()<CR>')
vim.keymap.set('t', '<C-t>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

-- not sure yet how to write this in lua
-- allows C-r <register> to paste into a terminal pane
vim.cmd([[
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
]])

