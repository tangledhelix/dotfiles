" Append an empty numbered list of the count requested, e.g.
"
"   1.
"   2.
"   3.
"   ...
"
" Invoke with ":NumList n"

command! -nargs=1 NumList call GenericNumberedList(<f-args>)

function! GenericNumberedList(count)
    let curr = 1
    let max = a:count
    let currLine = line(".")

    while (curr <= max)
        call append(currLine, curr.". ")
        let curr += 1
        let currLine += 1
    endwhile
endfunction

