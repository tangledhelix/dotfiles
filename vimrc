" My Vim configuration. Crafted with love. Forever evolving.

" Bootstrap {{{

" Turn off vi compatibility. If I wanted vi, I would use vi.
set nocompatible

" Reset all autocmds
autocmd!

" Load matchit library. This lets % match if/elsif/else/end, open/close
" XML tags, stuff like that, instead of just brackets and parens.
runtime macros/matchit.vim

" Detect the OS
if has("unix")
    let s:uname = system("uname")
    if s:uname == "Darwin\n"
        let s:has_darwin = 1
    endif
endif

"    --------------------------------------------------------------------- }}}
" Pathogen {{{

" vim-pathogen, for sane plugin management.
" https://github.com/tpope/vim-pathogen

let g:pathogen_disabled = []

if !has("python")
    let g:pathogen_disabled += ["gundo"]
endif

filetype off
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on

" ------------------------------------------------------------------------ }}}
" General settings {{{

let mapleader = ","
let maplocalleader = "\\"

" Allow "hidden" buffers. :help hidden
set hidden

" Ignore whitespace-only changes in diff mode
set diffopt=iwhite

" ------------------------------------------------------------------------ }}}
" General keymaps {{{

" Use jj to get back to command mode instead of Esc, which is out of the
" way and on some keyboards hard to reach. Esc still works too.
inoremap jj <Esc>

" Use more natural key movement on wrapped lines.
nnoremap j gj
nnoremap k gk

" Hit ^L in insert mode to skip the rest of this line and go to the next
" line. This is handy when I've gotten to the end of the line, but autoclose
" has added a bunch of closing punctuation to the right. I can skip to the
" next line without having to get into normal mode and start a new line, or
" typing out the closing marks to skip them.
inoremap <c-l> <esc>A<cr>

" Open quickfix window
nnoremap <leader>q :cwindow<cr>

" Source the current line
nnoremap <leader>S ^vg_y:execute @@<cr>
vnoremap <leader>S y:execute @@<cr>

" Redraw the screen
nnoremap <leader>l :redraw!<cr>

" Define "del" char to be the same backspace (saves a LOT of trouble!)
" As the angle notation cannot be use with the LeftHandSide
" with mappings you must type this in *literally*!
" map <C-V>127 <C-H>
" cmap <C-V>127 <C-H>
inoremap  <c-h>
cnoremap  <c-h>
" the same for Linux Debian which uses
inoremap <esc>[3~ <c-h>

" ------------------------------------------------------------------------ }}}
" Messages and alerts {{{

set noerrorbells
set visualbell

" Kind of messages to show. Abbreviate them all.
set shortmess=atI

" Show a report when N lines were changed. report=0 means "show all changes".
set report=0

if !has("gui_running")
    " Terminal's visual bell - turned off to make Vim quiet.
    set t_vb=
endif

" ------------------------------------------------------------------------ }}}
" Status and title bars {{{

" Always show the status bar
set laststatus=2

" Show the current mode (INSERT, REPLACE, VISUAL, paste, etc.)
set showmode

" Show current uncompleted command.
set showcmd

" Use fancy symbols in powerline. Requires a patched font.
let g:Powerline_symbols = "fancy"

" Set the title bar if running as GUI, but never in terminals. If set in
" a terminal, it will wipe away my title and not reset it on exit.
if has("gui_running")
    set title
else
    set notitle
endif

" Disable the toolbar in GUI mode
if has("gui_running")
    set guioptions=-t
endif

" ------------------------------------------------------------------------ }}}
" Cursor and position indicators {{{

" Show current cursor line position, but only in the current window
set cursorline
autocmd WinLeave * set nocursorline
autocmd WinEnter * set cursorline

" Show row/col of cursor position, and percentage into the file we are.
set ruler

" Show line numbers as relative to current, not as absolute. This makes it
" easy to use count-based commands, e.g. 5dd or 10j. Fall back to regular
" numbering if we're on an old vim.
" Map <leader>n to toggle the number column. They get in the way of copying
" in a terminal.
if exists("+relativenumber")
    set relativenumber
    nnoremap <silent> <leader>n :set relativenumber!<cr>
    " Use static line numbers in insert mode, relative otherwise.
    autocmd InsertEnter * setlocal number
    autocmd InsertLeave * setlocal relativenumber
else
    set number
    nnoremap <silent> <leader>n :set number!<cr>
endif

" Restore cursor position from our last session, if known.
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \     execute "normal! g`\"zvzz" |
    \ endif

" This only works in iTerm2. Change cursor to a bar in insert mode,
" a block in other modes.
" http://code.google.com/p/iterm2/wiki/ProprietaryEscapeCodes
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" Only show the "margin" column in insert mode
if exists("&colorcolumn")
    autocmd InsertEnter * set colorcolumn=80
    autocmd InsertLeave * set colorcolumn=""
endif

" ------------------------------------------------------------------------ }}}
" Tabs and indenting {{{

" I've gone back and forth on this over the years, and I always come back
" to spaces instead of tabs. So be it.
set expandtab

set tabstop=4
set softtabstop=4

" Number of columns to use for (auto)indent. Generally this should be the
" same as the tabstop.
set shiftwidth=4

" Set the tab width to 2, 4, or 8.
nnoremap <leader>2 :setlocal tabstop=2 softtabstop=2 shiftwidth=2<cr>
nnoremap <leader>4 :setlocal tabstop=4 softtabstop=4 shiftwidth=4<cr>
nnoremap <leader>8 :setlocal tabstop=8 softtabstop=8 shiftwidth=8<cr>

" When changing indent with <, >, >>, <<, use a multiple of shiftwidth.
set shiftround

" Keep selection when indent/dedenting in select mode.
vnoremap > >gv
vnoremap < <gv

" ------------------------------------------------------------------------ }}}
" Selecting {{{

" Reselect what was just pasted so I can so something with it.
" (To reslect last selection even if it is not the last paste, use gv.)
nnoremap <leader>V `[v`]

" Select current line, excluding leading and trailing whitespace
nnoremap vv ^vg_

" ------------------------------------------------------------------------ }}}
" Copy and paste {{{

" Key combo to toggle paste-mode
set pastetoggle=,p

" Duplicate current selection (best used for lines, but can be used
" with any selection). Pastes duplicate at end of select region.
vnoremap D y`>p

" Toggle Yankring window
nnoremap <silent> <leader>y :YRShow<cr>

" Where to store the Yankring history file (don't want it in $HOME)
let g:yankring_history_dir = "$HOME/.vim"

" Key combos to copy/paste using Mac clipboard
if exists("s:has_darwin")
    nnoremap <leader>c "*yy
    vnoremap <leader>c "*y
    nnoremap <leader>v "*p
    vnoremap <leader>v "*p
    " Variants that set paste first. How to preserve paste if it's
    " already set, though?
    " nnoremap <leader>v :set paste<cr>"*p:set nopaste<cr>
    " vnoremap <leader>v :set paste<cr>"*p:set nopaste<cr>
else
    nnoremap <leader>c :echo "Only supported on Mac"<cr>
    vnoremap <leader>c :echo "Only supported on Mac"<cr>
    nnoremap <leader>v :echo "Only supported on Mac"<cr>
    vnoremap <leader>v :echo "Only supported on Mac"<cr>
endif

" ------------------------------------------------------------------------ }}}
" Formatting {{{

" Text formatting options, used by 'gq', 'gw' and elsewhere. :help fo-table
set formatoptions=qrn1

" Insert two spaces after a period with every joining of lines? No!
set nojoinspaces

" Reformat current selection or paragraph.
vnoremap Q gw
nnoremap Q gwip

" Strip trailing whitespace file-wide, preserving cursor location
nnoremap <leader>W :call Preserve("%s/\\s\\+$//e")<cr>

" Swap ' for " (or vice versa) on strings, preserving cursor location
nnoremap <silent> <leader>' :call Preserve("normal cs\"'")<cr>
nnoremap <silent> <leader>" :call Preserve("normal cs'\"")<cr>

" Bubble line or selection
nmap <s-up>   [e
nmap <s-down> ]e
vmap <s-up>   [egv
vmap <s-down> ]egv

" Remap ~ to cycle through " uppercase, lowercase, title-case.
vnoremap ~ ygv"=TwiddleCase(@")<cr>Pgv

" In a visual block selection, insert a space or tab, then return to
" the selection. This is intended to push a block over to the right,
" e.g. a fixed-width area in a mediawiki document.
vnoremap <space> I<space><esc>gv
vnoremap <tab> I<tab><esc>gv

" Split line at cursor position
nnoremap S i<cr><esc><right>

" Toggle autoclose mode
nmap <leader>A <Plug>ToggleAutoCloseMappings

" Invoke Tabular
nnoremap <leader>= :Tab /
vnoremap <leader>= :Tab /

" ------------------------------------------------------------------------ }}}
" Wrapping {{{

" I use Vim mostly to write code. This doesn't auto-wrap lines, it only does
" a soft wrap to the window width.
set wrap

" No fixed width; 0 means to use the current window width, max out at 79.
set textwidth=0

" Break lines at whitespace or special characters (when tw != 0). Avoids lines
" where a word shows up on both the right and left edges of the screen. Which
" makes copy/paste into other apps FUN. Screws up coding. Off normally.
set nolinebreak

" Backspace over indentation, end-of-line, and start-of-line.
set backspace=indent,eol,start

function ToggleShowBreak()
    if &showbreak == ""
        if has("multi_byte")
            execute("set showbreak=↪")
        endif
    else
        execute("set showbreak=")
    endif
endfunction

nnoremap <silent> <Leader>N :call ToggleShowBreak()<cr>

" ------------------------------------------------------------------------ }}}
" Folding {{{

" Use explicit markers for folding (triple curly-brace)
set foldmethod=marker

" Use space to toggle folds.
nnoremap <space> za

" Focus on the current fold
nnoremap <leader>z zMzvzz

" Fold current HTML tag.
nnoremap <leader>Ft Vatzf

" ------------------------------------------------------------------------ }}}
" History, undo and caches {{{

" What to store from an editing session in the viminfo file.
" Can be used at next session.
set viminfo=%,'50,\"100,:100,n~/.viminfo

" Increase the history size (default is 20).
set history=100

" Some cache / backup locations
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files
set backup                        " enable backups
" set noswapfile                    " It's 2012, Vim.
if has("persistent_undo")
    set undodir=~/.vim/tmp/undo//     " undo files
endif

" Toggle Gundo window
if has("python")
    nnoremap <leader>u :GundoToggle<cr>
else
    nnoremap <leader>u :echo "Gundo requires Python support"<cr>
endif

" ------------------------------------------------------------------------ }}}
" Search and replace {{{

" Highlight matches, and use incremental search (like iTunes).
set hlsearch
set incsearch

" Ignore case in search patterns unless an uppercase character is used
" in the search, then pay attention to case.
set ignorecase
set smartcase

" Clear the highlighted words from an hlsearch (can be visual clutter).
nnoremap <leader><space> :nohlsearch<cr>

" Turn hlsearch on or off.
nnoremap <leader>h :set hlsearch!<cr>

" Turn off vim's default regex and use normal regexes (behaves more
" like Perl regex now...) - this is "very magic" mode. Only alphanumerics
" and underscore are *not* quoted with backslash. See ":help magic".
nnoremap / /\v
vnoremap / /\v

" Use 'magic' patterns (extended regex) in search patterns. ("\s\+").
" This isn't used by the / search due to the / remaps. For :s and :g.
set magic

" Assume /g at the end of any :s command. I usually want that anyway.
set gdefault

" Keep search matches positioned in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Use ack. Grep, refined. Provided by ack.vim plugin.
" Use <CWORD> alternately if desired.
nnoremap <leader>a :Ack <cword><cr>
" (Trailing space on below map is intentional.)
nnoremap <leader>/ :Ack --smart-case 

" ------------------------------------------------------------------------ }}}
" Invisibles {{{

" Do not show invisibles by default.
set nolist

" Turn invisibles on/off.
nnoremap <silent> <leader>i :set list!<cr>

" How to display tabs, EOL, and other invisibles.
if has("multi_byte")
    set encoding=utf-8
    set showbreak=↪
    set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
else
    set listchars=tab:>-,eol:$,extends:>,precedes:<
endif

" ------------------------------------------------------------------------ }}}
" Abbreviations {{{

" Lorem ipsum text
abbr lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras a ornare metus. In justo metus, auctor nec semper in, laoreet porttitor augue. Maecenas tortor libero, dignissim vel placerat sit amet, malesuada ut quam. Curabitur vitae velit lacus, sed imperdiet sapien. Sed posuere, odio nec pharetra adipiscing

" ------------------------------------------------------------------------ }}}
" Expansion and completion {{{

" Add the dash ('-'), the dot ('.'), and the '@' as "letters" to "words".
" This makes it possible to expand email addresses, e.g. guckes-www@vim.org
set iskeyword=@,48-57,_,192-255,-,.,@-@

" Keystroke used for "expansion" on the command line. Default is <c-e>.
set wildchar=<tab>

" Show me more than the first possible completion.
set wildmenu

" Behave like a shell, show me completion only to point of ambiguity.
set wildmode=list:longest

" Toggle English-word completion from system dictionary. (^n, ^p)
nnoremap <silent> <leader>E :call ToggleFlag("complete", "k", "English completion")<cr>

" ------------------------------------------------------------------------ }}}
" Spelling {{{

" System dictionary to use
set dictionary=/usr/share/dict/words

" Spellcheck language
set spelllang=en_us

" Toggle spellcheck mode
nnoremap <leader>s :set spell!<cr>

" ------------------------------------------------------------------------ }}}
" Windows and tabpages {{{

" Create new windows below current one, if no direction was specified.
set splitbelow

" Create a new vertical window to the right, and switch to it.
nnoremap <silent> <leader>w :wincmd v<cr>:wincmd l<cr>

" Easier navigation keys (ctrl + normal movement keys: h,j,k,l)
nnoremap <silent> <c-h> :wincmd h<cr>
nnoremap <silent> <c-j> :wincmd j<cr>
nnoremap <silent> <c-k> :wincmd k<cr>
nnoremap <silent> <c-l> :wincmd l<cr>

" Use default split window height (0 disables special help height).
set helpheight=0

" Open a new tab in the current view.
nnoremap <silent> <leader>t :tabnew<cr>

" Navigate left/right through tabs using shift + left/right arrow keys.
nnoremap <silent> <s-left>  :tabprevious<cr>
nnoremap <silent> <s-right> :tabnext<cr>

" Resize splits when the window is resized.
autocmd VimResized * :wincmd =

" ------------------------------------------------------------------------ }}}
" GUI window size {{{

if has("gui_running")
    set lines=40
    set columns=90
endif

" ------------------------------------------------------------------------ }}}
" Finding and opening files {{{

" List of directories to search when I specify a file with an edit command.
set path=.

" cd to the directory of the current file. Makes it easier to :e
" files in the same directory.
autocmd BufEnter * cd %:p:h

" Ignore filename with any of these suffixes when using the
" ":edit" command. Most of these are files created by LaTeX.
set suffixes=.aux,.bak,.dvi,.gz,.idx,.log,.ps,.swp,.tar,.tgz,.sit,.dmg,.hqx

" Search for files with CtrlP
nnoremap <leader>* :CtrlP<cr>

" Open filename under cursor (optionally in new tab or window)
nnoremap <leader>of gf
vnoremap <leader>of gf
nnoremap <leader>ow :wincmd f
vnoremap <leader>ow :wincmd f
nnoremap <leader>ot :wincmd gf
vnoremap <leader>ot :wincmd gf

" Open a file browser
nnoremap <leader>e :edit .<cr>

" ------------------------------------------------------------------------ }}}
" Shell and external commands {{{

" Shell to use. Stick with the old standard.
let &shell="/bin/sh"

" Automatically save modifications to files when you use
" critical (external) commands.
set autowrite

" QuickRun the current buffer, autodetecting syntax
nnoremap <leader>r :QuickRun<cr>

" Read current buffer, turn it into a bookmarklet, insert that bookmarklet
" in a comment on line 1 (discarding previously inserted bookmarklet if it
" exists), copy bookmarklet to the clipboard.
nnoremap <silent> <leader>B :%!$HOME/.vim/bin/bookmarklet_build.pl<cr>

" Preview a markdown file in the default browser
if exists("s:has_darwin")
    nnoremap <leader>M :w!<cr>:!$HOME/.vim/bin/markdownify % > /tmp/%.html && open /tmp/%.html<cr><cr>
endif

" Convert file, or selection, so each contiguous non-whitespace blob is
" on its own line. Strip all other whitespace.
nnoremap <leader>1 :%!$HOME/bin/convert-to-one-string-per-line.rb<cr>
vnoremap <leader>1 :!$HOME/bin/convert-to-one-string-per-line.rb<cr>

" Reload Google Chrome on Mac from Vim.
" Adapted from:  https://github.com/gcollazo/BrowserRefresh-Sublime/
if has("python") && exists("s:has_darwin")
    function! ChromeReload()
        python << EOF
from subprocess import call
browser = """
tell application "Google Chrome" to tell the active tab of its first window
    reload
end tell
-- tell application "Google Chrome" to activate
"""
call(['osascript', '-e', browser])
EOF
    endfunction
endif

nnoremap <silent> <Leader>R :call ChromeReload()<cr>

" ------------------------------------------------------------------------ }}}
" Fonts and colors {{{

if has("gui_running")
    set guifont=Menlo\ Regular\ for\ Powerline:h14
    set antialias
endif

set background=light
colorscheme solarized

" Mark trailing whitespace with red to make it stand out.
match ErrorMsg "\s\+$"

" ------------------------------------------------------------------------ }}}
" Syntax {{{

" Syntax: General {{{

" 'syntax enable' will turn on syntax highlighting without wiping out
" any highlight commands already in place. 'syntax on' will reset it
" all to defaults. So I use 'syntax on' and put my highlight commands
" after this point, that way I can ':so ~/.vimrc' and reset everything
" whenever I want.
syntax on

" When positioned on a bracket, highlight its partner.
set showmatch

" Modelines are kind of ugly, and I've read there are security problems
" with them. Disabling.
" Hah, this is funny, I was just trying to convince my team to start using
" modelines, and here I have them disabled, claiming security problems.
set nomodeline
set modelines=0

" Re-indent entire file, preserving cursor location
"nnoremap <leader>= :call Preserve("normal! gg=G")<cr>

" Create an HTML version of our syntax highlighting for display or printing.
nnoremap <leader>H :TOhtml<cr>

" Ask Vim for the syntax type at cursor location
nnoremap <leader>? :call SynStack()<cr>

" ------------------------------------------------------------------------ }}}
" Syntax: BIND {{{

autocmd BufNewFile,BufRead *.com set filetype=bindzone

" ------------------------------------------------------------------------ }}}
" Syntax: C {{{

autocmd FileType c setlocal foldmethod=syntax

" ------------------------------------------------------------------------ }}}
" Syntax: Email and Exim {{{

autocmd BufNewFile,BufRead aliases.* set filetype=mailaliases
autocmd BufNewFile,BufRead exim.cf* set filetype=exim

" ------------------------------------------------------------------------ }}}
" Syntax: Epub {{{

" Look inside .epub files
au BufReadCmd *.epub call zip#Browse(expand("<amatch>"))

" ------------------------------------------------------------------------ }}}
" Syntax: Erlang {{{

autocmd BufNewFile,BufRead ejabberd.cfg set filetype=erlang

" ------------------------------------------------------------------------ }}}
" Syntax: M4 {{{

autocmd BufNewFile,BufRead *.global set filetype=m4

" ------------------------------------------------------------------------ }}}
" Syntax: Make {{{

" Makefile requires real tabs, not spaces
autocmd BufNewFile,BufRead [Mm]akefile* set filetype=make noexpandtab

" ------------------------------------------------------------------------ }}}
" Syntax: Markdown, MultiMarkdown, Octopress {{{

" Octopress is a superset of Markdown so just use it everywhere.
" Set line wrapping for convenience.
autocmd BufNewFile,BufRead *.md,*.markdown set filetype=octopress textwidth=78 wrap linebreak

" Bold/italic for Markdown/Octopress (plugin 'surround')
autocmd FileType markdown,octopress let g:surround_{char2nr("i")} = "*\r*"
autocmd FileType markdown,octopress let g:surround_{char2nr("b")} = "**\r**"

" ------------------------------------------------------------------------ }}}
" Syntax: Mediawiki {{{

autocmd BufNewFile,BufRead *.wiki,*ISSwiki* set filetype=mediawiki

" Italic, bold surrounds for Mediawiki (plugin 'surround')
autocmd FileType mediawiki let g:surround_{char2nr("i")} = "''\r''"
autocmd FileType mediawiki let g:surround_{char2nr("b")} = "'''\r'''"

" Header levels 2, 3, 4
autocmd FileType mediawiki let g:surround_{char2nr("2")} = "==\r=="
autocmd FileType mediawiki let g:surround_{char2nr("3")} = "===\r==="
autocmd FileType mediawiki let g:surround_{char2nr("4")} = "====\r===="

" ------------------------------------------------------------------------ }}}
" Syntax: Perl {{{

autocmd BufNewFile,BufRead *.t set filetype=perl

" ------------------------------------------------------------------------ }}}
" Syntax: PHP {{{

autocmd BufNewFile,BufRead *.inc set filetype=php

" ------------------------------------------------------------------------ }}}
" Syntax: Rdist {{{

autocmd BufNewFile,BufRead distfile.common set filetype=rdist

" ------------------------------------------------------------------------ }}}
" Syntax: Ruby {{{

autocmd FileType ruby setlocal foldmethod=syntax

" ------------------------------------------------------------------------ }}}
" Syntax: Shell {{{

autocmd BufNewFile,BufRead .bash/*,bash/* set filetype=sh

" ------------------------------------------------------------------------ }}}
" Syntax: Taskpaper {{{

autocmd BufNewFile,BufRead *.taskpaper setlocal foldmethod=indent noexpandtab

" ------------------------------------------------------------------------ }}}
" Syntax: Version control {{{

" Highlight VCS conflict markers, e.g. those in Git
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" ------------------------------------------------------------------------ }}}
" Syntax: Vim {{{

" Snippet files need real tabs, at least on the left margin.
" This works out okay because when they're triggered, if expandtab
" is set, they will be translated to spaces during expansion.
autocmd FileType snippet set noexpandtab

" ------------------------------------------------------------------------ }}}

" ------------------------------------------------------------------------ }}}
" Local customizations {{{

" Override this file without modifying the master copy in git.
if filereadable($HOME . "/.vimrc.local")
    source ~/.vimrc.local
endif

" ------------------------------------------------------------------------ }}}
