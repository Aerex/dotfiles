
nmap <leader>gv :Gitv --all<CR>
nmap <leader>gV :Gitv! --all<CR>
vmap <leader>gV  :Gitv! --all<CR>

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
