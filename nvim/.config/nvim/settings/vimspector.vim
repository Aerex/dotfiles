let g:vimspector_enable_mappings = 'HUMAN'

autocmd BufRead,BufEnter vimspector* nmap <buffer> <silent> <leader>de :VimspectorEval <Right>
autocmd BufRead,BufEnter vimspector* nmap <buffer> <silent> <leader>dw :VimspectorWatch<CR>
autocmd BufRead,BufEnter vimspector* nmap <buffer> <silent> <leader>do :VimspectorShowOutput<CR>
autocmd BufRead,BufEnter vimspector* nmap <buffer> <silent> <leader>dl :VimspectorToggleLogs<CR>
autocmd BufRead,BufEnter vimspector* nmap <buffer> <silent> <leader>dr :VimspectorReset<CR>
autocmd BufRead,BufEnter vimspector* nmap <buffer> <silent> <F1>       :call vimspector#ClearBreakpoints()<CR>

