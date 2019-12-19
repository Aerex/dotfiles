function conf(){
  CONFIG_DIRS=(~/.wuzz/config.toml, ~/.tmux.conf, ~/.config/nvim/init.vim, ~/.jira.d/config.yml, ~/.chunkwmrc, ~/.skhdrc, ~/.kube/config,
  ~/.myclirc, ~/.qutebrowser/config.py, ~/.taskrc, ~/.config/bugwarrior/bugwarriorrc, ~/.config/vdirsyncer/config, ~/.config/tig/config, 
  ~/tmux.powerline.conf, ~/.my.cnf, ~/.config/neomutt/muttrc, ~/.offlineimaprc)
  VERT_CONFIG_DIRS=$(echo $CONFIG_DIRS | awk -v RS=, '{ sub(" ", ""); print }')

  echo $VERT_CONFIG_DIRS | fzf --preview="highlight -O ansi -l --force {}" \
    --bind "enter:execute($EDITOR {})+abort"
}
