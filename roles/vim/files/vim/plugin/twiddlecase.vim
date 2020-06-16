" Toggles between uppercase, lowercase, titlecase. Bind to a mapping, then
" select something and keep hitting the map until you get what you want.

function! TwiddleCase(str)
    if a:str ==# toupper(a:str)
        let result = tolower(a:str)
    elseif a:str ==# tolower(a:str)
        let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
    else
        let result = toupper(a:str)
    endif
    return result
endfunction

" Example mapping
"vnoremap ~ ygv"=TwiddleCase(@")<CR>Pgv

