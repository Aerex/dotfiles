" vim: fdm=marker 
"Fugitive ----------------------------------------------------------------- {{{1

" For fugitive.git, dp means :diffput. Define dg to mean :diffget
nnoremap <silent> <leader>gs :Git<CR>
nnoremap <silent> <leader>gd :Gdiffsplit! <CR> 
nnoremap <silent> <leader>gb :Git blame<CR>
nnoremap <silent> <leader>gnb :Dispatch git checkout -b <Right>
nnoremap <silent> <leader>gw :Gwrite<CR> 
nnoremap <silent> <leader>gl :Git log <CR> 
vnoremap <silent> <leader>yg :Gbrowse!<CR>
vnoremap <silent> <leader>yG :Gbrowse<CR>
nnoremap <silent> <leader>gup :Guso<CR>

let g:tmux_max_pane='1'
let g:gitgutter_sh="sh"
nnoremap <silent> <leader>gp :Dispatch git push<CR>
nnoremap <silent> <leader>gmv :Gmove<CR>

:com! -nargs=* Guso call GitPushUpStreamOrigin() 


function! HubPullRequest(_base)
  let base = a:_base 
  if &base != '' 
    :execute "Dispatch hub-pull-request -c -b " . base 
  endif
endfunction
function! GitPushUpStreamOrigin()
  let current_branch = substitute(system('git rev-parse --abbrev-ref HEAD'), "\n", "", "")
  :execute "Dispatch git push --set-upstream origin " .  current_branch
endfunction

autocmd BufRead,BufAdd COMMIT_EDITMSG set tw=170
autocmd BufRead,BufAdd PULLREQ_EDITMSG set tw=0 wrap
autocmd BufAdd fugitive://* nmap <buffer> ] ]c
autocmd BufAdd fugitive://* nmap <buffer> [ [c

" nmap <leader>[ <Plug>GitGutterPrevHunk<CR>
" nmap <leader>] <Plug>GitGutterNextHunk<CR>



" Every time you open a git object using fugitive it creates a new buffer. 
" This means that your buffer listing can quickly become swamped with 
" fugitive buffers. This prevents this from becomming an issue:

autocmd BufReadPost fugitive://* set bufhidden=delete

nmap <leader>gv :Gitv --all<CR>
nmap <leader>gV :Gitv! --all<CR>
vmap <leader>gV  :Gitv! --all<CR>
let g:Gitv_DoNotMapCtrlKey = 1
 

"https://vim.fandom.com/wiki/Folding_for_diff_files
"When inspecting large diff/patch files, the following fold function is handy. Put it in your ftplugin/diff.vim file or equivalent.
setlocal foldmethod=expr foldexpr=DiffFold(v:lnum)
function! DiffFold(lnum)
  let line = getline(a:lnum)
  if line =~ '^\(diff\|---\|+++\|@@\) '
    return 1
  elseif line[0] =~ '[-+ ]'
    return 2
  else
    return 0
  endif
endfunction

"Git Gutter  ----------------------------------------------------------------- {{{1
"Use a custom grep command
"If you use an alternative to grep, you can tell vim-gitgutter to use it here.
"let g:gitgutter_grep = 'rg'

""To turn off signs by default
"let g:gitgutter_signs = 0
"let g:gitgutter_enabled = 0


" if filereadable(expand('~/.config/nvim/plugged/vim-gitgutter/plugin/gitgutter.vim'))
" 	" Don't show gitgutter signs in files with more than 500 changes
" 	let g:gitgutter_max_signs = 500
" endif

" function! ToggleGitGutter()
"   :exec GitGutterSignsEnable
"   :exec GitGutterSignsEnable

" endfunction

" :com! -nargs=* ToggleGitGutter call ToggleGitGutter() 
" map <leader>,ggt :call ToggleGitGutter()<cr>
" map <leader>ggt :GitGutterToggle<CR>
"map <leader>ggst :GitGutterSignsToggle<CR>

" omap ih <Plug>GitGutterTextObjectInnerPending
" omap ah <Plug>GitGutterTextObjectOuterPending
" xmap ih <Plug>GitGutterTextObjectInnerVisual
" xmap ah <Plug>GitGutterTextObjectOuterVisual

" nmap ]h <Plug>(GitGutterNextHunk)<CR>
" nmap [h <Plug>(GitGutterPrevHunk)<CR>

" nmap <leader>hp <Plug>(GitGutterPreviewHunk)
" nmap <leader>hs <Plug>(GitGutterStageHunk)
" nmap <leader>hu <Plug>(GitGutterUndoHunk)

" omap ih <Plug>GitGutterTextObjectInnerPending
" omap ah <Plug>GitGutterTextObjectOuterPending
" xmap ih <Plug>GitGutterTextObjectInnerVisual
" xmap ah <Plug>GitGutterTextObjectOuterVisual


