let g:ackprg = 'rg --vimgrep'
nmap <silent><leader>rg :RG<CR> 
nmap <silent> <leader>ag :Rg <C-R><C-W><CR>
nmap <silent> <leader>aG :call OpenAckFileVSplit()
" nmap <silent> <leader>ag :call RGVisualSelect()<CR>
" nmap <silent> <leader>aG :call RGVisualSelectVsplit()<CR>
fun! OpenAckFileVSplit()
  vsplit
  Rg <C-R><C-W>
  cclose
  wincmd l
endfu

"FIXME don't remember how to concat variable to command 
function! RGVisualSelect()
  let l:visual_select = s:get_visual_selection()
  echo l:visual_select
  " execute ":RG" . l:visual_select
endfunction

function! RGVisualSelectVsplit()
  let l:visual_select = s:get_visual_selection()
  vsplit
  Rg l:visual_select
  cclose
  wincmd l
endfunction
function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction
