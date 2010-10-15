" Vim configuration

" ------------------------------------------------------------------------
" Initial config, library and plugin loading {{{

" This needs to be first, because it changes Vim's behavior in many places.
" Turn off vi compatibility. If I wanted vi, I would use vi.
set nocompatible

" Define my leader key (my personal namespace in the keymap).
let mapleader=","

" Load Pathogen (sanely manages and compartmentalizes plugins, etc.)
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Use filetype detection, including syntax-aware indenting
filetype plugin indent on

" Load matchit library. This lets % match if/elsif/else/end, open/close
" XML tags, stuff like that, instead of just brackets and parens.
runtime macros/matchit.vim

" }}}
" --------------------------------------------------------------------
" Tab settings {{{

" Expand tabs to spaces (soft tabs). I HATE TABS.
set expandtab

" My tab width is 4. Because 8 is too much, but 2 is visually too small
" for code nesting IMO.
set tabstop=4
set softtabstop=4

" Number of spaces to use for (auto)indent.
set shiftwidth=4

" coding tab settings (should match defaults)
nmap <leader>t :setlocal ai si ci et sw=4 ts=4 sts=4 tw=0<CR>

" non-code tab settings
nmap <leader>T :setlocal noai nosi noci noet sw=8 ts=8 sts=8 tw=75<CR>

" Set tab width to 2, 4, or 8
nmap <leader>2 :setlocal ts=2 sts=2 sw=2<CR>
nmap <leader>4 :setlocal ts=4 sts=4 sw=4<CR>
nmap <leader>8 :setlocal ts=8 sts=8 sw=8<CR>

" Re-tab the current file (changes tab->space or space->tab depending on the
" current setting of expandtab).

nmap <leader><tab> :if &expandtab <Bar>
    \   set noet <Bar>
    \else <Bar>
    \   set et <Bar>
    \endif<CR>
    \:retab!<CR>

" }}}
" --------------------------------------------------------------------
" Indenting {{{

"  Good for coding. Handles indenting of blocks automatically.
set autoindent

" Copies the indentation characters of the previous line. This will
" help avoid situations where I edit a file and my expandtab makes
" a space-indented line just below a tab-indented line.
set copyindent

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

" When changing indent with < and >, use a multiple of shiftwidth.
set shiftround

" }}}
" --------------------------------------------------------------------
" Wrapping {{{

" I use Vim mostly to write code. This doesn't auto-wrap lines, it only does
" a soft wrap to the window width.
set wrap

" Where to wrap. See <leader>t and <leader>T mappings.
" By default, do not wrap at all (aggravating while coding).
set textwidth=0

" Break lines at whitespace or special characters (when tw != 0). Avoids lines
" where a word shows up on both the right and left edges of the screen. Which
" makes copy/paste into other apps FUN. Screws up coding.
set nolinebreak

" Backspace over indentation, end-of-line, and start-of-line. See help.
set backspace=indent,eol,start

" Define wrapping behavior. See help.
"set whichwrap=<,>,h,l
"set whichwrap=b,s,<,>

" Wrap the line when we get this close to the right margin.
"set wrapmargin=4

" }}}
" --------------------------------------------------------------------
" Search and replace {{{

" Highlight search - show the current search pattern.
set hlsearch

" Clear the highlighted words from an hlsearch. (Can be visual clutter)
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

" Turn off vim's default regex and use normal regexes (behaves more
" like Perl regex now...) - this is "very magic" mode. Only alphanumerics
" and underscore are *not* quoted with backslash. See ":help magic".
nnoremap / /\v
vnoremap / /\v

" Use 'magic' patterns (extended regex) in search patterns. ("\s\+")
set magic

" Assume /g at the end of any :s command. I usually want that anyway.
set gdefault

" }}}
" --------------------------------------------------------------------
" Sounds and alerts {{{

set noerrorbells

" Show a report when N lines were changed. report=0 means "show all changes".
set report=0

" Kind of messages to show. Abbreviate them all.
set shortmess=atI

" Flash the screen instead of making a beep.
set visualbell

" Terminal's visual bell - turned off to make Vim quiet.
set t_vb=

" }}}
" --------------------------------------------------------------------
" Status indicators {{{

" Do not put the current file / buffer name in the title bar.
set notitle

" Show the status line
set laststatus=2

" Status line format
set statusline=%<%f\ %h%m%r%y\ %=%-14.(%l,%c%V%)\ %P

" Show current uncompleted command.
set showcmd

" When positioned on a bracket, highlight its partner.
set showmatch

" Show the current mode.
set showmode

" Don't show invisibles by default
set nolist
set listchars=tab:>-,eol:$

" Turn invisibles on/off.
nmap <leader>i :set list!<CR>

" }}}
" --------------------------------------------------------------------
" Line numbering / position indicators {{{

" I don't want absolute line numbers.
set nonumber

" Show line numbers as relative to current, not as absolute. This makes it
" easy to use count-based commands, e.g. 5dd or 10j.
if v:version >= 703
    set relativenumber
endif

" Toggle relativenumber column. They get in the way of copying in a terminal.
nmap <leader>n :set relativenumber!<CR>

" Show row/col of cursor position, and percentage into the file we are.
set ruler

" Show current cursor line position. In terminals, this underlines the line,
" which is ugly. It's fine in MacVim.
"set cursorline

" Warn on long lines. Looks like crap in a terminal (see .gvimrc).
"set colorcolumn=81

" }}}
" --------------------------------------------------------------------
" Formatting {{{

" Text formatting options, used by 'gq' and elsewhere
set formatoptions=qrn1

" Insert two spaces after a period with every joining of lines.
" No! The 'two spaces' rule is archaic typewriter-era nonsense.
set nojoinspaces

" Reformat current selection or paragraph
vmap Q gq
nmap Q gqip

" Center current line or selection
nmap <leader>C :center<CR>
vmap <leader>C :center<CR>

" Toggle autoclose mode
nmap <leader>A <Plug>ToggleAutoCloseMappings

" Strip trailing whitespace file-wide
nnoremap <silent> <leader>W :call Preserve("%s/\\s\\+$//e")<CR>

" }}}
" --------------------------------------------------------------------
" Navigation {{{

" Disallow usage of cursor keys within insert mode.
set noesckeys

" Do not jump to line start with page commands, i.e. keep the current column.
set nostartofline

" Keep a few lines above/below the cursor when I scroll to next screen.
set scrolloff=3

" By default, ' jumps to the line you marked, and ` jumps to line -and- col
" that you marked. So ` is more useful. But harder to type. So swap them.
noremap ' `
noremap ` '

" When I have long lines and 'wrap' is true, I often use j,k to move up or
" down, and it skips to the next real line, rather than the next line
" on the display, and that's annoying. These remaps make j and k honor the
" _displayed_ lines instead of the actual lines. 'v' maps make this work in
" a wrapped-line selection as well.
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Go to matching brace / delimiter using <tab>. % still works.
nnoremap <tab> %
vnoremap <tab> %

" Stay out of insert mode as much as humanly possible.
set noinsertmode

" }}}
" ----------------------------------------------------------------------
" Folding {{{

" Use explicit markers for folding (triple curly-brace)
set foldmethod=marker

" Fold current HTML tag.
nnoremap <leader>ft Vatzf

" }}}
" ----------------------------------------------------------------------
" Syntax-related mappings {{{

" Toggle syntax highlighting. The .gvimrc is reloaded to fix syntax colors.
nmap <silent> <leader>S :if exists("g:syntax_on") <Bar>
    \   syntax off <Bar>
    \else <Bar>
    \   syntax enable<CR>
    \   if filereadable($MYGVIMRC) <Bar>
    \       so $MYGVIMRC <Bar>
    \   endif <Bar>
    \endif <CR>

" Re-indent entire file, returning to the cursor position you started from.
nmap <leader>= :call Preserve("normal gg=G")<CR>

" Create an HTML version of our syntax highlighting for display or printing.
nmap <leader>H :TOhtml<CR>

" Insert a Perl stub header
nmap <leader>sps :set paste<CR>a#!/usr/local/bin/perl<CR><CR>use strict;<CR>use warnings;<CR><CR><ESC>:set nopaste<CR>a

" Manually set the file type for various languages
nmap <leader>spe :setfiletype perl<CR>
nmap <leader>spy :setfiletype python<CR>
nmap <leader>sph :setfiletype php<CR>
nmap <leader>sc :setfiletype c<CR>
nmap <leader>ss :setfiletype sh<CR>
nmap <leader>sr :setfiletype ruby<CR>
nmap <leader>sw :setfiletype mediawiki<CR>

" }}}
" ----------------------------------------------------------------------
" Vim pseudo-windows {{{

" Create new windows below current one, if no direction was specified.
set splitbelow

" Create a new vertical window to the right, and switch to it.
nnoremap <leader>w :wincmd v<CR>:wincmd l<CR>

" Easier navigation keys (ctrl + normal movement keys h,j,k,l)
map <C-h> :wincmd h<CR>
map <C-j> :wincmd j<CR>
map <C-k> :wincmd k<CR>
map <C-l> :wincmd l<CR>

" Use default split window height (0 disables special help height).
set helpheight=0

" }}}
" --------------------------------------------------------------------
" File handling, system interaction {{{

" Automatically save modifications to files when you use
" critical (rxternal) commands.
set autowrite

" List of directories to search when I specify a file with an edit command.
set path=.

" Ignore filename with any of these suffixes when using the
" ":edit" command. Most of these are files created by LaTeX.
set suffixes=.aux,.bak,.dvi,.gz,.idx,.log,.ps,.swp,.tar,.tgz,.sit,.dmg,.hqx

" Write a backup before overwriting a file. This backup is then erased,
" unless 'backup' is also set. I hate tilde files, isn't this what the
" .<filename>.swp file is for?
set nobackup
set nowritebackup

" Shell to use. Stick with the old standard.
let &shell="/bin/sh"

" }}}
" --------------------------------------------------------------------
" Expansion {{{

" Add the dash ('-'), the dot ('.'), and the '@' as "letters" to "words".
" This makes it possible to expand email addresses, e.g. guckes-www@vim.org
set iskeyword=@,48-57,_,192-255,-,.,@-@

" The char/key-combo used for "expansion" on the command line. Default is ^E.
set wildchar=<TAB>

" Show me more than the first possible completion.
set wildmenu

" Behave like a shell, show me completion only to point of ambiguity.
set wildmode=list:longest

" }}}
" --------------------------------------------------------------------
" Copy and paste {{{

" Key combo to toggle paste-mode
set pastetoggle=,,

" Duplicate current selection (best used for lines, but can be used
" with any selection). Pastes duplicate at end of select region.
vmap D y'>p

" Reselect what was just pasted so I can so something with it.
nnoremap <leader>v V`]

" Toggle Yankring window
nnoremap <silent> <leader>y :YRShow<CR>

" Can yankring share its data between instances of Vim?
let g:yankring_share_between_instances = 1

" Can yankring keep data in a persistent file?
let g:yankring_persist = 1

" Put yankring data somewhere other than $HOME
let g:yankring_history_dir = "$HOME/.vim"

" }}}
" --------------------------------------------------------------------
" History and undo {{{

" What info to store from an editing session in the viminfo file;
" can be used at next session.
set viminfo=%,'50,\"100,:100,n~/.viminfo

" Increase the history size (default is 20).
set history=100

" Create an undo cache file for each edited file, so we can undo even
" after closing/opening a file (<filename>.un~). This has some appeal,
" but I don't want the litter.
"set undofile

" }}}
" --------------------------------------------------------------------
" Finding and opening files {{{

" Toggle the NERDTree browser.
nmap <leader>/ :NERDTreeToggle<CR>

" This variant is supposed to honor the current working directory, but that
" does not work with :cd as I expected it would.
"nmap <leader>/ :execute 'NERDTreeToggle ' . getcwd()<CR>

" NERDTree should close when I choose a file to open
let NERDTreeQuitOnOpen=1

" Open FuzzyFinder in file mode. This *does* work properly with :cd.
nmap <leader>* :FufFile<CR>

" }}}
" --------------------------------------------------------------------
" Misc. settings {{{

" Allow "hidden" buffers. See :help hidden
set hidden

" Modelines are kind of ugly, and I've read there are security problems
" with them. Disabling.
set nomodeline
set modelines=0

" Are we using a fast terminal?
set ttyfast

" }}}
" --------------------------------------------------------------------
" Misc. mappings {{{

" Use jj to get back to command mode instead of ESC, which is out of the
" way. ESC still works too.
inoremap jj <ESC>

" Remap F1 to ESC, because they're right next to each other, and I know how
" to type ":help" already, thank you very much.
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Swap ; in place of : for commands - no need to hit shift constantly.
" Note: do not map : back to ; to try to reclaim the ';' functionality,
" it'll break half the plugins.
nnoremap ; :

" Define "del" char to be the same backspace (saves a LOT of trouble!)
" As the angle notation cannot be use with the LeftHandSide
" with mappings you must type this in *literally*!
" map <C-V>127 <C-H>
"cmap <C-V>127 <C-H>
" the same for Linux Debian which uses
imap <Esc>[3~ <C-H>
imap        <C-H>
cmap        <C-H>

" }}}
" --------------------------------------------------------------------
" Auto-command triggers {{{

if has("autocmd")
    autocmd!

    autocmd BufNewFile,BufRead *.t setfiletype perl
    autocmd BufNewFile,BufRead *.inc setfiletype php
    autocmd BufNewFile,BufRead *.com setfiletype bindzone
    autocmd BufNewFile,BufRead *.global setfiletype m4
    autocmd BufNewFile,BufRead *.wiki,*ISSwiki* setfiletype mediawiki
    autocmd BufNewFile,BufRead .bash/*,.dotfiles/bash* setfiletype sh
    autocmd BufNewFile,BufRead distfile.common,Distfile setfiletype rdist
    autocmd BufNewFile,BufRead ejabberd.cfg setfiletype erlang

    autocmd FileType ruby setlocal ts=2 sts=2 sw=2 et
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 et

    " Makefiles need real tabs.
    autocmd BufNewFile,BufRead [Mm]akefile* setfiletype make
    autocmd FileType make setlocal ts=8 sts=8 sw=8 noet

    " Save all unclean buffers when focus is lost (ala TextMate).
    " Not sure whether I like this idea yet.
    "au FocusLost * :wa

endif

" }}}
" --------------------------------------------------------------------
" Colors {{{

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
syntax enable

" Custom colors (MacVim colors are in .gvimrc)
highlight Comment ctermfg=darkgrey
highlight Statement ctermfg=blue cterm=bold
highlight Identifier ctermfg=darkcyan cterm=bold
highlight Search term=reverse ctermbg=11
highlight ColorColumn ctermbg=lightgrey ctermfg=black
" invisibles...
highlight NonText ctermfg=grey
highlight SpecialKey ctermfg=grey

" }}}
" --------------------------------------------------------------------
