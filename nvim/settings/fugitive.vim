" For fugitive.git, dp means :diffput. Define dg to mean :diffget

nnoremap <silent> <Space>gs :Gstatus<CR>
nnoremap <silent> <Space>gd :Gdiff <CR> 
nnoremap <silent> <Space>gb :Gblame<CR> 
nnoremap <silent> <Space>gnb :Dispatch git checkout -b <Right>
nnoremap <silent> <Space>gw :Gwrite<CR> 
nnoremap <silent> <Space>gl :Tig log<CR> 
nnoremap <silent> <Space>gb :Gblame<CR>
vnoremap <silent> <Space>gb :Gbrowse!<CR>
vnoremap <silent> <Space><Space>gb :Gbrowse<CR>
nnoremap <silent> <Space>gb :Gblame<CR>
nnoremap <silent> <Space>gup :Guso<CR>
nnoremap <silent> <Space><Space>gb :Git branch<CR>


nnoremap <silent> <Space>hpr :Dispatch! hub-pull-request<CR>
nnoremap <silent> <Space>gp :Dispatch git push<CR>
nnoremap <silent> <Space>gmv :Gmove<CR>

:com -nargs=* Guso call GitPushUpStreamOrigin() 



function! GitPushUpStreamOrigin()
  let current_branch = substitute(system('git rev-parse --abbrev-ref HEAD'), "\n", "", "")
  :execute "Dispatch git push --set-upstream origin " .  current_branch
endfunction

autocmd BufRead, BufAdd COMMIT_EDITMSG set tw=170
"autocmd BufRead *.git xnoremap <buffer> dp :diffput<CR> 
"autocmd BufRead *.git xnoremap <buffer> do :diffget<CR> 
"autocmd BufRead *.git nmap <buffer> <c-]> ]c 
autocmd BufAdd fugitive://* nmap <buffer> } ]c
autocmd BufAdd fugitive://* nmap <buffer> { [c

"autocmd BufRead fugitive://* nmap <silent> <buffer> gp :call Gput()<CR>
"TODO: Figure out how to use gp only if you are not a buffer with 0 or 2





" Every time you open a git object using fugitive it creates a new buffer. 
" This means that your buffer listing can quickly become swamped with 
" fugitive buffers. This prevents this from becomming an issue:

autocmd BufReadPost fugitive://* set bufhidden=delete
