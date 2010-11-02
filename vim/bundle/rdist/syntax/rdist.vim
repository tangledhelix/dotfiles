" Vim syntax file
" Language:     Rdist
" Maintainer:   Dan Lowe <dan@tangledhelix.com>
" URL:          <none>
" Last Change:  2010/Oct/10

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

" define the rdist syntax
syn match rdistComment /#.*/ contains=rdistTodo
syn keyword rdistTodo TODO FIX FIXME NOTE XXX WARNING contained
syn region rdistString start=/"/hs=s+1 skip=/\\"/ end=/"/he=e-1
syn region rdistString start=/'/hs=s+1 skip=/\\'/ end=/'/he=e-1
syn keyword rdistCommand cmdspecial except except_pat install notify special nextgroup=rdistCommandOption
syn match rdistCommandOption /\<-o\S\+/
syn match rdistVariable /${[a-zA-Z0-9_]\+}/
syn match rdistRule /^[a-zA-Z0-9_-]\+\s*:/he=e-1

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_rdist_syn_inits")
	if version < 508
		let did_rdist_syn_inits = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif

	HiLink rdistComment Comment
	HiLink rdistTodo Todo
	HiLink rdistString String
	HiLink rdistCommand Statement
	HiLink rdistVariable Identifier
	HiLink rdistRule Function
	" No good Vim syntax fit for this, IMO. Calling it a PreProc so it's
	" colored differently than the rdistCommand that precedes it.
	HiLink rdistCommandOption PreProc

	delcommand HiLink
endif

let b:current_syntax = "rdist"

