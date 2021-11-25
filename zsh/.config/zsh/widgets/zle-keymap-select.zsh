# Credits tp pjg
# https://github.com/pjg/dotfiles/blob/master/.zshrc#L597
function zle-keymap-select {
  vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
  zle reset-prompt
}

# The plugin will auto execute this zvm_after_select_vi_mode function
function zvm_after_select_vi_mode() {
  case $ZVM_MODE in
    $ZVM_MODE_NORMAL)
      vim_mode="%B%F{#ec5f67}[CMD]%{$reset_color%}%b"
      # Something you want to do...
    ;;
    $ZVM_MODE_INSERT)
      vim_mode="%B%F{#afd700}[INS]%{$reset_color%}%b"
      # Something you want to do...
    ;;
    $ZVM_MODE_VISUAL)
      vim_mode="%B%F{#51afef}[VISUAL]%{$reset_color%}%b"
      # Something you want to do...
    ;;
    $ZVM_MODE_VISUAL_LINE)
      vim_mode="%B%F{#51afef}[VISUAL_BLOCK]%{$reset_color%}%b"
      # Something you want to do...
    ;;
    $ZVM_MODE_REPLACE)
      vim_mode="%B%F{#c678dd}[REPLACE]%{$reset_color%}%b"
      # Something you want to do...
    ;;
  esac
}

if [ -z $ZVM_NAME ]; then 
  zle -N zle-keymap-select
fi
