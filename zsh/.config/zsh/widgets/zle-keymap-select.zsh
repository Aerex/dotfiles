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
      vim_mode="%{$fg[orange]%}[CMD]%{$reset_color%}"
      # Something you want to do...
    ;;
    $ZVM_MODE_INSERT)
      vim_mode="%{$fg[cyan]%}[INS]%{$reset_color%}"
      # Something you want to do...
    ;;
    $ZVM_MODE_VISUAL)
      vim_mode="%{$fg[blue]%}[VISUAL]%{$reset_color%}"
      # Something you want to do...
    ;;
    $ZVM_MODE_VISUAL_LINE)
      vim_mode="%{$fg[blue]%}[VISUAL_BLOCK]%{$reset_color%}"
      # Something you want to do...
    ;;
    $ZVM_MODE_REPLACE)
      vim_mode="%{$fg[magenta]%}[REPLACE]%{$reset_color%}"
      # Something you want to do...
    ;;
  esac
}

if [ -z $ZVM_NAME ]; then 
  zle -N zle-keymap-select
fi
