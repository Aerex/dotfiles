# Credits to pjg
# https://github.com/pjg/dotfiles/blob/master/.zshrc#L415
# Delete all characters between a pair of characters and then go to insert mode
# Mimics vim's "ci" text object functionality.
function change-in {
  zle delete-in
  zle vi-insert
}
if [ -z $ZVM_NAME ]; then
  zle -N change-in
fi
