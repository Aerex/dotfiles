VIFM_PROMPT="%{$fg[purple]%}[VIFM]%{$reset_color%}"
function parent-vifim(){
  if [[ $(ps -ocommand= $(ps -oppid= -p $$)) = "vifm" ]]; then
    echo $VIFM_PROMPT 
  else
    echo ""
  fi
}

