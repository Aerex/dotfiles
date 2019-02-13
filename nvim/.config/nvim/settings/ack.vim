let g:ackprg = 'ag --nogroup --nocolor --column'
nmap <leader>ag :Ack ""<Left>
nmap <leader><leader>ag :Ack <C-R><C-W> --word<CR>
nmap <leader>af :AckFile ""<Left>
