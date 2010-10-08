" Vim GUI-only settings (used by MacVim)

" ------------------------------------------------------------------------
" General config {{{

" Hilight current line so I can more easily tell where I am
set cursorline

" Disable the toolbar
set guioptions=-t

" Put the file/buffer name in the title bar
set title

" Show invisibles by default (toggle: <leader>i)
set list
set listchars=tab:▸\ ,eol:¬

" Warn on long lines
set colorcolumn=81

" Whatever we copy, send to the system clipboard too
set clipboard+=unnamed

set encoding=utf-8

" }}}
" ------------------------------------------------------------------------
" Window size {{{

" Default sizes
" TODO: defined these as variables I can reuse in the below mappings
set lines=40
set columns=90

" Grow / shrink window height
nmap <leader>zz :set lines=999<CR>
nmap <leader>zZ :set lines=40<CR>

" Grow / shrink window width
nmap <leader>zw :set columns=999<CR>
nmap <leader>zW :set columns=90<CR>

" Zoom to full screen (See also shift-cmd-F in MacVim...)
nmap <leader>zf :set lines=999 columns=999<CR>

" Return to normal size
nmap <leader>zd :set lines=40 columns=90<CR>

" }}}
" ------------------------------------------------------------------------
" Fonts and colors {{{

set guifont=Menlo:h12
set antialias

highlight Comment guifg=#858585
highlight Statement guifg=blue
highlight Identifier guifg=darkcyan gui=bold
" invisibles...
highlight NonText guifg=#cdcdcd
highlight SpecialKey guifg=#cdcdcd

" }}}
" ------------------------------------------------------------------------
