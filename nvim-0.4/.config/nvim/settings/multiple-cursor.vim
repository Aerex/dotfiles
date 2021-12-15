let g:yankring_enabled = 1  " Enables the yankring
"This allows one to search for the keyword using * and turn search results into cursors with Alt-j.
nnoremap <silent> <M-j> :MultipleCursorsFind <C-R>/<CR>
vnoremap <silent> <M-j> :MultipleCursorsFind <C-R>/<CR>

function! Multiple_cursors_before()
    exe 'YcmLock'
    g:yankring_enabled = 0  " Disables the yankring
endfunction

function! Multiple_cursors_after()
    exe 'YcmUnlock'
    g:yankring_enabled = 1  " Renable the yankring

endfunction
