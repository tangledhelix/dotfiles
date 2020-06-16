" Maps <C-h/j/k/l> to switch vim splits in the given direction. If there are
" no more windows in that direction, forwards the operation to tmux.
" Additionally, <C-\> toggles between last active vim splits/tmux panes.

if $TMUX != ''

    let s:tmux_is_last_pane = 0
    au WinEnter * let s:tmux_is_last_pane = 0

    " Like `wincmd` but also change tmux panes instead of vim windows when needed.
    function s:TmuxWinCmd(direction)
        let nr = winnr()
        let tmux_last_pane = (a:direction == 'p' && s:tmux_is_last_pane)
        if !tmux_last_pane
            " try to switch windows within vim
            exec 'wincmd ' . a:direction
        endif
        " Forward the switch panes command to tmux if:
        " a) we're toggling between the last tmux pane;
        " b) we tried switching windows in vim but it didn't have effect.
        if tmux_last_pane || nr == winnr()
            let cmd = 'tmux select-pane -' . tr(a:direction, 'phjkl', 'lLDUR')
            call system(cmd)
            let s:tmux_is_last_pane = 1
            "echo cmd
        else
            let s:tmux_is_last_pane = 0
        endif
    endfunction

    " navigate between split windows/tmux panes
    nnoremap <silent> <c-j> :call <SID>TmuxWinCmd('j')<cr>
    nnoremap <silent> <c-k> :call <SID>TmuxWinCmd('k')<cr>
    nnoremap <silent> <c-h> :call <SID>TmuxWinCmd('h')<cr>
    nnoremap <silent> <c-l> :call <SID>TmuxWinCmd('l')<cr>
    nnoremap <silent> <c-\> :call <SID>TmuxWinCmd('p')<cr>

else
    " Use the standard maps when outside of tmux
    nnoremap <silent> <c-h> :wincmd h<cr>
    nnoremap <silent> <c-j> :wincmd j<cr>
    nnoremap <silent> <c-k> :wincmd k<cr>
    nnoremap <silent> <c-l> :wincmd l<cr>
end
