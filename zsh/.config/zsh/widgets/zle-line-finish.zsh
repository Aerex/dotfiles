# Credits to pjg
# https://github.com/pjg/dotfiles/blob/master/.zshrc#L603
function zle-line-finish {
  vim_mode=$vim_ins_mode
}

if [ -z $ZVM_NAME ]; then 
  zle -N zle-line-finish
fi
