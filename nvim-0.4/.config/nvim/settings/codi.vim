function! s:pp_js(line)
  " Strip escape codes
  return substitute(a:line,"\<esc>".'\[\d\(\a\|\dm\)', '', 'g')
endfunction

let g:code#interpreters = {
\ 'javascript': {
  \'bin': 'node',
  \'prompt': '^\(>\|\.\.\.\+\) ',
\ 'rightalight': 0
\ }
\}
