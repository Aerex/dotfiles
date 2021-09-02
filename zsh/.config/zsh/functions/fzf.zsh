# Opening Files {{{1
function conf(){
  CONFIG_DIRS=(~/.w3m/keymap, ~/.wuzz/config.toml, ~/.tmux.conf, ~/.config/nvim/init.vim, ~/.jira.d/config.yml,  ~/.skhdrc, ~/.kube/config,
  ~/.myclirc, ~/.qutebrowser/config.py, ~/.taskrc, ~/.config/bugwarrior/bugwarriorrc, ~/.config/vdirsyncer/config, ~/.config/tig/config,
  ~/tmux.powerline.conf, ~/.my.cnf, ~/.config/neomutt/muttrc, ~/.offlineimaprc, ~/.nixpkgs/darwin-configuration.nix, ~/.config/alacritty/alacritty.yml, ~/.zshrc, ~/.ssh/config, ~/.yabairc, ~/.config/notmuch/notmuch-config, ~/.config/wtf/config.yml)
  VERT_CONFIG_DIRS=$(echo $CONFIG_DIRS | awk -v RS=, '{ sub(" ", ""); print }')

  echo $VERT_CONFIG_DIRS | fzf --preview="highlight -O ansi -l --force {}" \
    --bind "enter:execute($EDITOR {})+abort"
}

# Open nvim config
ve (){
VIM_CONFIG_FILE=$1

if [ -z $VIM_CONFIG_FILE ]; then
  nvim $HOME/.config/nvim/init.vim
else
  case "${VIM_CONFIG_FILE}" in
    notes|note|no)
      nvim $HOME/.config/nvim/settings/notes.vim
      ;;
  esac
fi
}
# Open a file at specified linenumber in $EDITOR using rg and fzf
vg() {
  local file
  local line


  # Use ag if rg does not exist in system
  if [[ $(command -v $(which rg) 2>/dev/null) ]]; then
    read -r file line <<<"$(rg -n --no-heading --colors 'match:fg:black' --colors 'match:bg:yellow' --colors 'path:fg:green' $@ | fzf -0 -1 | awk -F: '{print $1, $2}')"
  elif [[  $(command -v $(which ag) 2>/dev/null) ]]; then
    read -r file line <<<"$(ag --nobreak --noheading $@ | fzf 1 -1 | awk -F: '{print $1, $2}')"
  else
    print 'Could not find either ag or rg'
    exit 1
  fi

  if [[ -n $file ]]; then
     ${EDITOR:-vim} $file +$line

  fi
}
# }}}

# Processes {{{1
# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi
}
#}}}
# Command History {{{1
# fh - repeat history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

fe() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}
#}}}

# Git {{{1
# fcop - checkout git branch/tag, with a preview showing the commits between the tag/branch and HEAD
fcop() {
  local tags branches target
  tags=$(
git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
git branch --all | grep -v HEAD |
sed "s/.* //" | sed "s#remotes/[^/]*/##" |
sort -u | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
(echo "$tags"; echo "$branches") |
    fzf --no-hscroll --no-multi --delimiter="\t" -n 2 \
    --ansi --preview="jira view {+2..}")
}

fdb(){
# TODO: Need to figure out how to strip out digitis using sed
# echo "feature/SA-13355-log-course-compleition" | sed -En "s/^feature\/\(SA-[0-9]+\).*$/\1/p"
local branches target_branches
  branches=$(git --no-pager branch)
  target_branches=$(echo "$branches" |
    fzf -m --no-hscroll \
    --bind "ctrl-m:toggle-in" \
    --header "ctrl-d=delete" \
    --ansi --preview="echo {} | cut -d : -f 1 | xargs -I % sh -c 'jira view %'")\
  echo $target_branches | xargs -I git branch -d {}
}


# fco - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
fco() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}
#}}}

# Docker {{{1
# Select a running docker container to stop
function ds() {
  local cid
  cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker stop "$cid"
}
# Select a docker container to start and attach to
function da() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker start "$cid" && docker attach "$cid"
}

# Select a docker container to stop and remove
function drmc() {
  docker ps -a | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{ print $1 }' | xargs -I % bash -c "docker stop %; docker rm %"
}
# Select a docker image or images to remove
function drmi() {
  docker images | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{ print $3 }' | xargs -r docker rmi
}
#}}}

# Vagrant {{{1
function vags(){
  #List all vagrant boxes available in the system including its status, and try to access the selected one via ssh
  cd $(cat ~/.vagrant.d/data/machine-index/index | jq '.machines[] | {name, vagrantfile_path, state}' | jq '.name + "," + .state  + "," + .vagrantfile_path'| sed 's/^"\(.*\)"$/\1/'| column -s, -t | sort -rk 2 | fzf | awk '{print $3}'); vagrant ssh
}
#}}}

# MPC {{{1
fmpc() {
  local song_position
  song_position=$(mpc -f "%position%) %artist% - %title%" playlist | \
    fzf-tmux --query="$1" --reverse --select-1 --exit-0 | \
    sed -n 's/^\([0-9]\+\)).*/\1/p') || return 1
  [ -n "$song_position" ] && mpc -q play $song_position
}
#}}}

# vim: nowrap foldmethod=marker foldlevel=2
