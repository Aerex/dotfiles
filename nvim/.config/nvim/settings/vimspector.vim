let g:vimspector_enable_mappings = 'HUMAN'

autocmd FileType VimspectorPrompt nmap <buffer> <silent> <leader>de :VimspectorEvalNeovim<Right>
autocmd FileType VimspectorPrompt nmap <buffer> <silent> <leader>dw :VimspectorWatch<CR>
autocmd FileType VimspectorPrompt nmap <buffer> <silent> <leader>do :VimspectorShowOutput<CR>
autocmd FileType VimspectorPrompt nmap <buffer> <silent> <leader>dl :VimspectorToggleLogs<CR>
autocmd FileType VimspectorPrompt nmap <buffer> <silent> <leader>dr :VimspectorReset<CR>
autocmd FileType VimspectorPrompt nmap <buffer> <silent> <F1>       :call vimspector#ClearBreakpoints()<CR>



command! -bang -nargs=* DebugEvalNeovim call VimspectorEvalNeovim(<q-args>,<bang>0)

function !VimspectorEvalNeovim(cmd)
  call vimspector#Evaluate(a:cmd)
endfunction

