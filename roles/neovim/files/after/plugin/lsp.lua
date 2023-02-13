if vim.fn.has('nvim-0.7') == 1 then

    -- Learn the keybindings, see :help lsp-zero-keybindings
    -- Learn to configure LSP servers, see :help lsp-zero-api-showcase
    local lsp = require('lsp-zero').preset({
        name = 'minimal',
        set_lsp_keymaps = true,
        manage_nvim_cmp = true,
        suggest_lsp_servers = false,
    })

    -- (Optional) Configure lua language server for neovim
    -- This is so it doesn't warn you of things like 'vim'
    -- not being a valid variable
    lsp.nvim_workspace()

    lsp.setup()

    vim.diagnostic.config({
        virtual_text = true
    })

end

