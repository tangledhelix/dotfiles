" Show syntax highlighting groups for word under cursor

function! SynStack()
    if !exists('*synstack')
        return
    endif
    echo map(synstack(line('.'), col('.')), "synIDattr(v:val, 'name')")
endfunc

" Example mapping:
"nmap <leader>x :call SynStack()<CR>

