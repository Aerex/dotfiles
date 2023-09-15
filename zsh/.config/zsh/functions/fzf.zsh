function conf(){
  if [[ ! -z $(command -v tmsu) ]]; then 
    tmsu files --path=$HOME conf | fzf --preview="highlight -O ansi -l --force {}" \
      --bind "enter:execute($EDITOR {})+abort"
  else
    CONFIG_DIRS=(~/.wuzz/config.toml, ~/.tmux.conf, ~/.config/nvim/init.vim, ~/.jira.d/config.yml, ~/.chunkwmrc, ~/.skhdrc, ~/.kube/config,
      ~/.myclirc, ~/.qutebrowser/config.py, ~/.taskrc, ~/.config/bugwarrior/bugwarriorrc, ~/.config/vdirsyncer/config, ~/.config/tig/config, 
      ~/tmux.powerline.conf, ~/.my.cnf, ~/.config/neomutt/muttrc, ~/.offlineimaprc, ~/.config/i3/config, ~/.Xresources)
      VERT_CONFIG_DIRS=$(echo $CONFIG_DIRS | awk -v RS=, '{ sub(" ", ""); print }')

      echo $VERT_CONFIG_DIRS | fzf --preview="highlight -O ansi -l --force {}" \
        --bind "enter:execute($EDITOR {})+abort"
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
# fh - repeat history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

fe() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# fd - cd to selected directory (use only if fd is not installed)
if [ ! -f $HOME/.cargo/bin/fd ]; then
  fd() {
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune \
                    -o -type d -print 2> /dev/null | fzf +m) &&
    cd "$dir"
  }
fi

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
local branches target_branches
  branches=$(git --no-pager branch) 
  target_branches=$(echo "$branches" |
    fzf -m --no-hscroll \
    --bind "ctrl-m:toggle-in" \
    --ansi --preview="echo {} | cut -d : -f 1 | xargs -I % sh -c 'jira view %'")\
  echo $target_branches
}

_get_branches() { 
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)")
  echo $branches
}
  

# fco - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
fco() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fdb - delete branch 
fdb() {
  local branch
  branches="$(_get_branches)"
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git branch -d $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fdeskl - Manage desktop files
function _edit_desktop_file() { 
  if [[ ! -z $(command -v desktop-file-edit) ]]; then
    desktop-file-edit $1
  else
    $EDITOR $1
  fi
}
fdeskl() { 
  local desktop_files
  desktop_files=$(find /usr/share/applications -name "*.desktop" 2>/dev/null \
    && find /usr/local/share/applications -name "*.desktop" 2>/dev/null \
    && find "$HOME/.local/share/applications" -name "*.desktop" 2>/dev/null \
    && find /var/lib/flatpak/exports/share/applications -name "*.desktop" 2>/dev/null \
    && find "$HOME/.local/share/flatpak/exports/share/applications" -name "*.desktop" 2>/dev/null \
    && find "$HOME/.applications" -name "*.desktop" 2>/dev/null) 
  echo $desktop_files | fzf --prompt="Desktop Files> "\
      --preview="highlight -O ansi -l --force {}" \
      --header="enter=Open desktop file ctrl-space=Print file path" \
      --bind="enter:execute($EDITOR {})+abort"\
      --bind="ctrl-space:execute(echo {})+abort"
}
# Helper function to integrate pikaur and fzf
pifz() {
  pos=$1
  if [[ ! -f ~/.pifz_history$pos ]]; then
    touch ~/.pifz_history$pos
  fi
  shift
  sed "s/ /\t/g" |
    fzf --nth=$pos --multi --history="/home/aerex/.pifz_history$pos" \
      --ansi \
      --preview-window=60%,border-left \
      --bind="double-click:execute(xdg-open 'https://archlinux.org/packages/{$pos}'),alt-enter:execute(xdg-open 'https://aur.archlinux.org/packages?K={$pos}&SB=p&SO=d&PP=100')" \
       "$@" | cut -f$pos | xargs
}

# Dev note: print -s adds a shell history entry

# List installable packages into fzf and install selection
pacf() {
  cache_dir="/tmp/pikaur-$USER"
  test "$1" = "-y" && rm -rf "$cache_dir" && shift
  mkdir -p "$cache_dir"
  preview_cache="$cache_dir/preview_{2}"
  list_cache="$cache_dir/list"
  { test "$(cat "$list_cache$@" | wc -l)" -lt 50000 && rm "$list_cache$@"; } 2>/dev/null
  pkg=$( (cat "$list_cache$@" 2>/dev/null || { pacman --color=always -Sl "$@"} | sed 's/ [^ ]*unknown-version[^ ]*//' | tee "$list_cache$@") |
    pifz 2 --tiebreak=index --preview="cat $preview_cache 2>/dev/null | grep -v 'Querying' | grep . || pikaur --color always -Si {2} | tee $preview_cache")
  if test -n "$pkg"
    then echo "Installing $pkg..."
      cmd="pikaur -S $pkg"
      print -s "$cmd"
      eval "$cmd"
      rehash
  fi
}
# List installed packages into fzf and remove selection
# Tip: use -e to list only explicitly installed packages
pacfr() {
  pkg=$(pikaur --color=always -Q "$@" | pifz 1 --tiebreak=length --preview="pikaur --color always -Qli {1}")
  if test -n "$pkg"
    then echo "Removing $pkg..."
      cmd="pikaur -R --cascade --recursive $pkg"
      print -s "$cmd"
      eval "$cmd"
  fi
}

alias pacfu="pacfr"
