if vim.fn.has("nvim-0.7") == 1 then
	-- Previously used blend, but emoji show through at full
	-- brightness. Looks terrible.
	require("undotree").setup({
		window = {
			-- winblend = 12,
			winblend = 0,
		},
	})

	vim.keymap.set("n", "<leader>u", require("undotree").toggle, { noremap = true, silent = true })
end
