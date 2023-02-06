-- packer requires neovim 0.5, so anything requiring 0.5+ is also covered
-- by this check
if vim.fn.has('nvim-0.5') == 1 then

    -- checking the nvim version is important because on servers,
    -- neovim is often fairly old.

    vim.cmd [[packadd packer.nvim]]

    return require('packer').startup(function(use)
        -- https://github.com/wbthomason/packer.nvim
        use 'wbthomason/packer.nvim'

        -- https://github.com/rose-pine/neovim
        use {
            'rose-pine/neovim',
            as = 'rose-pine',
            config = function()
                require('rose-pine').setup()
                vim.cmd('colorscheme rose-pine')
            end
        }

        -- only use this on mac because it needs ripgrep installed
        if vim.fn.has('mac') == 1 then
            -- https://github.com/nvim-telescope/telescope.nvim
            use {
                'nvim-telescope/telescope.nvim', tag = '0.1.1',
                -- or                            , branch = '0.1.x',
                requires = { {'nvim-lua/plenary.nvim'} }
            }
        end

        -- https://github.com/ThePrimeagen/harpoon
        use {
            'ThePrimeagen/harpoon',
            requires = { {'nvim-lua/plenary.nvim'} }
        }

        if vim.fn.has('nvim-0.8') == 1 then
            -- https://github.com/folke/todo-comments.nvim
            use {
                'folke/todo-comments.nvim',
                requires = 'nvim-lua/plenary.nvim',
                config = function()
                    require('todo-comments').setup {
                        -- your configuration comes here
                        -- or leave it empty to use the default settings
                        -- refer to the configuration section below
                    }
                end
            }
        end

        if vim.fn.has('nvim-0.7') == 1 then
            -- https://github.com/jiaoshijie/undotree
            use {
                'jiaoshijie/undotree',
                config = function()
                    require('undotree').setup({
                        window = {
                            winblend = 12,
                        },
                    })
                end,
                requires = {
                    'nvim-lua/plenary.nvim',
                },
            }
        end

        -- https://github.com/rodjek/vim-puppet
        use 'rodjek/vim-puppet'

        -- only use this on mac because we need tree-sitter installed
        if vim.fn.has('mac') == 1 then
            if vim.fn.has('nvim-0.8') == 1 then
                -- https://github.com/nvim-treesitter/nvim-treesitter
                use {
                    'nvim-treesitter/nvim-treesitter',
                    run = ':TSUpdate'
                }
            end
        end

        if vim.fn.has('nvim-0.7') == 1 then
            -- Auto pairs
            -- https://github.com/windwp/nvim-autopairs
            use {
                "windwp/nvim-autopairs",
                config = function() require("nvim-autopairs").setup {} end
            }
        end

        -- https://github.com/kylechui/nvim-surround
        use({
            "kylechui/nvim-surround",
            tag = "*", -- Use for stability; omit to use `main` branch for the latest features
            config = function()
                require("nvim-surround").setup({
                    -- Configuration here, or leave empty to use defaults
                })
            end
        })

        -- https://terrortylor/nvim-comment
        use {
            'terrortylor/nvim-comment',
            config = function()
                require('nvim_comment').setup()
            end
        }

        -- https://numToStr/FTerm.nvim
        use {
            'numToStr/FTerm.nvim',
            config = function()
                require('FTerm').setup({
                    border = 'double',
                    blend = 12,
                })
            end
        }

        -- https://github.com/nvim-lualine/lualine.nvim
        use {
            'nvim-lualine/lualine.nvim',
            requires = { 'kyazdani42/nvim-web-devicons', opt = true },
            config = function()
                require('lualine').setup()
            end
        }

        -- https://github.com/nvim-tree/nvim-tree.lua
        use {
            'nvim-tree/nvim-tree.lua',
            requires = {
                'nvim-tree/nvim-web-devicons', -- optional, for file icons
            },
            config = function()
                require('nvim-tree').setup()
            end,
            tag = 'nightly' -- optional, updated every week. (see issue #1193)
        }

        use 'kdheepak/lazygit.nvim'

        -- if vim.fn.has('nvim-0.7') == 1 then
            -- https://github.com/VonHeikemen/lsp-zero.nvim
        --     use {
        --         'VonHeikemen/lsp-zero.nvim',
        --         requires = {
        --             -- LSP Support
        --             {'neovim/nvim-lspconfig'},
        --             {'williamboman/mason.nvim'},
        --             {'williamboman/mason-lspconfig.nvim'},

        --             -- Autocompletion
        --             {'hrsh7th/nvim-cmp'},
        --             {'hrsh7th/cmp-buffer'},
        --             {'hrsh7th/cmp-path'},
        --             {'saadparwaiz1/cmp_luasnip'},
        --             {'hrsh7th/cmp-nvim-lsp'},
        --             {'hrsh7th/cmp-nvim-lua'},

        --             -- Snippets
        --             {'L3MON4D3/LuaSnip'},
        --             -- Snippet Collection (Optional)
        --             {'rafamadriz/friendly-snippets'},
        --         }
        --     }
        -- end

    end)
end

