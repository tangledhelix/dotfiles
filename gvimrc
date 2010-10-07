" Vim GUI-only settings (used by MacVim)

set guifont=Menlo:h12
set antialias

set lines=40 columns=90

" Hilight current line so we can more easily tell where we are
set cursorline

" Disable the toolbar
set guioptions=-t

" Put the file/buffer name in the title bar
set title

" Show invisibles by default
set list
set listchars=tab:▸\ ,eol:¬

" Warn on long lines
set colorcolumn=81

" put the * register on the system clipboard
set clipboard+=unnamed

" GUI colors
highlight Comment guifg=#858585
highlight Statement guifg=blue
highlight Identifier guifg=darkcyan gui=bold
" invisibles...
highlight NonText guifg=#cdcdcd
highlight SpecialKey guifg=#cdcdcd

