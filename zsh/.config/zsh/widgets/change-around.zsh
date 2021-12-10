# Credits to pjg
# https://github.com/pjg/dotfiles/blob/master/.zshrc#L429
# Delete all characters between a pair of characters as well as the surrounding
# characters themselves and then go into insert mode. Mimics vim's "ca" text object functionality.
function change-around {
  zle delete-in
  zle vi-backward-char
  zle vi-delete-char
  zle vi-delete-char
  zle vi-insert
}

if [ -z $ZVM_NAME ]; then 
  zle -N change-around
fi
