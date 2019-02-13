RANGER_PROMPT="%{$fg[green]%}[R]%{$reset_color%}"
function parent-ranger(){
 if [ ! -z $RANGER_LEVEL ]; then
    echo $RANGER_PROMPT 
  else
    echo ""
  fi
}

