-- uncomment to have nvim not change the cursor style (thin, block, ...)
--vim.opt.guicursor = ""

-- line numbering
vim.opt.number = true
vim.opt.relativenumber = true

-- indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- line wrapping
vim.opt.wrap = true

-- highlight search term after search ends
vim.opt.hlsearch = true
-- use incremental search
vim.opt.incsearch = true

-- good colors in TUI
vim.opt.termguicolors = true

-- don't get cursor too close to edge of viewport on scroll
vim.opt.scrolloff = 4

-- gutter for debuggers and plugins
vim.opt.signcolumn = "yes"

-- mark a column at this position (right margin indicator)
vim.opt.colorcolumn = "80"

