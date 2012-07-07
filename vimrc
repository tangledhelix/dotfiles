" Bootstrap {{{

" Turn off vi compatibility. If I wanted vi, I would use vi.
set nocompatible

" Reset all autocmds
autocmd!

" Load matchit library. This lets % match if/elsif/else/end, open/close
" XML tags, stuff like that, instead of just brackets and parens.
runtime macros/matchit.vim

" Detect the OS
if has('unix')
  let s:uname = system('uname')
  if s:uname == "Darwin\n"
    let s:has_darwin = 1
  endif
endif

" ------------------------------------------------------------------------ }}}
" Pathogen {{{

" vim-pathogen, for sane plugin management.
" https://github.com/tpope/vim-pathogen

let g:pathogen_disabled = []

if !has('python')
  let g:pathogen_disabled += ['gundo']
endif

filetype off
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on

" ------------------------------------------------------------------------ }}}
" General settings {{{

let mapleader = ','
let maplocalleader = '\'

" Allow 'hidden' buffers. :help hidden
set hidden

" Ignore whitespace-only changes in diff mode
set diffopt=iwhite

" ------------------------------------------------------------------------ }}}
" General keymaps {{{

" Use jj to get back to command mode instead of Esc, which is out of the
" way and on some keyboards hard to reach. Esc still works too.
inoremap jj <Esc>
" map this too to be uniform with oh-my-zsh
inoremap jk <Esc>

" Use more natural key movement on wrapped lines.
nnoremap j gj
nnoremap k gk

" Open quickfix window
nnoremap <Leader>q :cwindow<CR>

" Source the current line
nnoremap <Leader>S ^vg_y:execute @@<CR>
vnoremap <Leader>S y:execute @@<CR>

" Redraw the screen
nnoremap <Leader>l :syntax sync fromstart<CR>:redraw!<CR>

" Define 'del' char to be the same backspace (saves a LOT of trouble!)
" As the angle notation cannot be use with the LeftHandSide
" with mappings you must type this in *literally*!
" map <C-V>127 <C-H>
" cmap <C-V>127 <C-H>
inoremap  <C-H>
cnoremap  <C-H>
" the same for Linux Debian which uses
inoremap <Esc>[3~ <C-H>

" go to location of last change
nnoremap gl `.

" Default binding for this key is useless
nnoremap K <Nop>

" ------------------------------------------------------------------------ }}}
" Messages and alerts {{{

set noerrorbells
set visualbell

" Kind of messages to show. Abbreviate them all.
set shortmess=atI

" Show a report when N lines were changed. report=0 means 'show all changes'.
set report=0

if !has('gui_running')
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
let g:Powerline_symbols = 'fancy'

" Use Powerline's Solarized theme
" let g:Powerline_theme = 'solarized'

" Set the title bar if running as GUI, but never in terminals. If set in
" a terminal, it will wipe away my title and not reset it on exit.
if has('gui_running')
  set title
else
  set notitle
endif

" Disable the toolbar in GUI mode
if has('gui_running')
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
" Map <leader>n to toggle the number column between relative (if supported),
" absolute, and off.

if exists('+relativenumber')
  set relativenumber
  set numberwidth=3

  " cycles between relative / absolute / no numbering
  function! RelativeNumberToggle()
    if (&relativenumber == 1)
      set number number?
    elseif (&number == 1)
      set nonumber number?
    else
      set relativenumber relativenumber?
    endif
  endfunc

  nnoremap <silent> <Leader>n :call RelativeNumberToggle()<CR>

else
  set number
  nnoremap <silent> <Leader>n :set number! number?<CR>
endif

" Restore cursor position from our last session, if known.
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line('$') |
  \   execute 'normal! g`"zvzz' |
  \ endif

" This only works in iTerm2. Change cursor to a bar in insert mode,
" a block in other modes.
" http://code.google.com/p/iterm2/wiki/ProprietaryEscapeCodes
" This does not work in tmux. You can make it work in tmux using
" Vitality, but Vitality does some other things that annoy me so I
" am not using it either. It turns out that the color change in
" powerline is good enough and I don't care about cursor shape.
"let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" Only show the 'margin' column in insert mode
if exists('&colorcolumn')
  autocmd InsertEnter * set colorcolumn=80
  autocmd InsertLeave * set colorcolumn=""
endif

" ------------------------------------------------------------------------ }}}
" Tabs and indenting {{{

" I've gone back and forth on this over the years, and I always come back
" to spaces instead of tabs. So be it.
set expandtab

set tabstop=2
set softtabstop=2

" Number of columns to use for (auto)indent. Generally this should be the
" same as the tabstop.
set shiftwidth=2

" Set the tab width to 2, 4, or 8.
nnoremap <Leader>2 :setlocal tabstop=2 softtabstop=2 shiftwidth=2<CR>
nnoremap <Leader>4 :setlocal tabstop=4 softtabstop=4 shiftwidth=4<CR>
nnoremap <Leader>8 :setlocal tabstop=8 softtabstop=8 shiftwidth=8<CR>

" When changing indent with <, >, >>, <<, use a multiple of shiftwidth.
set shiftround

" Keep selection when indent/dedenting in select mode.
vnoremap > >gv
vnoremap < <gv

" ------------------------------------------------------------------------ }}}
" Selecting {{{

" Reselect what was just pasted so I can so something with it.
" (To reslect last selection even if it is not the last paste, use gv.)
nnoremap <Leader>V `[v`]

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
nnoremap <silent> <Leader>y :YRShow<CR>

" Where to store the Yankring history file (don't want it in $HOME)
let g:yankring_history_dir = '$HOME/.vim'

" Key combos to copy/paste using Mac clipboard
if exists('s:has_darwin')
  nnoremap <Leader>c "*yy
  vnoremap <Leader>c "*y
  nnoremap <Leader>v "*p
  vnoremap <Leader>v "*p
  " Variants that set paste first. How to preserve paste if it's
  " already set, though?
  " nnoremap <Leader>v :set paste<CR>"*p:set nopaste<CR>
  " vnoremap <Leader>v :set paste<CR>"*p:set nopaste<CR>
else
  nnoremap <Leader>c :echo 'Only supported on Mac'<CR>
  vnoremap <Leader>c :echo 'Only supported on Mac'<CR>
  nnoremap <Leader>v :echo 'Only supported on Mac'<CR>
  vnoremap <Leader>v :echo 'Only supported on Mac'<CR>
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
nnoremap <Leader>W :call Preserve('%s/\s\+$//e')<CR>

" Swap ' for " (or vice versa) on strings, preserving cursor location
nnoremap <silent> <Leader>' :call Preserve("normal cs\"'")<CR>
nnoremap <silent> <Leader>" :call Preserve("normal cs'\"")<CR>

" Bubble selection
vmap K [egv
vmap J ]egv

" Remap ~ to cycle through uppercase, lowercase, title-case.
vnoremap ~ ygv"=TwiddleCase(@")<CR>Pgv

" In a visual block selection, insert a space or tab, then return to
" the selection. This is intended to push a block over to the right,
" e.g. a fixed-width area in a mediawiki document.
vnoremap <Space> I<Space><Esc>gv
vnoremap <Tab> I<Tab><Esc>gv

" Retain cursor position on line join
" nnoremap J mzJ`z

" Split line at cursor position
nnoremap S mzi<CR><Esc>`zj0

" Invoke Tabular
nnoremap <Leader>= :Tabularize /
vnoremap <Leader>= :Tabularize /

" ------------------------------------------------------------------------ }}}
" Wrapping {{{

" I use Vim mostly to write code. This doesn't auto-wrap lines, it only does
" a soft wrap to the window width.
set wrap

" No fixed width; 0 means to use the current window width, max out at 79.
set textwidth=0

" Break lines at whitespace or special characters (when tw != 0). Avoids lines
" where a word shows up on both the right and left edges of the screen. Which
" makes copy/paste into other apps FUN. Screws up coding. Off normally. makes copy/paste into other apps FUN. Screws up coding. Off normally.
set nolinebreak

" Backspace over indentation, end-of-line, and start-of-line.
set backspace=indent,eol,start

function ToggleShowBreak()
  if &showbreak == ''
    if has('multi_byte')
      execute('set showbreak=↪')
    endif
  else
    execute('set showbreak=')
  endif
endfunction

nnoremap <silent> <Leader>N :call ToggleShowBreak()<CR>

" ------------------------------------------------------------------------ }}}
" Folding {{{

" Use explicit markers for folding (triple curly-brace)
set foldmethod=marker

" Use space to toggle folds.
nnoremap <Space> za

" Focus on the current fold
nnoremap <Leader>z zMzvzz

" Fold current HTML tag.
nnoremap <Leader>Ft Vatzf

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
if has('persistent_undo')
  set undodir=~/.vim/tmp/undo//   " undo files
endif

" Toggle Gundo window
if has('python')
  nnoremap <Leader>u :GundoToggle<CR>
else
  nnoremap <Leader>u :echo 'Gundo requires Python support'<CR>
endif

let g:Powerline_cache_file = $HOME . '/.vim/tmp/Powerline.cache'

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
nnoremap <Leader><Space> :nohlsearch<CR>

" Turn hlsearch on or off.
nnoremap <Leader>h :set hlsearch!<CR>

" Turn off vim's default regex and use normal regexes (behaves more
" like Perl regex now...) - this is 'very magic' mode. Only alphanumerics
" and underscore are *not* quoted with backslash. See ':help magic'.
nnoremap / /\v
vnoremap / /\v

" Use 'magic' patterns (extended regex) in search patterns. ('\s\+').
" This isn't used by the / search due to the / remaps. For :s and :g.
set magic

" Assume /g at the end of any :s command. I usually want that anyway.
set gdefault

" Keep search matches positioned in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Since we borrowed , for the mapleader, replicate its purpose in \
" (the mapleader we displaced).
nnoremap \ ,

" Use ack. Grep, refined. Provided by ack.vim plugin.
" Use <CWORD> alternately if desired.
nnoremap <Leader>a :Ack <cword><CR>
" (Trailing space on below map is intentional.)
nnoremap <Leader>A :Ack --smart-case 

" Open a Quickfix window for the last search.
nnoremap <silent> <Leader>/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" ------------------------------------------------------------------------ }}}
" Invisibles {{{

" Do not show invisibles by default.
set nolist

" Turn invisibles on/off.
nnoremap <silent> <Leader>i :set list!<CR>

" How to display tabs, EOL, and other invisibles.
if has('multi_byte')
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

" Keystroke used for 'expansion' on the command line. Default is <c-e>.
set wildchar=<Tab>

" Show me more than the first possible completion.
set wildmenu

" Behave like a shell, show me completion only to point of ambiguity.
set wildmode=list:longest

" Toggle English-word completion from system dictionary. (^n, ^p)
nnoremap <silent> <Leader>E :call ToggleFlag('complete', 'k', 'English completion')<CR>

" ------------------------------------------------------------------------ }}}
" Text object 'N': number {{{

onoremap N :<C-U>call <SID>NumberTextObject(0)<CR>
xnoremap N :<C-U>call <SID>NumberTextObject(0)<CR>
onoremap aN :<C-U>call <SID>NumberTextObject(1)<CR>
xnoremap aN :<C-U>call <SID>NumberTextObject(1)<CR>
onoremap iN :<C-U>call <SID>NumberTextObject(1)<CR>
xnoremap iN :<C-U>call <SID>NumberTextObject(1)<CR>

function! s:NumberTextObject(whole)
  normal! v

  while getline('.')[col('.')] =~# '\v[0-9]'
    normal! l
  endwhile

  if a:whole
    normal! o

    while col('.') > 1 && getline('.')[col('.') - 2] =~# '\v[0-9]'
      normal! h
    endwhile
  endif
endfunction

" ------------------------------------------------------------------------ }}}
" Spelling {{{

" System dictionary to use
set dictionary=/usr/share/dict/words

" Spellcheck language
set spelllang=en_us

" Toggle spellcheck mode
nnoremap <Leader>s :set spell!<CR>

" ------------------------------------------------------------------------ }}}
" Windows and tabpages {{{

" Create new windows below current one, if no direction was specified.
set splitbelow

" Create a new vertical window to the right, and switch to it.
nnoremap <silent> <Leader>w :wincmd v<CR>:wincmd l<CR>

" Easier window nav keys (ctrl-w ctrl-<h,j,k,l>)
nnoremap <silent> <C-W><C-H> :wincmd h<CR>
nnoremap <silent> <C-W><C-J> :wincmd j<CR>
nnoremap <silent> <C-W><C-K> :wincmd k<CR>
nnoremap <silent> <C-W><C-L> :wincmd l<CR>

" Use default split window height (0 disables special help height).
set helpheight=0

" Open a new tab in the current view.
nnoremap <silent> <Leader>t :tabnew<CR>

" Navigate left/right through tabs using ^H, ^L
nnoremap <C-h> :tabprevious<CR>
nnoremap <C-l> :tabnext<CR>

" Resize splits when the window is resized.
autocmd VimResized * :wincmd =

" ------------------------------------------------------------------------ }}}
" GUI window size {{{

if has('gui_running')
  set lines=40
  set columns=90
endif

" ------------------------------------------------------------------------ }}}
" Finding and opening files {{{

" List of directories to search when I specify a file with an edit command.
set path=.

" cd to the directory of the current file. Makes it easier to :e
" files in the same directory... but it breaks gitv.
" autocmd BufEnter * cd %:p:h

" Ignore filename with any of these suffixes when using the
" ":edit" command. Most of these are files created by LaTeX.
set suffixes=.aux,.bak,.dvi,.gz,.idx,.log,.ps,.swp,.tar,.tgz,.sit,.dmg,.hqx

" Search for files with CtrlP
nnoremap <Leader>* :CtrlP<CR>

" Open filename under cursor (optionally in new tab or window)
nnoremap <Leader>of gf
vnoremap <Leader>of gf
nnoremap <Leader>ow :wincmd f
vnoremap <Leader>ow :wincmd f
nnoremap <Leader>ot :wincmd gf
vnoremap <Leader>ot :wincmd gf

" Open a file browser
nnoremap <Leader>e :edit .<CR>

" ------------------------------------------------------------------------ }}}
" Shell and external commands {{{

" Shell to use. Stick with the old standard.
let &shell='/bin/sh'

" Automatically save modifications to files when you use
" critical (external) commands.
set autowrite

" QuickRun the current buffer, autodetecting syntax
nnoremap <Leader>r :QuickRun<CR>

" Read current buffer, turn it into a bookmarklet, insert that bookmarklet
" in a comment on line 1 (discarding previously inserted bookmarklet if it
" exists), copy bookmarklet to the clipboard.
nnoremap <silent> <Leader>B :%!$HOME/.vim/bin/bookmarklet_build.pl<CR>

" Preview a markdown file in the default browser
if exists('s:has_darwin')
  nnoremap <Leader>M :w!<CR>:!$HOME/.vim/bin/markdownify % > /tmp/%.html && open /tmp/%.html<CR><CR>
endif

" Convert file, or selection, so each contiguous non-whitespace blob is
" on its own line. Strip all other whitespace.
nnoremap <Leader>1 :%!$HOME/bin/convert-to-one-string-per-line.rb<CR>
vnoremap <Leader>1 :!$HOME/bin/convert-to-one-string-per-line.rb<CR>

if has('python') && exists('s:has_darwin')

  " Reload Google Chrome on Mac from Vim.
  " Adapted from:  https://github.com/gcollazo/BrowserRefresh-Sublime/
  function! ChromeReload()
    python << EOF
from subprocess import call
browser = """
tell app "Google Chrome" to tell the active tab of its first window
  reload
end tell
"""
call(['osascript', '-e', browser])
EOF
  endfunction

  " Reload Safari on Mac from Vim.
  function! SafariReload()
    python << EOF
from subprocess import call
browser = """
tell application "Safari"
	do JavaScript "window.location.reload()" in front document
end tell
"""
call(['osascript', '-e', browser])
EOF
  endfunction

endif

" Map one or the other depending which browser I'm mostly using right now.
nnoremap <silent> <Leader>R :call SafariReload()<CR>
" nnoremap <silent> <Leader>R :call ChromeReload()<CR>

" ------------------------------------------------------------------------ }}}
" Fonts and colors {{{

if has('gui_running')
  set guifont=Menlo\ Regular\ for\ Powerline:h14
  set antialias
endif

set background=dark
colorscheme solarized

" Mark trailing whitespace with red to make it stand out.
" Mark Git-style conflict markers.
match ErrorMsg '\(\s\+$\|^\(<\|=\|>\)\{7\}\([^=].\+\)\?$\)'

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
"nnoremap <Leader>= :call Preserve('normal! gg=G')<CR>

" Create an HTML version of our syntax highlighting for display or printing.
nnoremap <Leader>H :TOhtml<CR>

" Ask Vim for the syntax type at cursor location
nnoremap <Leader>? :call SynStack()<CR>

" ------------------------------------------------------------------------ }}}
" Syntax: BIND {{{

autocmd BufNewFile,BufRead *.com setfiletype bindzone

" ------------------------------------------------------------------------ }}}
" Syntax: C {{{

autocmd FileType c setlocal foldmethod=syntax

" ------------------------------------------------------------------------ }}}
" Syntax: Email and Exim {{{

autocmd BufNewFile,BufRead aliases.* setfiletype mailaliases
autocmd BufNewFile,BufRead exim.cf* setfiletype exim

" ------------------------------------------------------------------------ }}}
" Syntax: Epub {{{

" Look inside .epub files
au BufReadCmd *.epub call zip#Browse(expand('<amatch>'))

" ------------------------------------------------------------------------ }}}
" Syntax: Erlang {{{

autocmd BufNewFile,BufRead ejabberd.cfg setfiletype erlang

" ------------------------------------------------------------------------ }}}
" Syntax: M4 {{{

autocmd BufNewFile,BufRead *.global setfiletype m4

" ------------------------------------------------------------------------ }}}
" Syntax: Make {{{

" Makefile requires real tabs, not spaces
autocmd BufNewFile,BufRead [Mm]akefile* setfiletype make
autocmd Filetype make setlocal noexpandtab

" ------------------------------------------------------------------------ }}}
" Syntax: Markdown, MultiMarkdown, Octopress {{{

" Octopress is a superset of Markdown so just use it everywhere.
" Set line wrapping for convenience.
autocmd BufNewFile,BufRead *.md,*.markdown setfiletype octopress
autocmd FileType markdown,octopress setlocal tw=78 wrap lbr ts=4 sw=4 sts=4

" Bold/italic for Markdown/Octopress (plugin 'surround')
autocmd FileType markdown,octopress let b:surround_{char2nr('i')} = "*\r*"
autocmd FileType markdown,octopress let b:surround_{char2nr('b')} = "**\r**"

" ------------------------------------------------------------------------ }}}
" Syntax: Mediawiki {{{

autocmd BufNewFile,BufRead *.wiki,*ISSwiki* setfiletype mediawiki

" Italic, bold surrounds for Mediawiki (plugin 'surround')
autocmd FileType mediawiki let b:surround_{char2nr('i')} = "''\r''"
autocmd FileType mediawiki let b:surround_{char2nr('b')} = "'''\r'''"

" Header levels 2, 3, 4
autocmd FileType mediawiki let b:surround_{char2nr('2')} = "==\r=="
autocmd FileType mediawiki let b:surround_{char2nr('3')} = "===\r==="
autocmd FileType mediawiki let b:surround_{char2nr('4')} = "====\r===="

" ------------------------------------------------------------------------ }}}
" Syntax: Perl {{{

autocmd BufNewFile,BufRead *.t setfiletype perl

" ------------------------------------------------------------------------ }}}
" Syntax: PHP {{{

autocmd BufNewFile,BufRead *.inc setfiletype php

" ------------------------------------------------------------------------ }}}
" Syntax: Rdist {{{

autocmd BufNewFile,BufRead distfile.common setfiletype rdist

" ------------------------------------------------------------------------ }}}
" Syntax: Ruby {{{

" autocmd FileType ruby setlocal foldmethod=syntax

" ------------------------------------------------------------------------ }}}
" Syntax: Shell {{{

autocmd BufNewFile,BufRead .bash/*,bash/* setfiletype sh

" ------------------------------------------------------------------------ }}}
" Syntax: Taskpaper {{{

autocmd BufNewFile,BufRead *.taskpaper setlocal foldmethod=indent noexpandtab
autocmd BufNewFile,BufRead *.taskpapertheme setfiletype xml

" ------------------------------------------------------------------------ }}}
" Syntax: Text {{{

autocmd BufNewFile,BufRead *.txt setfiletype text

" ------------------------------------------------------------------------ }}}
" Syntax: Vim {{{

" Snippet files need real tabs, at least on the left margin.
" This works out okay because when they're triggered, if expandtab
" is set, they will be translated to spaces during expansion.
autocmd FileType snippet setlocal noexpandtab

" ------------------------------------------------------------------------ }}}

" ------------------------------------------------------------------------ }}}
" Local customizations {{{

" Override this file without modifying the master copy in git.
if filereadable($HOME . '/.vimrc.local')
  source ~/.vimrc.local
endif

" ------------------------------------------------------------------------ }}}
