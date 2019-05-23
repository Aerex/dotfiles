let g:vimtex_complete_enabled = 1
let g:vimtex_complete_close_braces = 1
let g:vimtex_complete_img_use_tail = 1
let g:vimtex_complete_recursive_bib = 1
let g:vimtex_quickfix_open_on_warning = 0 
let g:vimtex_quickfix_mode = 2
let g:vimtex_view_method = 'zathura'
" let g:vimtex_view_general_viewer = 'zathura'
" let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
" let g:vimtex_view_general_options_latexmk = '--unique'
let g:vimtex_compiler_latexmk = { 'build_dir' : 'build' }
if !exists('g:ycm_semantic_triggers')
  let g:ycm_semantic_triggers = {}
endif
" To access function you will source it 
" https://github.com/junegunn/vim-plug/issues/662#issuecomment-317200820
au VimEnter *.tex 
    \  if !exists('g:ycm_semantic_triggers')
    \ |  let g:ycm_semantic_triggers = {}
    \ |endif
    \ |let g:ycm_semantic_triggers.tex = g:vimtex#re#youcompleteme

au FileType tex map <leader>b :VimtexCompile<CR> 
au FileType tex map <leader><leader>c :VimtexClean<CR> 

let g:vimtex_fold_enabled = 1
let g:vimtex_fold_manual = 1
let g:vimtex_view_method = 'zathura'
let g:vimtex_quickfix_open_on_warning = 0 " stop with the hbox warnings
let g:vimtex_compiler_latexmk_engines = {
      \ '_'                : '-xelatex',
      \ 'pdflatex'         : '-pdf',
      \ 'dvipdfex'         : '-pdfdvi',
      \ 'lualatex'         : '-lualatex',
      \ 'xelatex'          : '-xelatex',
      \ 'context (pdftex)' : '-pdf -pdflatex=texexec',
      \ 'context (luatex)' : '-pdf -pdflatex=context',
      \ 'context (xetex)'  : '-pdf -pdflatex=''texexec --xtx''',
\}

let g:vimtex_compiler_latexmk = {
      \ 'background' : 1,
      \ 'build_dir' : 'build',
      \ 'callback' : 1,
      \ 'continuous' : 1,
      \ 'executable' : 'latexmk',
      \ 'options' : [
      \   '-xelatex',
      \   '-pdf',
      \   '-verbose',
      \   '-file-line-error',
      \   '-synctex=1',
      \   '-interaction=nonstopmode',
      \ ],
      \}

" Contribution: https://github.com/jtlaune/dotfiles-arch/blob/87c9eecd1e3782e913df6e7fb6b8e926e7357d5e/vim/.vimrc#L27
" Don't wrap lines unless its a latex file.

"augroup WrapLineInTeXFile
"  autocmd!
"  autocmd FileType tex setlocal wrap
"  autocmd FileType tex setlocal textwidth=117
"augroup END
