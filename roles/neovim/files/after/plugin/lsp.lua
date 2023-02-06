-- Learn the keybindings, see :help lsp-zero-keybindings
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
local lsp = require('lsp-zero')
lsp.preset('recommended')

lsp.ensure_installed({
    'eslint',
    'sumneko_lua',
})

-- (Optional) Configure lua language server for neovim
-- lsp.nvim_workspace()

lsp.setup()

-- potential stuff to ensure_installed
-- these are the names in the mason UI; might differ
-- from name in this file
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
