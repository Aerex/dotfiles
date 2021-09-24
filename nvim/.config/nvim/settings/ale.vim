let g:ale_completion_enabled = 0
let g:ale_disable_lsp = 0
let g:ale_fixers = {'javascript': ['eslint'], 'javascriptreact': ['eslint']}
let g:ale_lint_on_enter = 0
let g:ale_linters = { 'php': ['php'] }
autocmd FileType javascript,javascriptreact nnoremap <leader>f :ALEFix<CR>

