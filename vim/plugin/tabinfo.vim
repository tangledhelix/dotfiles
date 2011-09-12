" Set tabstop, softtabstop and shiftwidth to the same value
" Invoke as :Stab
command! -nargs=* Stab call Stab()
function! Stab()
	let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
	if l:tabstop > 0
		let &l:sts = l:tabstop
		let &l:ts = l:tabstop
		let &l:sw = l:tabstop
	endif
	call SummarizeTabs()
endfunction

" Just show the current state without setting anything.
function! SummarizeTabs()
	try
		echohl ModeMsg
		echon 'tabstop='.&l:ts
		echon ' shiftwidth='.&l:sw
		echon ' softtabstop='.&l:sts
		if &l:et
			echon ' expandtab'
		else
			echon ' noexpandtab'
		endif
	finally
		echohl None
	endtry
endfunction

