" Vim GUI-only settings (used by MacVim)

" ------------------------------------------------------------------------
" General config {{{

" Disable the toolbar
set guioptions=-t

" Put the file/buffer name in the title bar
set title

" Show invisibles by default (toggle: <leader>i)
set list
set listchars=tab:▸\ ,eol:¬

" Warn on long lines
set colorcolumn=81

" Whatever we copy, send to the system clipboard too.
" I don't like this, it can obliterate my Launchbar clipboard history quickly.
" Replaced this with ,Y and ,P mappings to easily interact with the system
" pasteboard in a more explicit way.
"set clipboard+=unnamed

set encoding=utf-8

" }}}
" ------------------------------------------------------------------------
" Window size {{{

set lines=40
set columns=90

" Grow / shrink window height
nmap <leader>zz :set lines=999<CR>
nmap <leader>zZ :set lines=40<CR>

" Grow / shrink window width
nmap <leader>zw :set columns=999<CR>
nmap <leader>zW :set columns=90<CR>

" Zoom to max size. This isn't fullscreen; use cmd-shift-F for that.
nmap <leader>zf :set lines=999 columns=999<CR>

" Return to normal size
nmap <leader>zd :set lines=40 columns=90<CR>

" }}}
" ------------------------------------------------------------------------
" Copy and paste {{{

" Copy current line or selection to OS X clipboard
nnoremap <leader>Y "*yy
vnoremap <leader>Y "*y

" Paste from OS X clipboard explicitly. If something was copied to the
" OS X clipboard after the last time something was copied to MacVim's
" clipboard, then 'p' will behave the same way, but these will always
" go directly to the OS X clipboard, bypassing anything in MacVim's.
nnoremap <leader>P "*p
vnoremap <leader>P "*p

" }}}
" ------------------------------------------------------------------------
" Fonts and colors {{{

set guifont=Menlo:h14
set antialias

highlight Comment guifg=#858585
highlight Statement guifg=blue
highlight Identifier guifg=darkcyan gui=bold
" invisibles...
highlight NonText guifg=#cdcdcd
highlight SpecialKey guifg=#cdcdcd

" }}}
" ------------------------------------------------------------------------
