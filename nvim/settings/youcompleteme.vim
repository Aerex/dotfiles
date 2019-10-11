" Remap keys for gotos
"nmap <silent> gd :YcmCompleter GoToDeclaration<CR>
" nmap <silent> gD :YcmCompleter GetDoc<CR>


" nmap <silent> gr :YcmCompleter GoToReferences<CR>
" au FileType javascript nmap <silent> <leader>oi :YcmCompleter OrganizerImports<CR>
" au FileType javascript nmap <silent> <leader>yrs :YcmRestartServer<CR>
" au FileType javascript nmap <silent> <leader>F :YcmCompleter FixIt<CR>
" au FileType javascript nmap <silent> gd :YcmCompleter GoToDefinition<CR>

" " Remap for rename current word
" nmap <leader>rn :YcmCompleter RefactorRename <C-R><C-W><Right>

" " Remap for format selected region
" au FileType javascript vmap <leader>f  :YcmCompleter Format<CR> 


" " Use `:Fold` for fold current buffer
" function youcompleteme#DisableCursorMovedAutocommands()
"     autocmd! ycmcompletemecursormove CursorMoved *
"     autocmd! ycmcompletemecursormove CursorMovedI *
" endfunction
" function youcompleteme#EnableCursorMovedAutocommands()
"     augroup ycmcompletemecursormove
"         autocmd!
"         autocmd CursorMovedI * call s:OnCursorMovedInsertMode()
"         autocmd CursorMoved * call s:OnCursorMovedNormalMode()
"     augroup END
" endfunction
" command! YcmUnlock call youcompleteme#EnableCursorMovedAutocommands()
" command! YcmLock call youcompleteme#DisableCursorMovedAutocommands()	

" let OS=substitute(system('uname -s'),"\n","","")

" if(OS == "Darwin")
" 	let g:ycm_path_to_python_interpreter = '/Library/Frameworks/Python.framework/Version/3.7/bin/python3'
" 	let g:ycm_server_python_interpreter = '/usr/bin/python'
" else
" 	let g:ycm_path_to_python_interpreter = '/usr/bin/python3.6'
" 	let g:ycm_server_python_interpreter = '/usr/bin/python3.6'
" endif
