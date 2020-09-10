nmap <silent> <leader>ag :call RGVisualSelect()<CR>
nmap <silent> <leader>aG :call RGVisualSelectVsplit()<CR>

function! RGVisualSelect()
  let l:visual_select = s:get_visual_selection()
  Ag l:visual_select
endfunction

function! RGVisualSelectVsplit()
  let l:visual_select = s:get_visual_selection()
  vsplit
  Ag l:visual_select
  cclose
  wincmd l
endfunction
