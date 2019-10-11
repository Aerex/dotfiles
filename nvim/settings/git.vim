" vim: fdm=marker 
"Fugitive ----------------------------------------------------------------- {{{1

" For fugitive.git, dp means :diffput. Define dg to mean :diffget
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiffsplit! <CR> 
nnoremap <silent> <leader>gb :Gblame<CR> 
nnoremap <silent> <leader>gnb :Dispatch git checkout -b <Right>
nnoremap <silent> <leader>gw :Gwrite<CR> 
nnoremap <silent> <leader>gl :Glog! <CR> 
vnoremap <silent> <leader>yg :Gbrowse!<CR>
vnoremap <silent> <leader>yG :Gbrowse<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gup :Guso<CR>



nnoremap <silent> <leader>hprd :Start hub-pull-request -c  -b "dray-alliace:develop"<CR>
nnoremap <silent> <leader>hprm :Start hub-pull-request -c -b "dray-alliance:master"<CR>
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
"autocmd BufRead *.git xnoremap <buffer> dp :diffput<CR> 
"autocmd BufRead *.git xnoremap <buffer> do :diffget<CR> 
"autocmd BufRead *.git nmap <buffer> <c-]> ]c 
autocmd BufAdd fugitive://* nmap <buffer> } ]c
autocmd BufAdd fugitive://* nmap <buffer> { [c

"autocmd BufRead fugitive://* nmap <silent> <buffer> gp :call Gput()<CR>
"TODO: Figure out how to use gp only if you are not a buffer with 0 or 2


nmap <leader>[ <Plug>GitGutterPrevHunk<CR>
nmap <leader>] <Plug>GitGutterNextHunk<CR>



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
let g:gitgutter_grep = 'ag'

"To turn off signs by default
let g:gitgutter_signs = 0


if filereadable(expand('~/.config/nvim/plugged/vim-gitgutter/plugin/gitgutter.vim'))
	" Don't show gitgutter signs in files with more than 500 changes
	let g:gitgutter_max_signs = 500
endif

map <leader>ggt :GitGutterToggle<CR>
map <leader>ggst :GitGutterSignsToggle<CR>

nmap <leader>[ <Plug>GitGutterPrevHunk<CR>
nmap <leader>] <Plug>GitGutterNextHunk<CR>

nmap <leader>hp <Plug>GitGutterPreviewHunk
nmap <leader>hs <Plug>GitGutterStageHunk
nmap <leader>hu <Plug>GitGutterUndoHunk

omap ih <Plug>GitGutterTextObjectInnerPending
omap ah <Plug>GitGutterTextObjectOuterPending
xmap ih <Plug>GitGutterTextObjectInnerVisual
xmap ah <Plug>GitGutterTextObjectOuterVisual


