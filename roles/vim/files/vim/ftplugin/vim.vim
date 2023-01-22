" fix a behavior with the autopairs plugin where it will behave badly
" with vim comments on a new line. disable the " character in autopairs
" in this syntax only, to fix it.
if has_key(g:AutoPairs, '"')
    let b:AutoPairs = copy(g:AutoPairs)
    call remove(b:AutoPairs, '"')
endif
