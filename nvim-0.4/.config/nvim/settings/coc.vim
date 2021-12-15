" Remap keys for gotos
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)


"function! s:show_documentation()
"  if &filetype == 'vim'
"    execute 'h '.expand('<cword>')
"  else
"    call CocAction('doHover')
"  endif
"endfunction

" Highlight symbol under cursor on CursorHold
"autocmd CursorHold * silent call CocActionAsync('highlight')
"
"" Remap for rename current word
"nmap <leader>rn <Plug>(coc-rename)
"
"" Remap for format selected region
"vmap <leader>f  <Plug>(coc-format-selected)
"nmap <leader>f  <Plug>(coc-format-selected)

" Setup formatexpr specified filetype(s).
"augroup mygroup
"  autocmd!
"  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"augroup end
"
"" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
"vmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-selected)
"
"" Remap for do codeAction of current line
"nmap <leader>ac  <Plug>(coc-codeaction)
"
"" Use `:Format` for format current buffer
"command! -nargs=0 Format :call CocAction('format')
"
"" Use `:Fold` for fold current buffer
"command! -nargs=? Fold :call     CocAction('fold', <f-args>)
