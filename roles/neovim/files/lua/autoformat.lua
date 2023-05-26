-- Define formatters
vim.g.neoformat_enabled_javascript = { "prettier" }
vim.g.neoformat_enabled_html = { "prettier" }
vim.g.neoformat_enabled_css = { "prettier" }
vim.g.neoformat_enabled_python = { "black" }
vim.g.neoformat_enabled_lua = { "stylua" }

vim.keymap.set("n", "<leader>F", "<cmd>:Neoformat<cr>", {})

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- for certain filetypes, autoformat on save
local fmtGroup = augroup("fmt", {})
autocmd({ "BufWritePre" }, {
	group = fmtGroup,
	callback = function(opts)
		-- if vim.bo[opts.buf].filetype == "javascript" then
		-- 	vim.cmd([[Neoformat]])
		-- end
		-- if vim.bo[opts.buf].filetype == "css" then
		-- 	vim.cmd([[Neoformat]])
		-- end
		-- if vim.bo[opts.buf].filetype == "python" then
		-- 	vim.cmd([[Neoformat]])
		-- end
		if vim.bo[opts.buf].filetype == "lua" then
			vim.cmd([[Neoformat]])
		end
	end,
})
