" Border style (rounded / sharp / horizontal)
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Todo', 'border': 'sharp' } }
" Shortcuts for opening up results in splits
let g:fzf_action = {
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
nnoremap <silent> <leader>p :GFiles<CR>
nnoremap <silent> <leader>,p :Files<CR>
nnoremap <silent> <leader>m :History<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>v :Commands<CR>
nnoremap <silent> <leader>yr :Registers<CR>


 autocmd  FileType fzf set laststatus=0 noshowmode noruler
       \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--info=inline', '--prompt', '> ']}), <bang>0)

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

 function! s:setcwd()
   let cph = expand('%:p:h', 1)
   if cph =~ '^.\+://' | retu | en
   for mkr in ['.git/', '.hg/', 'node_modules/', '.svn/', '.bzr/', '_darcs/', '.vimprojects', 'init.vim']
     let wd = call('find'.(mkr =~ '/$' ? 'dir' : 'file'), [mkr, cph.';'])
     if wd != '' | let &acd = 0 | brea | en
   endfo
   exe 'lc!' fnameescape(wd == '' ? cph : substitute(wd, mkr.'$', '.', ''))
 endfunction

 autocmd BufEnter * call s:setcwd()

 let g:yankring_history_file = '.yankring-history'
 let s:yr_elem_hash = {}
 function! s:get_yankring() 
   function! s:get_clipboard()
    let yr_history_list = []
    let filepath = g:yankring_history_dir . '/' . g:yankring_history_file . '_v2.txt'
    if filereadable(filepath)
      let yr_history_list = readfile(filepath)
    endif
    return yr_history_list

   endfunction
  silent let clipboard_output = s:get_clipboard()
  let content_list = []
  let display_nbr = 1
  for line in clipboard_output
      let display_content = substitute(line, ',V$', '', '')
      if (display_content != '')
        call add(content_list, display_content)
        let s:yr_elem_hash[display_content] = display_nbr
      endif
      let display_nbr += 1
  endfor
  return content_list
 endfunction

function! s:yr_get_element_paste_handler(line)
  let l:clip = get(s:yr_elem_hash, a:line, 0)
  YRGetElem(l:clip)
endfunction


function! FZFYankRing()
  call fzf#run({
  \ 'source':  s:get_yankring(),
  \ 'sink':    function('s:yr_get_element_paste_handler'),
  \ 'options': '--info=inline --ansi --prompt "Clipboard> " ',
  \ 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Todo', 'border': 'sharp' } 
  \})
endfunction

command! -nargs=* -bang Registers call FZFYankRing()

