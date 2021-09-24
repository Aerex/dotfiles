if executable('node')
  nmap <leader>'ta  :TW add ""<Left>
  nmap <leader>'ts :TW sync<CR>
  nmap <leader>'tu :TWUndo<CR>
  nmap <leader>'tq <plug>(taskwarrior_quickref)
  "nmap <silent> <leader>,td <Plug>(taskwarrior_done)<CR>
  "nmap <silent> <leader>,ts <Plug>(taskwarrior_sync)<CR>
  "nmap <silent> <leader>,tq <Plug>(taskwarrior_quickref)<CR>


  augroup TaskwarriorMapping
    autocmd!
    autocmd FileType taskreport nmap <buffer> D
          \ <Plug>(taskwarrior_remove)
    autocmd FileType taskreport nunmap <buffer> D 
  augroup END

  augroup TaskwarriorMapping
    autocmd!
    autocmd FileType taskreport nmap <buffer> n
          \ <Plug>(taskwarrior_annotate)
    autocmd FileType taskreport nunmap <buffer> n 
  augroup END
endif


