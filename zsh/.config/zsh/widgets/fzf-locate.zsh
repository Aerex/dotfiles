# ALT-I - Paste the selected entry from locate output into the command line
function fzf-locate {
  local selected
  if selected=$(locate / | fzf -q "$LBUFFER"); then
    LBUFFER=$selected
  fi
  zle redisplay

  zle     -N    fzf-locate-widget
  bindkey '\ei' fzf-locate-widget
}
