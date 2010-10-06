" Vim configuration
"
" ------------------------------------------------------------------------
" <leader> key map
"
" ,,            toggle paste mode
" ,<space>      clear search highlight
" ,4            set tab stop to 4
" ,8            set tab stop to 8
" ,c            used by NERD_commenter plugin
" ,C            center current line
" ,h            toggle highlight setting
" ,H            create an html version of current syntax
" ,i            toggle invisibles
" ,n            toggle relative line numbering
" ,s0           turn syntax highlighting off
" ,s1           turn syntax highlighting on
" ,sc           syntax: C
" ,spe          syntax: perl
" ,sph          syntax: php
" ,sps          syntax: perl stub header
" ,spy          syntax: python
" ,sr           syntax: ruby
" ,ss           syntax: shell
" ,sw           syntax: wiki (mediawiki)
" ,t            code tab settings
" ,T            non-code tab settings
" ,ve           edit .vimrc
" ,vr           reload .vimrc
" ------------------------------------------------------------------------

" This needs to be first, because it changes Vim's behavior in many places.
" Turn off vi compatibility. If I wanted vi, I'd use vi.
set nocompatible

" Define my leader key (my personal namespace in the keymap).
let mapleader=","

" Key combo to toggle paste-mode
set pastetoggle=,,

" Load Pathogen (manages other plugins)
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Use filetype detection, including syntax-aware indenting
filetype plugin indent on

" Load matchit library. This lets % match if/elsif/else/end, open/close
" XML tags, stuff like that, instead of just brackets.
runtime macros/matchit.vim

" Use jj to get back to command mode instead of ESC. ESC can be a pita
" to hit sometimes. This is going to take some time to get used to. ESC is
" still functional, so it shouldn't be too painful.
inoremap jj <ESC>

" --------------------------------------------------------------------
" Tab settings

" Expand tabs to spaces (soft tabs). I HATE TABS.
set expandtab

" Number of spaces to use for each insertion of (auto)indent.
set shiftwidth=4

" My tab width is 4. Because 8 is too much, but 2 is visually too small
" for code nesting IMO.
set tabstop=4
set softtabstop=4

" --------------------------------------------------------------------
" Indenting

"  Good for coding. Handles indenting of blocks automatically.
set autoindent

" An indent is automatically inserted: 
" - After a line ending in '{'.
" - After a line starting with a keyword from 'cinwords'.
" - Before a line starting with '}' (only with the "O" command).
" When typing '}' as the first character in a new line, that line is
" given the same indent as the matching '{'.
" When typing '#' as the first character in a new line, the indent for
" that line is removed, the '#' is put in the first column.  The indent
" is restored for the next line.  If you don't want this, use this
" mapping: ":inoremap # X^H#", where ^H is entered with CTRL-V CTRL-H.
" When using the ">>" command, lines starting with '#' are not shifted
" right.
set smartindent

" This prevents smartindent from pushing # to the start of a line, I want
" it at the same indent I'm currently at, usually.
inoremap # X#

" --------------------------------------------------------------------
" Wrapping

" I use Vim mostly to write code, but this doesn't auto-wrap lines, it
" only does a visual wrap.
set wrap

" Where to wrap. See <leader>t <leader>T, and many of the ,s* mappings.
" By default, do not wrap at all (aggravating while coding).
set textwidth=0

" Break lines at whitespace or special characters (when tw != 0).
" Avoids lines where a word shows up on both the right and left edges
" of the screen. Which makes copy/paste into other apps FUN.
" Screws up coding.
set nolinebreak

" Backspace over indentation, end-of-line, and start-of-line. See help.
set backspace=indent,eol,start

" Define wrapping behavior. See help.
"set whichwrap=<,>,h,l
"set whichwrap=b,s,<,>

" Wrap the line when we get this close to the right margin.
"set wrapmargin=4

" --------------------------------------------------------------------
" Searching

" Highlight search - show the current search pattern.
" This is a nice feature, but it can get in the way visually.
set hlsearch

" Clear the highlighted words from an hlsearch.
nnoremap <leader><space> :noh<cr>

" Turn hlsearch on or off.
nmap <leader>h :set hlsearch!<CR>

" Incremental search - live updating, like Emacs or iTunes.
set incsearch

" Ignore the case in search patterns.
set ignorecase

" Ignore case in search patterns unless an uppercase character is used
" in the search, then pay attention to case. Requires ignorecase.
set smartcase

" --------------------------------------------------------------------
" Sounds and alerts

set noerrorbells

" Show a report when N lines were changed. report=0 means "show all changes"
set report=0

" Kind of messages to show. Abbreviate them all.
set shortmess=atI

" Flash the screen instead of making a beep.
set visualbell

" Terminal's visual bell - turned off to make Vim quiet.
set t_vb=

" --------------------------------------------------------------------
" Status indicators
"
set notitle

" Show the status line
set laststatus=2

" Status line format
set statusline=%<%f\ %h%m%r%y\ %=%-14.(%l,%c%V%)\ %P

" I don't want line numbers.
set nonumber

" Show line numbers as relative to current, not as absolute.
" (This feature is new in 7.3.)
if v:version >= 703
    set relativenumber
endif
nmap <leader>n :set relativenumber!<CR>

" Show row/col of cursor position, and percentage into the file we are.
set ruler

" Show current uncompleted command.
set showcmd

" Show the matching bracket for the last ')'.
set showmatch

" Show the current mode.
set showmode

" Show current cursor line position.
" I don't know if I like this; in a terminal, it underlines the entire
" line, which is a bit odd. It's great in MacVim.
"set cursorline

" Warn on long lines. Looks like crap in a terminal, great in MacVim.
"set colorcolumn=81

" --------------------------------------------------------------------

set nottybuiltin

" Automatically save modifications to files when you use
" critical (rxternal) commands.
set autowrite

" Allow usage of cursor keys within insert mode.
set esckeys

" Options for the "text format" command ("gq").
" May consider 'o' with inserts the comment leader when creating a new
" line with either 'o' or 'O' in insert mode.
set formatoptions=qrn1

" Zero disables this, use default split window height.
set helpheight=0

" Allow "hidden" buffers.
set hidden

" Assume /g at the end of any substitution (:%s/../../).
" This is nearly always what you want anyway.
set gdefault

" Philosophy: Stay out of insert mode as much as humanly possible.
set noinsertmode

" Add the dash ('-'), the dot ('.'), and the '@' as "letters" to "words".
" This makes it possible to expand email addresses, e.g. guckes-www@vim.org
set iskeyword=@,48-57,_,192-255,-,.,@-@

" Insert two spaces after a period with every joining of lines.
" Bah! The 'two spaces' rule is archaic typewriter-era crap.
set nojoinspaces

" Use 'magic' patterns (extended regex) in search patterns. ("\s\+")
set magic

" Modelines are kind of ugly, and I've read there are security problems
" with them. Disabling.
set nomodeline
set modelines=0

" List of directories to search when I specify a file with an edit command.
set path=.

" Shell to use. Stick with the old standard.
let &shell="/bin/sh"

" Ignore filename with any of these suffixes when using the
" ":edit" command. Most of these are files created by LaTeX.
set suffixes=.aux,.bak,.dvi,.gz,.idx,.log,.ps,.swp,.tar,.tgz,.sit,.dmg,.hqx

" Do not jump to first character with page commands, i.e.
" keep the cursor in the current column.
set nostartofline

" Create new windows below current one.
set splitbelow

" Are we using a fast terminal?
set ttyfast

" Start scrolling before I reach the bottom of the screen, to keep more
" context around cursor.
set scrolloff=3

" What info to store from an editing session in the viminfo file;
" can be used at next session.
set viminfo=%,'50,\"100,:100,n~/.viminfo

" The char/key-combo used for "expansion" on the command line. Default is ^E.
set wildchar=<TAB>

" Show me more than the first possible completion.
set wildmenu

" Behave like a shell, show me completion only to point of ambiguity.
set wildmode=list:longest

" Write a backup before overwriting a file. This backup is then erased,
" unless 'backup' is also set. I hate tilde files, isn't this what the
" .swp files are for?
set nobackup
set nowritebackup

" Use explicit markers for folding
set foldmethod=marker

set encoding=utf-8

" Create an undo cache file for each edited file, so we can undo even
" after closing/opening a file (<filename>.un~).
"set undofile

" --------------------------------------------------------------------
" Mappings

" Caveat:  Mapping must be "prefix free", ie no mapping must be the
" prefix of any other mapping.  Example:  "map ,abc foo" and
" "map ,abcd bar" will give you the error message "Ambigous mapping".

" Turn off vim's default regex and use normal regexes (behaves more
" like Perl regex now...)
nnoremap / /\v
vnoremap / /\v

" Swap ` and '
" By default, ' jumps to the line you marked, and ` jumps to line -and-
" col that you marked. So ` is more useful. But harder to type. So swap.
noremap ' `
noremap ` '

" Reformat a selection
vmap Q gq
" ... or the current paragraph
nmap Q gqip

" Duplicate a selection
vmap D y'>p

" Disable the command 'K' (keyword lookup)
map K <NUL>

" coding tab settings (defaults)
" since et is set, no tabs will be created
" sw=4 means I'll use an indent of 4, ts (tabstop matches)
map <leader>t :set ai et sw=4 ts=4 sts=4 tw=0<CR>

" non-code tab settings
map <leader>T :set noai noet sw=4 ts=8 sts=8 tw=75<CR>

" set tab width to 4
map <leader>4 :set ts=4 sts=4<CR>

" set tab width to 8
map <leader>8 :set ts=8 sts=8<CR>

" Center a line of text
map <leader>C :center<CR>

" Don't show invisibles by default
set nolist
set listchars=tab:>-,eol:$

" Turn invisibles on/off.
nmap <leader>i :set list!<CR>

" Edit vim config.
nmap <leader>ve :e ~/.vimrc<CR>

" Reload vim config.
nmap <leader>vr :so ~/.vimrc<CR>

" Syntax modes

map <leader>s0 :syntax off<CR>
map <leader>s1 :syntax on<CR>

" Create an HTML version of our syntax! SWEET!
map <leader>H :run! syntax/2html.vim<CR>

" Perl
map <leader>spe :set syntax=perl ai et ts=4 sts=4 sw=4 tw=0<CR>
" a Perl stub header
map <leader>sps :set paste<CR>a#!/usr/local/bin/perl<CR><CR>use strict;<CR>use warnings;<CR><CR><ESC>:set nopaste<CR>a

" Python
map <leader>spy :set syntax=python ai et ts=4 sts=4 sw=4 tw=0<CR>
" PHP
map <leader>sph :set syntax=php ai et ts=4 sts=4 sw=4 tw=0<CR>
" C/C++
map <leader>sc :set syntax=c ai et ts=4 sts=4 sw=4 tw=0<CR>
" Shell
map <leader>ss :set syntax=sh ai et ts=4 sts=4 sw=4 tw=0<CR>
" Ruby
map <leader>sr :set syntax=ruby ai et ts=2 sts=2 sw=2 tw=0<CR>
" Mediawiki
map <leader>sw :set syntax=mediawiki ai et ts=4 sts=4 sw=4 tw=78<CR>


" --------------------------------------------------------------------
" General Editing
"
" Define "del" char to be the same backspace (saves a LOT of trouble!)
" As the angle notation cannot be use with the LeftHandSide
" with mappings you must type this in *literally*!
" map <C-V>127 <C-H>
"cmap <C-V>127 <C-H>
" the same for Linux Debian which uses
imap <Esc>[3~ <C-H>
imap        <C-H>
cmap        <C-H>

" ===================================================================
" Remove ALL auto-commands.  This avoids having the
" autocommands twice when the vimrc file is sourced again.
autocmd!

" Set File type to 'text' for files ending in .txt
autocmd BufNewFile,BufRead *.txt setfiletype text

" Use 'normal' tab settings for Makefiles
" Makefiles NEED tabs. Spaces do NOT work.
autocmd BufEnter [Mm]akefile* set noet ts=8 sts=8 sw=8

" .t is generally a perl test script
autocmd BufEnter *.t set syntax=perl ai et ts=4 sts=4 sw=4 tw=0

" .inc is generally PHP
autocmd BufEnter *.inc set syntax=php ai et ts=4 sts=4 sw=4 tw=0

" No highlighting at all for these file types
autocmd BufEnter *.com syntax off

" GNU M4
autocmd BufEnter *.global set syntax=m4 ai et ts=4 sts=4 sw=4 tw=0

" Mediawiki
autocmd BufRead,BufNewFile *.wiki setfiletype mediawiki

" For syntax highlighting
" I thought this was outdated, but it still breaks the terminal (2010).
if !has("gui") && has("terminfo")
    set t_Co=16
    set t_AB=[%?%p1%{8}%<%t%p1%{40}%+%e%p1%{92}%+%;%dm
    set t_AF=[%?%p1%{8}%<%t%p1%{30}%+%e%p1%{82}%+%;%dm
else
    set t_Co=16
    set t_Sf=[3%dm
    set t_Sb=[4%dm
endif

" Activate syntax highlighting
syntax on

" Custom colors
highlight Comment ctermfg=darkgrey
highlight Statement ctermfg=blue cterm=bold
highlight Identifier ctermfg=darkcyan cterm=bold
highlight ColorColumn ctermbg=lightgrey ctermfg=black

" ... for invisible.
highlight NonText ctermfg=grey
highlight SpecialKey ctermfg=grey

