" Intelligent Indent
" Author: Michael Geddes < vimmer at frog dot wheelycreek dot net >
" Version: 2.6
" Last Modified: December 2010
"
" Histroy:
"   1.0: - Added RetabIndent command - similar to :retab, but doesn't cause
"         internal tabs to be modified.
"   1.1: - Added support for backspacing over spaced tabs 'smarttab' style
"        - Clean up the look of it by blanking the :call
"        - No longer a 'filetype' plugin by default.
"   1.2: - Interactions with 'smarttab' were causing problems. Now fall back to
"          vim's 'smarttab' setting when inserting 'indent' tabs.
"        - Fixed compat with digraphs (which were getting swallowed)
"        - Made <BS> mapping work with the 'filetype' plugin mode.
"        - Make CTabAlignTo() public.
"   1.3: - Fix removing trailing spaces with RetabIndent! which was causing
"          initial indents to disappear.
"   1.4: - Fixed Backspace tab being off by 1
"   2.0: - Add support for alignment whitespace for mismatched brackets to be spaces.
"   2.1: - Fix = operator
"   2.3: - Fix (Gene Smith) for error with non C files
"        - Add option for filetype maps
"        - Allow for lisp indentation
"   2.4: - Fix bug in Retab
"   2.5: - Fix issue with <CR> not aligning
"   2.6: - Fix issue with alignment not disappearing.

" This is designed as a filetype plugin (originally a 'Buffoptions.vim' script).
"
" The aim of this script is to be able to handle the mode of tab usage which
" distinguishes 'indent' from 'alignment'.  The idea is to use <tab>
" characters only at the beginning of lines.
"
" This means that an individual can use their own 'tabstop' settings for the
" indent level, while not affecting alignment.
"
" The one caveat with this method of tabs is that you need to follow the rule
" that you never 'align' elements that have different 'indent' levels.
"
" :RetabIndent[!] [tabstop]
"     This is similar to the :retab command, with the exception that it
"     affects all and only whitespace at the start of the line, changing it to
"     suit your current (or new) tabstop and expandtab setting.
"     With the bang (!) at the end, the command also strips trailing
"     whitespace.
"
"  CTabAlignTo(n)
"     'Tab' to the n'th column from the start of the indent.

" g:ctab_filetype_maps
"   set this to true if script used as a filetype plugin
" g:ctab_disable_checkalign
"   set this to true to disable re-check of alignment
" g:ctab_enable_default_filetype_maps
"   disable the filetype specific maps
" g:ctab_disable_tab_maps
"   disable the (original) tab mappings

if  exists('g:ctab_filetype_maps') && g:ctab_filetype_maps
  let s:buff_map=' <buffer> '
else
  let s:buff_map=''
endif

if exists('g:ctab_enable_default_filetype_maps') && ctab_enable_default_filetype_maps
  if s:buff_map != ''
    if (&filetype =~ '^\(cpp\|idl\)$' )
      imap <silent> <buffer> <expr> <m-;> CTabAlignTo(20).'//'
      imap <silent> <buffer> <expr> <m-s-;> CTabAlignTo(30).'//'
      imap <silent> <buffer> º <m-s-;>
    elseif &filetype == 'c'
      imap <expr> <silent> <buffer> <m-;> CTabAlignTo(10).'/*  */<left><left><left>'
    endif
  else
    au FileType cpp,idl imap <expr> <silent> <buffer> <m-;> CTabAlignTo(20).'//'
    au FileType cpp,idl imap <expr> <silent> <buffer> <m-:> CTabAlignTo(30).'//'
    au FileType c imap <expr> <silent> <buffer> <m-;> CTabAlignTo(10).'/*  */<left><left>'
  endif
endif

if !exists('g:ctab_disable_tab_maps') || ! g:ctab_disable_tab_maps
  exe  'imap '.s:buff_map.'<silent> <expr> <tab> <SID>InsertSmartTab()'
  exe  'inoremap '.s:buff_map.'<silent> <expr> <BS> <SID>DoSmartDelete()."\<BS>"'
endif

"exe 'imap '.s:buff_map.'<silent> <expr> <BS> <SID>KeepDelLine()."\<BS>"

" MRG: TODO
"exe 'imap '.s:buff_map.'<silent> <expr> <c-d> :call <SID>SmartDeleteTab()<CR>'
"exe 'imap '.s:buff_map.'<silent> <c-t> <SID>SmartInsertTab()'
" fun! s:SmartDeleteTab()
"   let curcol=col('.')-&sw
"   let origtxt=getline('.')
"   let repl=matchstr(origtxt,'^\s\{-}\%'.(&sw+2)."v')
"   if repl == '' then
"     return "\<c-o>".':s/	*\zs	/'.repeat(' ',(&ts-&sw)).'/'."\<CR>\<c-o>".curcol.'|'
"   else
"     return "\<c-o>".':s/^\s\{-}\%'.(&sw+1)."v//\<CR>\<c-o>".curcol."|"
"   end
"
" endfun

" Insert a smart tab.
fun! s:InsertSmartTab()
  " Clear the status
  echo ''
  if strpart(getline('.'),0,col('.')-1) =~'^\s*$'
    if exists('b:ctab_hook') && b:ctab_hook != ''
      exe 'return '.b:ctab_hook
    elseif exists('g:ctab_hook') && g:ctab_hook != ''
      exe 'return '.g:ctab_hook
    endif
    return "\<Tab>"
  endif

  let sts=exists("b:insidetabs")?(b:insidetabs):((&sts==0)?&sw:&sts)
  let sp=(virtcol('.') % sts)
  if sp==0 | let sp=sts | endif
  return strpart("                  ",0,1+sts-sp)
endfun

fun! s:CheckLeaveLine(line)
  if ('cpo' !~ 'I') && exists('b:ctab_lastalign') && (a:line == b:ctab_lastalign)
    s/^\s*$//e
  endif
endfun

" Check on blanks
aug Ctab
au! InsertLeave * call <SID>CheckLeaveLine(line('.'))
aug END


" Do a smart delete.
" The <BS> is included at the end so that deleting back over line ends
" works as expected.
fun! s:DoSmartDelete()
  " Clear the status
  "echo ''
  let uptohere=strpart(getline('.'),0,col('.')-1)
  " If at the first part of the line, fall back on defaults... or if the
  " preceding character is a <TAB>, then similarly fall back on defaults.
  "
  let lastchar=matchstr(uptohere,'.$')
  if lastchar == "\<tab>" || uptohere =~ '^\s*$' | return '' | endif        " Simple cases
  if lastchar != ' ' | return ((&digraph)?("\<BS>".lastchar): '')  | endif  " Delete non space at end / Maintain digraphs

  " Work out how many tabs to use
  let sts=(exists("b:insidetabs")?(b:insidetabs):((&sts==0)?(&sw):(&sts)))

  let ovc=virtcol('.')              " Find where we are
  let sp=(ovc % sts)                " How many virtual characters to delete
  if sp==0 | let sp=sts | endif     " At least delete a whole tabstop
  let vc=ovc-sp                     " Work out the new virtual column
  " Find how many characters we need to delete (using \%v to do virtual column
  " matching, and making sure we don't pass an invalid value to vc)
  let uthlen=strlen(uptohere)
  let bs= uthlen-((vc<1)?0:(  match(uptohere,'\%'.(vc-1).'v')))
  let uthlen=uthlen-bs
  " echo 'ovc = '.ovc.' sp = '.sp.' vc = '.vc.' bs = '.bs.' uthlen='.uthlen
  if bs <= 0 | return  '' | endif

  " Delete the specifed number of whitespace characters up to the first non-whitespace
  let ret=''
  let bs=bs-1
  if uptohere[uthlen+bs] !~ '\s'| return '' | endif
  while bs>=-1
    let bs=bs-1
    if uptohere[uthlen+bs] !~ '\s' | break | endif
    let ret=ret."\<BS>"
  endwhile
  return ret
endfun

fun! s:Column(line)
  let c=0
  let i=0
  let len=strlen(a:line)
  while i< len
    if a:line[i]=="\<tab>"
      let c=(c+&tabstop)
      let c=c-(c%&tabstop)
    else
      let c=c+1
    endif
    let i=i+1
  endwhile
  return c
endfun
fun! s:StartColumn(lineNo)
  return s:Column(matchstr(getline(a:lineNo),'^\s*'))
endfun

fun! CTabAlignTo(n)
  let co=virtcol('.')
  let ico=s:StartColumn('.')+a:n
  if co>ico
    let ico=co
  endif
  let spaces=ico-co
  let spc=''
  while spaces > 0
    let spc=spc." "
    let spaces=spaces-1
  endwhile
  return spc
endfun

if ! exists('g:ctab_disable_checkalign') || g:ctab_disable_checkalign==0
  " Check the alignment of line.
  " Used in the case where some alignment whitespace is required .. like for unmatched brackets.
  fun! s:CheckAlign(line)
    if &expandtab || !(&autoindent || &indentexpr || &cindent)
      return ''
    endif

    let tskeep=&ts
    let swkeep=&sw
    try
      if a:line == line('.')
        let b:ctab_lastalign=a:line
      else
        unlet b:ctab_lastalign
      endif
      set ts=50
      set sw=50
      if &indentexpr != ''
        let v:lnum=a:line
        sandbox exe 'let inda='.&indentexpr
        if inda == -1
          let inda=indent(a:line-1)
        endif
      elseif &cindent
        let inda=cindent(a:line)
      elseif &lisp
        let inda=lispindent(a:line)
      elseif &autoindent
        let inda=indent(a:line)
      elseif &smarttab
        return ''
      else
        let inda=0
      endif
    finally
      let &ts=tskeep
      let &sw=swkeep
    endtry
    let indatabs=inda / 50
    let indaspace=inda % 50
    let indb=indent(a:line)
    if indatabs*&tabstop + indaspace == indb
      let txtindent=repeat("\<Tab>",indatabs).repeat(' ',indaspace)
      call setline(a:line, substitute(getline(a:line),'^\s*',txtindent,''))
    endif
    return ''
  endfun
  fun! s:SID()
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
  endfun
  " Get the spaces at the end of the  indent correct.
  " This is trickier than it should be, but this seems to work.
  fun! s:CheckCR()
    " echo 'SID:'.s:SID()
    if getline('.') =~ '^\s*$'
      if ('cpo' !~ 'I') && exists('b:ctab_lastalign') && (line('.') == b:ctab_lastalign)
        return "^\<c-d>\<CR>"
      endif
      return "\<CR>"
    else
      return "\<CR>\<c-r>=<SNR>".s:SID().'_CheckAlign(line(''.''))'."\<CR>\<END>"
    endif
  endfun

  "exe 'inoremap '.s:buff_map.'<silent> <CR> <CR><c-r>=<SID>CheckAlign(line(''.''))."\<lt>END>"<CR>'
  exe 'inoremap '.s:buff_map.'<silent> <expr> <CR> <SID>CheckCR()'
  exe 'nnoremap '.s:buff_map.'<silent> o o<c-r>=<SID>CheckAlign(line(''.''))."\<lt>END>"<CR>'
  exe 'nnoremap '.s:buff_map.'<silent> O O<c-r>=<SID>CheckAlign(line(''.''))."\<lt>END>"<CR>'

  " Ok.. now re-evaluate the = re-indented section

  " The only way I can think to do this is to remap the =
  " so that it calls the original, then checks all the indents.
  exe 'map '.s:buff_map.'<silent> <expr> = <SID>SetupEqual()'
  fun! s:SetupEqual()
    set operatorfunc=CtabRedoIndent
    " Call the operator func so we get the range
    return 'g@'
  endfun

  fun! CtabRedoIndent(type,...)
    set operatorfunc=
    let ln=line("'[")
    let lnto=line("']")
    " Do the original equals
    norm! '[=']

    if ! &et
      " Then check the alignment.
      while ln <= lnto
        silent call s:CheckAlign(ln)
        let ln+=1
      endwhile
    endif
  endfun
endif

" Retab the indent of a file - ie only the first nonspace
fun! s:RetabIndent( bang, firstl, lastl, tab )
  let checkspace=((!&expandtab)? "^\<tab>* ": "^ *\<tab>")
  let l = a:firstl
  let force= a:tab != '' && a:tab != 0 && (a:tab != &tabstop)
  let checkalign = ( &expandtab || !(&autoindent || &indentexpr || &cindent)) && (!exists('g:ctab_disable_checkalign') || g:ctab_disable_checkalign==0)
  let newtabstop = (force?(a:tab):(&tabstop))
  while l <= a:lastl
    let txt=getline(l)
    let store=0
    if a:bang == '!' && txt =~ '\s\+$'
      let txt=substitute(txt,'\s\+$','','')
      let store=1
    endif
    if force || txt =~ checkspace
      let i=indent(l)
      let tabs= (&expandtab ? (0) : (i / newtabstop))
      let spaces=(&expandtab ? (i) : (i % newtabstop))
      let txtindent=repeat("\<tab>",tabs).repeat(' ',spaces)
      let store = 1
      let txt=substitute(txt,'^\s*',txtindent,'')
    endif
    if store
      call setline(l, txt )
      if checkalign
        call s:CheckAlign(l)
      endif
    endif

    let l=l+1
  endwhile
  if newtabstop != &tabstop | let &tabstop = newtabstop | endif
endfun


" Retab the indent of a file - ie only the first nonspace.
"   Optional argument specified the value of the new tabstops
"   Bang (!) causes trailing whitespace to be gobbled.
com! -nargs=? -range=% -bang -bar RetabIndent call <SID>RetabIndent(<q-bang>,<line1>, <line2>, <q-args> )


" vim: sts=2 sw=2 et
