" autocmd BufRead PULLREQ* imap <silent> <unique> <leader>j <Plug>JiraComplete
autocmd BufRead create* map <silent> <leader>sp  :set spell<CR>
autocmd BufRead create* map <silent> <leader>ns  :set nospell<CR>
map <leader>jcr :Dispatch jira create
map <leader>jv :Dispatch jira view DA-<Right>
map <leader>jcc :Dispatch jira c<CR>
map <leader>jcp :Dispatch jira cs<CR>
