local opt = vim.opt

-- uncomment to have nvim not change the cursor style (thin, block, ...)
--opt.guicursor = ""

-- line numbering
opt.number = true
opt.relativenumber = true

-- indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- line wrapping
opt.wrap = true

-- highlight search term after search ends
opt.hlsearch = true
-- use incremental search
opt.incsearch = true

-- good colors in TUI
opt.termguicolors = true

-- don't get cursor too close to edge of viewport on scroll
opt.scrolloff = 4

-- gutter for debuggers and plugins
opt.signcolumn = "yes"

-- mark a column at this position (right margin indicator)
opt.colorcolumn = "80"

-- encodings
opt.encoding = 'utf8'
opt.fileencoding = 'utf8'

-- split to the right & below... i don't like the defaults
opt.splitright = true
opt.splitbelow = true

