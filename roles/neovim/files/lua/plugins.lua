-- packer requires neovim 0.5, so anything requiring 0.5+ is also covered
-- by this check
if vim.fn.has("nvim-0.5") == 1 then
	-- checking the nvim version is important because on servers,
	-- neovim is often fairly old.

	vim.cmd([[packadd packer.nvim]])

	return require("packer").startup(function(use)
		use("wbthomason/packer.nvim")

		use({
			"rose-pine/neovim",
			as = "rose-pine",
		})

		-- only use this on mac because it needs ripgrep installed
		if vim.fn.has("mac") == 1 then
			use({
				"nvim-telescope/telescope.nvim",
				tag = "0.1.1",
				-- or                            , branch = '0.1.x',
				requires = { { "nvim-lua/plenary.nvim" } },
			})
		end

		use({
			"ThePrimeagen/harpoon",
			requires = { { "nvim-lua/plenary.nvim" } },
		})

		if vim.fn.has("nvim-0.8") == 1 then
			use({
				"folke/todo-comments.nvim",
				requires = "nvim-lua/plenary.nvim",
			})
		end

		if vim.fn.has("nvim-0.7") == 1 then
			use({
				"jiaoshijie/undotree",
				requires = "nvim-lua/plenary.nvim",
			})
		end

		use("rodjek/vim-puppet")

		-- only use this on mac because we need tree-sitter installed
		if vim.fn.has("mac") == 1 then
			if vim.fn.has("nvim-0.8") == 1 then
				use({
					"nvim-treesitter/nvim-treesitter",
					run = ":TSUpdate",
				})
				use("nvim-treesitter/nvim-treesitter-context")
			end
		end

		if vim.fn.has("nvim-0.7") == 1 then
			use("windwp/nvim-autopairs")
		end

		use({
			"kylechui/nvim-surround",
			tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		})

		use("terrortylor/nvim-comment")
		use("numToStr/FTerm.nvim")

		use({
			"nvim-lualine/lualine.nvim",
			requires = { "kyazdani42/nvim-web-devicons", opt = true },
		})

		use("kdheepak/lazygit.nvim")

		if vim.fn.has("nvim-0.7") == 1 then
			use({
				"VonHeikemen/lsp-zero.nvim",
				branch = "v2.x",
				requires = {
					-- LSP Support
					{ "neovim/nvim-lspconfig" }, -- Required
					{ "williamboman/mason.nvim" }, -- Optional
					{ "williamboman/mason-lspconfig.nvim" }, -- Optional

					-- Autocompletion
					{ "hrsh7th/nvim-cmp" }, -- Required
					{ "hrsh7th/cmp-nvim-lsp" }, -- Required
					{ "hrsh7th/cmp-buffer" }, -- Optional
					{ "hrsh7th/cmp-path" }, -- Optional
					{ "saadparwaiz1/cmp_luasnip" }, -- Optional
					{ "hrsh7th/cmp-nvim-lua" }, -- Optional

					-- Snippets
					{ "L3MON4D3/LuaSnip" }, -- Required
					{ "rafamadriz/friendly-snippets" }, -- Optional
				},
			})
		end

		if vim.fn.has("nvim-0.7") == 1 then
			use("lewis6991/gitsigns.nvim")
		end

		use("sbdchd/neoformat")

		use("tpope/vim-characterize")
	end)
end
