":com -nargs=* So call SourceFileSetting(<f-args>) 
"fun SourceFileSetting(map)
"  if(
"  :execute "map  <leader>" . a:map . " :CtrlP " a:dir ."<CR>"
"endfun
