-- only use this on mac because it needs ripgrep
if vim.fn.has("mac") == 1 then
	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find File(s)" })
	vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Find Git file(s)" })
	vim.keymap.set("n", "<leader>fs", function()
		builtin.grep_string({ search = vim.fn.input("Grep > ") })
	end, { desc = "Find String" })
	vim.keymap.set("n", "<leader>fa", builtin.resume, { desc = "Find Again (open picker in previous state)" })
end
