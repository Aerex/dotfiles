let tern_show_signature_in_pum=1
let g:tern#command="/Users/noamfo/.nvm/versions/node/v10.9.0/bin"
let tern_show_arguments_hints='on_hold'
autocmd FileType javascript nnoremap <leader>d :TernDef<CR>
autocmd FileType javascript nnoremap <leader>D :TernDoc<CR>
autocmd FileType javascript nnoremap <leader>a :TernRename<CR>
autocmd FileType javascript nnoremap <leader>r :TernRefs:<CR>
autocmd FileType javascript setlocal omnifunc=tern#Complete
	
