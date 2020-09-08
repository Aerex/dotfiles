# ================ GENERAL  ==================== #1
alias cls="clear"
alias cat="vimcat"
alias ls="exa"
alias wconf="nvim ~/.wuzz/config.toml"
alias rm='trash'
alias wttr="curl wttr.in?0"
alias speedtest="export PYTHONHTTPSVERIFY=0; speedtest-cli"
alias uuid="python -c \"import uuid; print uuid.uuid4()\" | pbcopy"
alias mail="neomutt"
alias n="nnn"
alias khdrc="nvim ~/.skhdrc"
alias alconf="nvim ~/.config/alacritty/alacritty.yml"

# ================ YABAI ==================== #1
alias ybm="yabai -m"

# ================ HOME NIX  ==================== #1
alias nixr="home-manager switch"
alias nixb="home-manager build"
alias nixs="nix search -u"

# ================ HUB  ==================== #1
alias hpr="hub pull-request -c" 

# ================ DOCKER ==================== #1
alias di="docker images"

# ================ ALACRITTY  ==================== #1
alias aconf="nvim ~/.config/alacritty/alacritty.yml"
#
# ================ BUGWARRIOR  ==================== #1
alias bpl="bugwarrior-pull"
# ================ PASS ==================== #1
alias pgpl="pass git pull"
alias pgp="pass git push"

# ================ GCAL ==================== #1
alias gcal="gcalcli" 
#alias gcalt="gcalcli agenda $(date +\"%m/%d\") $(date +\"%m/%d\" --date='tomorrow')"
alias gcalw="gcalcli calw"
alias gcalm="gcalcli calm"

# ================ GIT ==================== #1
alias g="git"
alias git-bug="$HOME/go/bin/git-bug"
### add ### #2
alias gaa="git add -A"
alias ga="git add"
### branches ### #2
alias gb="git b"
alias gnb="git checkout -b"
alias gdB="git branch -d"
alias gdb="git db"
alias grnb="git branch -m"
alias gRnb="git rename-branch"
### tags ### #2
alias gta="git tag"
alias gtd="git tag -d"
### logs ### #2
alias gl="git log"
alias grl="git reflog"
alias grlr="git reflog | fzf --preview=\"echo {}\" | awk '{print \$2}' | sed \"s/://\" | xargs -I % bash -c 'git reset %'"
### pull ### #2
alias gpl="git pull"
alias gpm="git pull origin master"
alias gcz="git cz"
alias gco="git checkout"
alias gcp="git cherry-pick"
alias gcpc="git cherry-pick --continue"
alias grsu="git remote set-url"
alias gtr="git ls-tree HEAD"
alias gh="git hist"
alias gm="git merge"
alias gr="git rebase -i"
alias grmc="git rm --cached"
alias gmm="git merge master"
alias gmd="git merge development"
alias grc="git rebase --continue"
alias gd="git diff"
alias gst="git stash"
alias gsm="git stash create --message"
alias gs="git status"
alias gk="gitk --all&"
alias gx="gitx --all"
alias gcm="git commit"
alias gam="git commit --amend"
alias gpu="git pu"
alias gp="gpu"
alias gpd="git push --delete"
alias gpuf="git pu -f"
alias gpus="git push --set-upstream" 
alias gpufm="export OVERRIDE_MASTER_PUSH=1; git push origin master -f"
alias gpum="export OVERRIDE_MASTER_PUSH=1; git push origin master"
alias gpuso="git push --set-upstream origin"
alias gcom="git checkout master"
alias gcod="git checkout development"
alias gmv="git mv"
alias gconf="git config --global"
alias gpr="git pull-request"

# ================ NPM ==================== #1
alias ns="npm start"
alias nsi="export PORT=3001; npm start"
alias nlkm="npm run link:models"
alias nv="npm version"
alias nt="npm test"
alias nup="npm update"
alias nlk="npm link"
alias nulk="npm unlink"
alias nlt="npm run lint"
alias nig="npm install -g"
alias ni="npm install"
alias nis="npm install --save"
alias nisd="npm install --save-dev"
alias nu="npm uninstall"
alias nug="npm uninstall -g"
alias nusd="npm uninstall --save-dev"
alias nus="npm uninstall --save"


# ================ TMUX ==================== #
# Note: Anythig prefix with `tm` is a tmux alias
# Edit tmux configuration
alias tma="tmux attach -t"
alias tmm="tmux attach -t main"
alias tmcc="ssh aerex@aerex.me -t tmux attach -c chat"
alias tmi="tmux attach -t misc"
alias tmu="tmux attach -t music"
alias tmc="tmux attach -t chat"
alias tconf="nvim ~/.tmux.conf"
alias mux="tmuxinator"

# ================ VIFM ==================== #
alias f='vifm .'
alias ff='sudo vifm .'


# ================ TASKWARRIOR ==================== #
alias t="task" # for work
alias trm="task rm"
alias tm="task modify"
alias tn="task annotate"
alias ta="task add"
alias td="task done"
alias to="taskopen"
alias ts="task sync"
alias tc="task context"
alias tls="task ls"
alias tlsn="task ls +next" 
alias tin="task in"
alias tcc="task context none"
alias tw="task context work"
alias tww="task context workall"
alias tu="task undo"
alias te="task edit"
alias tn="task note"
alias tst="task start"
alias tsp="task stop"
alias tun="task denote"

# ================ RANGER  ==================== #1
alias r="ranger"
alias rr="sudo ranger ."

# ================ MUSIC  ==================== #1
alias hp="http-prompt"
alias music="ncmpcpp"
alias splay="mpc play"
alias mstart="mpc add http://aerex.me:8023/mpd.ogg; mpc play"
alias sstop="mpc stop"
alias mplay="mpc play"
alias yt="mpsyt"
alias news="newsboat"
alias pdf="zathura"
#alias rm="trash"
alias note="notes"

# ================ VIM  ==================== #1
alias v="nvim"
alias vv="sudo nvim"
alias vconf="nvim ~/.config/nvim/init.vim"

# ================ ZSH  ==================== #1
alias zae="nvim ~/.config/zsh/conf.d/aliases.zsh; source ~/.config/zsh/conf.d/aliases.zsh"
alias zpconf="nvim ~/.zprofile; source ~/.zprofile"
alias zase="nvim ~/.config/zsh/conf.d/aliases.sec.zsh; source ~/.config/zsh/conf.d/aliases.sec.zsh"
alias zsev="nvim ~/.config/zsh/conf.d/env.sec.zsh"
alias sz="source ~/.zshrc"
alias zeconf="nvim ~/.zshenv; source ~/.zshenv"
alias history="cat ~/.zsh_history | less"
alias zs="sz"
alias zconf="nvim ~/.zshrc; source ~/.zshrc"
alias zrc="nvim ~/.zshrc; source ~/.zshrc"

# ================ JIRA  ==================== #1
# Note: Anything prefix with a `j` is a jira alias
alias j="jira"
alias jc="jira mine-todo"
alias jfc="jira fc"
alias jfcs="jira fcs"
alias jcs="jira cs"
alias jsp="jira sprint"
alias jspa="jira add-sprint"
alias jcr="jira create"
#alias jqa="jira mine-under-review"
alias jqam="jira mine-under-review"
#alias jqaa="jira lqaa"
alias jmd="jira list-merge-deploy"
alias jmdm="jira list-merge-deploy-me"
alias jconf="nvim ~/.jira.d/config.yml"
alias jqu="jira list --query"
alias jdev="jira dev"
alias js="jira sm"
alias jep="jira EPIC"
alias jec="nvim ~/.jira.d/templates/create"
alias jcr="jira create"
alias jfbl="jira fzf-list-backlog"
alias jlog="jira list-backlog-me"
alias jloga="jira list-backlog"

# ================ CHUNKWM  ==================== #1
alias chconf="nvim ~/.chunkwmrc; brew services restart chunkwm"
# Note: Anything prefix with a `b` is a build/jenkins/nestor alias

# ================ NESTOR  ==================== #1
alias b="nestor"
alias bq="nestor queue"
alias bb="nestor dashboard"

# ================ KHAL  ==================== #1
alias cals="vdirsyncer sync"
#status --is-interactive; and . (swiftenv init -|psub)
#status --is-interactive; and . (rbenv init -|psub)


# vim: nowrap fdm=marker fmr=#,#
