augroup qutebrowser
  autocmd!
  autocmd BufRead qutebrowser-editor-* set wrap
  autocmd BufRead qutebrowser-editor-* colorscheme jellybeans
  autocmd BufRead qutebrowser-editor-* hi! Normal ctermbg=NONE guibg=NONE
  autocmd BufRead qutebrowser-editor-* nmap <silent> <leader>sp : call ToggleSpell()<CR>
augroup END

