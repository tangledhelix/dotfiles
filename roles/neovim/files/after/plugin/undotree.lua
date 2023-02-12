if vim.fn.has('nvim-0.7') == 1 then

    require('undotree').setup({
        window = {
            winblend = 12,
        },
    })

    vim.keymap.set('n', '<leader>u', require('undotree').toggle, { noremap = true, silent = true })

end
