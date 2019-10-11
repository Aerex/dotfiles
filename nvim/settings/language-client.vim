"let javascript_lc_binary = expand('~/bin/javascript-typescript-stdio')
"let g:LanguageClient_changeThrottle = 0.5
"let g:LanguageClient_windowLogMessageLevel = "Error"
"let g:LanguageClient_loggingFile = expand('~/.config/nvim/LanguageClient.log')
"let g:LanguageClient_diagnosticsDisplay = {
"\   1: {  'signText': '✖', 'texthl': 'none', 'signTexthl': 'none' },
"\   2: {  'signText': '⚠', 'texthl': 'none' },
"\   3: {  'signText': 'ℹ ', 'texthl': 'none' },
"\   4: { 'signTexthl': 'Todo' },
"\}
"let g:LanguageClient_useVirtualText  = 0
"let g:LanguageClient_serverCommands = {
"    \ 'javascript': [javascript_lc_binary],
"    \ 'typescript': [javascript_lc_binary],
"    \ 'javascript.jsx': [javascript_lc_binary]
"    \ }
"function LC_maps()
"  if has_key(g:LanguageClient_serverCommands, &filetype)
"
"    if &filetype == 'javascript'
"      autocmd FileType javascript setlocal omnifunc=LanguageClient#complete
"    endif
"    " Rename - rn => rename
"    noremap <leader>rn :call LanguageClient#textDocument_rename()<CR>
"
"    " Rename - rc => rename camelCase
"    noremap <leader>rc :call LanguageClient#textDocument_rename(
"                \ {'newName': Abolish.camelcase(expand('<cword>'))})<CR>
"
"    " Rename - rs => rename snake_case
"    noremap <leader>rs :call LanguageClient#textDocument_rename(
"                \ {'newName': Abolish.snakecase(expand('<cword>'))})<CR>
"
"    " Rename - ru => rename UPPERCASE
"    noremap <leader>ru :call LanguageClient#textDocument_rename(
"                \ {'newName': Abolish.uppercase(expand('<cword>'))})<CR>
"
"    nnoremap <silent> gd :call LanguageClient#textDocument_definition({'gotoCmd': 'split'})<CR>
"    nnoremap <silent> <leader>rn :call LanguageClient#textDocument_rename()<CR>
"    nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
"    nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
"    nnoremap <silent> <leader>le :call LanguageClient#explainErrorAtPoint()<CR>
"    nnoremap <buffer> <silent> gr :call LanguageClient#textDocument_references()<CR>
"    nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
"    nnoremap <leader>lc :call LanguageClient#textDocument_completion()<CR>
"    nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>
"    nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
"    nnoremap <buffer> <silent> lm :call LanguageClient_contextMenu()<CR>
"  endif
"endfunction
"
"let g:LanguageClient_rootMarkers = ['.git']
"autocmd FileType * call LC_maps()
"
