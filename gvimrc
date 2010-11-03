" Vim GUI-only settings (used by MacVim)

" ------------------------------------------------------------------------
" General config {{{

" Disable the toolbar
set guioptions=-t

" Enable the right scrollbar
set guioptions=+r

" Put the file/buffer name in the title bar
set title

" Show invisibles by default (toggle: <leader>i)
set list
"set listchars=tab:▸\ ,eol:¬

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

" Grow window height / width
nmap <leader>zz :set lines=999<CR>
nmap <leader>zw :set columns=999<CR>

" Zoom to max size. This isn't fullscreen; use ,zf for that.
nmap <leader>zm :set lines=999 columns=999<CR>

" Return to normal size
nmap <leader>zd :set lines=40 columns=90<CR>

" Real fullscreen. Also kicks up the font size a bit.
nmap <silent> <leader>zf :if &fullscreen <Bar>
	\     set guifont=Menlo:h12 <Bar>
	\ else <Bar>
	\     set guifont=Menlo:h16 <Bar>
	\ endif<CR>
	\ :set fullscreen!<CR>

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

" Switching these off, using zenburn now.
"highlight Comment guifg=#858585
"highlight Statement gui=bold guifg=blue
"highlight Identifier gui=bold guifg=darkcyan
"" invisibles...
"highlight NonText guifg=#eeeeee
"highlight SpecialKey guifg=#eeeeee

" zenburn leaves this kinda highlighted, whereas I want it muted
" because tabs are classified as SpecialKey. Copied value of NonText.
highlight SpecialKey gui=bold guifg=#5b605e

" }}}
" ------------------------------------------------------------------------
