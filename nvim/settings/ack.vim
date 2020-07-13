let g:ackprg = 'rg --vimgrep'
nmap <silent><leader>rg :Rg<CR> 
nmap <silent> <leader>ag :Rg <C-R><C-W><CR>
nmap <silent> <leader>aG :call OpenAckFileVSplit()
fun! OpenAckFileVSplit()
  vsplit
  Ag <C-R><C-W>
  cclose
  wincmd l
endfu
