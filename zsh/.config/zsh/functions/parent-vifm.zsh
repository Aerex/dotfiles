VIFM_PROMPT="%{$fg[green]%}[VIFM]%{$reset_color%}"
function parent-vifm(){
  if [[ $(ps -ocommand= $(ps -oppid= -p $$)) == *vifm* ]]; then
    echo $VIFM_PROMPT
  else
    echo ""
  fi
}
