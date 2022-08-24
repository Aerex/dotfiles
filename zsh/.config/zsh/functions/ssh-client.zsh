SSH_CLIENT_IP=$(echo $SSH_CLIENT | awk '{print $1}')
SSH_CLIENT_PROMPT="%{$fg[green]%}[$SSH_CLIENT_IP]%{$reset_color%}"
function ssh-client(){
 if [ ! -z $SSH_CLIENT_IP ]; then
    echo $SSH_CLIENT_PROMPT 
  else
    echo ""
  fi
}
