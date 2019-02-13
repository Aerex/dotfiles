# 200ms wait (20 == 200ms) for a longer bound string (usually ESC + something; wait 200ms for 'something' and if it doesn't come, just execute normal <Esc>)
export KEYTIMEOUT=20

# VIM style keybindings by default
bindkey -v

case "$TERM" in
  *xterm*|screen-256color)
    # VI MODE KEYBINDINGS (ins mode)
    bindkey -M viins '^a'    beginning-of-line
    bindkey -M viins '^e'    end-of-line
    bindkey -M viins -s '^b' "←\n" # C-b move to previous directory (in history)
    bindkey -M viins -s '^f' "→\n" # C-f move to next directory (in history)
    bindkey -M viins '^k'    kill-line
    bindkey -M viins '^r'    history-incremental-pattern-search-backward
    bindkey -M viins '^s'    history-incremental-pattern-search-forward
    bindkey -M viins '^o'    history-beginning-search-backward
    bindkey -M viins '^p'    history-beginning-search-backward
    bindkey -M viins '^n'    history-beginning-search-forward
    bindkey -M viins '^y'    yank
    bindkey -M viins '^w'    backward-kill-word
    bindkey -M viins '^u'    backward-kill-line
    bindkey -M viins '^h'    backward-delete-char
    bindkey -M viins '^?'    backward-delete-char
    bindkey -M viins '^_'    undo
    bindkey -M viins '^x^l'  history-beginning-search-backward-then-append
    bindkey -M viins '^x^r'  redisplay
    bindkey -M viins '\eOH'  beginning-of-line # Home
    bindkey -M viins '\eOF'  end-of-line       # End
    bindkey -M viins '\e[2~' overwrite-mode    # Insert


    # VI MODE KEYBINDINGS (cmd mode)
    bindkey -M vicmd 'ca'    change-around
    bindkey -M vicmd 'ci'    change-in
    bindkey -M vicmd 'da'    delete-around
    bindkey -M vicmd 'di'    delete-in
    bindkey -M vicmd 'ga'    what-cursor-position
    bindkey -M vicmd 'gg'    beginning-of-history
    bindkey -M vicmd 'G '    end-of-history
    bindkey -M vicmd '0'    beginning-of-line
    bindkey -M vicmd '$'    end-of-line
    bindkey -M vicmd 'dd'    kill-line
    bindkey -M vicmd '^r'    history-incremental-pattern-search-backward
    bindkey -M vicmd '^s'    history-incremental-pattern-search-forward
    bindkey -M vicmd '^o'    history-beginning-search-backward
    bindkey -M vicmd '^p'    history-beginning-search-backward
    bindkey -M vicmd '^n'    history-beginning-search-forward
    bindkey -M vicmd '^y'    yank
    bindkey -M vicmd '^w'    backward-kill-word
    bindkey -M vicmd '^u'    backward-kill-line
    bindkey -M vicmd '/'     vi-history-search-forward
    bindkey -M vicmd '?'     vi-history-search-backward
    bindkey -M vicmd '^_'    undo
    bindkey -M vicmd '\ef'   forward-word                      # Alt-f
    bindkey -M vicmd '\eb'   backward-word                     # Alt-b
    bindkey -M vicmd '\ed'   kill-word                         # Alt-d
    bindkey -M vicmd '\e[5~' history-beginning-search-backward # PageUp
    bindkey -M vicmd '\e[6~' history-beginning-search-forward  # PageDown
  ;;
*)
  echo "Terminal is not supported; Currently support xterm and screen-256"
  ;;
esac
