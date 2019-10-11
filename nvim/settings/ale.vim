let g:ale_completion_enabled = 0
let g:ale_disable_lsp = 0
let g:ale_fixers = {'javascript': ['eslint']}
let g:ale_lint_on_enter = 0
"let g:ale_fix_on_save = 1
autocmd FileType javascript nnoremap <leader>f :ALEFix<CR>

