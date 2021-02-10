-- VRC {{{1
vim.g.vrc_curl_opts = {
  ['--insecure'] = '',
  ['-i'] = ''
}
vim.g.vrc_set_default_mapping = 0
vim.api.nvim_exec([[
  au FileType rest nnoremap <leader>e   <cmd>call VrcQuery() <CR>
  ]],'')
---}}}
