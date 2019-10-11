  if exists(":Tabularize")
    nmap <silent> <leader>=a :Tabularize /=<CR>
    vmap <silent> <leader>=a :Tabularize /=<CR>
    nmap <silent> <leader>=: :Tabularize /:\zs<CR>
    vmap <silent> <leader>=: :Tabularize /:\zs<CR>
  endif
