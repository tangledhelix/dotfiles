-- https://neovim.io/doc/user/lua.html#vim.filetype.add()

local function indent_by_two()
	vim.opt.tabstop = 2
	vim.opt.softtabstop = 2
	vim.opt.shiftwidth = 2
end

vim.filetype.add({
	pattern = {
		[".*%.lua%.j2"] = "lua",
	},
	extension = {
		js = function()
			indent_by_two()
			return "javascript"
		end,
		yaml = function()
			indent_by_two()
			return "yaml"
		end,
		yml = function()
			indent_by_two()
			return "yaml"
		end,
		eyaml = function()
			indent_by_two()
			return "yaml"
		end,
		json = function()
			indent_by_two()
			return "json"
		end,
	},
})
