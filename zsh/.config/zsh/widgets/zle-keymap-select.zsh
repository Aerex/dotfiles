# Credits tp pjg
# https://github.com/pjg/dotfiles/blob/master/.zshrc#L597
function zle-keymap-select {
  vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
  zle reset-prompt
}
zle -N zle-keymap-select
