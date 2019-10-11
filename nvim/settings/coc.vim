" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent><leader>k :call <SID>show_documentation()<CR>


" Show all diagnostics
nnoremap <silent> <leader>ld  :<C-u>CocList diagnostics<cr>
" Edit config 
nnoremap <silent> <leader>lce :call EditCocConfig()<CR> 
" Manage extensions
nnoremap <silent> <leader>lex  :<C-u>CocList extensions<cr>
map <leader>led  :<C-u>CocUninstall 
" Show commands
nnoremap <silent> <leader>lcm  :<C-u>CocList commands<CR>
" Install extension from coc markertplace
nnoremap <silent> <leader>lm :CocList marketplace<CR>
" Fix autofix problem of current line
nmap <leader>lf  <Plug>(coc-fix-current)
" Find symbol of current document
nnoremap <silent> <leader>o  :<C-u>CocList outline<cr>



function! EditCocConfig()
  execute "vs | CocConfig"
endfunction
function! s:show_documentation()
if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')
"
"" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
"
"" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Setup formatexpr specified filetype(s).
augroup mygroup
  autocmd!
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
augroup end

"" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

"" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)

"" Use `:Format` for format current buffer
command! -nargs=0 Format :call CocAction('format')

"" Use `:Fold` for fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)





" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" " Use <c-space> to trigger completion.
" inoremap <silent><expr> <c-space> coc#refresh()

" " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" " Coc only does snippet and additional edit on confirm.
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

