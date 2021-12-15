let g:ale_fixers = {'javascript': ['eslint']}
let g:ale_fix_on_save = 1
autocmd FileType javascript nnoremap <leader>f :ALEFix<CR>

