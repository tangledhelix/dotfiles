require('undotree').setup({
    window = {
        winblend = 12,
    },
})

vim.keymap.set('n', '<leader>u', require('undotree').toggle, { noremap = true, silent = true })
