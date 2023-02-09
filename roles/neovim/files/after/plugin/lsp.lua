-- Learn the keybindings, see :help lsp-zero-keybindings
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
local lsp = require('lsp-zero')
lsp.preset('recommended')

-- see below for more you can install in the UI (:Mason).
-- I'm not sure what their names are to put them here, or
-- how to find out in a consistent way.
lsp.ensure_installed({
    'eslint',
    'sumneko_lua',
})

-- (Optional) Configure lua language server for neovim
-- This is so it doesn't warn you of things like 'vim'
-- not being a valid variable
lsp.nvim_workspace()

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})

-- potential stuff to install
--
-- these are names in the mason UI; might differ from name you'd use
-- in ensure_installed()
--
-- ◍ ansible-language-server
-- ◍ beautysh
-- ◍ black
-- ◍ clangd
-- ◍ css-lsp
-- ◍ debugpy
-- ◍ delve
-- ◍ djlint
-- ◍ dockerfile-language-server
-- ◍ eslint-lsp                 ** already installed above? (eslint)
-- ◍ firefox-debug-adapter
-- ◍ flake8
-- ◍ gopls
-- ◍ hadolint
-- ◍ html-lsp
-- ◍ jedi-language-server
-- ◍ json-lsp
-- ◍ jsonlint
-- ◍ lua-language-server       ** already installed above? (sumneko_lua)
-- ◍ markdownlint
-- ◍ marksman
-- ◍ perlnavigator
-- ◍ prettier
-- ◍ puppet-editor-services
-- ◍ selene
-- ◍ sql-formatter
-- ◍ sqlfluff
-- ◍ sqlls
-- ◍ stylua
-- ◍ yaml-language-server
-- ◍ yamllint
