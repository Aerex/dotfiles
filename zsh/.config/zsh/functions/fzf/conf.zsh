function conf(){
  CONFIG_NAMES=(wuzz, tmux, nvim, jira, chunkwm, khd, kube, mycli, qutebrowser, taskwarrior, bugwarrior)
  CONFIG_DIRS=(~/.wuzz/config.toml, ~/.tmux.conf, ~/.config/nvim/init.vim, ~/.jira.d/config.yml, ~/.chunkwmrc, ~/.skhdrc, ~/.kube/config,
  ~/.myclirc, ~/.qutebrowser/config.py, ~/.taskrc, ~/.config/bugwarrior/bugwarriorrc)

  CONFIG_NAMES=$(jq -r 'keys[]' conf.json)
  CONFIG_DIRS=$(jq -r  '.[]' conf.json)


  fzf --preview="echo vimcat $(jq '.{}')"
}
