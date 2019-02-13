#
# ================ GENERAL  ==================== #
alias cls="clear"
# ================ GENERAL  ==================== #
alias uuid="python -c \"import uuid; print uuid.uuid4()\" | pbcopy"

# ================ PASS ==================== #
alias pgpl="pass git pull"
alias pgp="pass git push"

# ================ GIT ==================== #
alias gcz="git cz"
alias gco="git co"
alias grsu="git remote set-url"
alias g="git"
alias gtr="git ls-tree HEAD"
alias gh="git hist"
alias ga="git add"
alias gaa="git add -A"
alias gb="git b"
alias gl="git log"
alias gm="git merge"
alias gr="git rebase -i"
alias grmc="git rm --cached"
alias gta="git tag"
alias gtad="git tag -d"
alias gmm="git merge master"
alias grc="git rebase --continue"
alias gd="git diff"
alias gst="git st"
alias gnb="git nb"
alias gdB="git dB"
alias gdb="git db"
alias gs="git status"
alias gst="git stash"
alias gpl="git pl"
alias gpm="git pl origin master"
alias gk="gitk --all&"
alias gx="gitx --all"
alias go="gco"
alias gcm="git commit"
alias gam="git commit --amend"
alias gpu="git pu"
alias gp="gpu"
alias gpd="git push --delete"
alias gpuf="git pu -f"
alias gpus="git push --set-upstream" 
alias gpufm="export OVERRIDE_MASTER_PUSH=1; git push origin master -f"
alias gpuso="git push --set-upstream origin"
alias gcom="git co master"
alias gmv="git mv"
alias gconf="git config --global"
alias gpr="git pull-request"
alias gtag1="git tag -d v1.0.0; git push --delete origin v1.0.0; git tag v1.0.0; git push origin v1.0.0"


# ================ NPM ==================== #
alias ns="npm start"
alias nt="npm test"
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
alias tmcc="ssh aerex@aerex.me -t tmux attach -c chat"
alias tmd="tmux attach -t da"
alias tmi="tmux attach -t misc"
alias tmu="tmux attach -t music"
alias tmc="tmux attach -t chat"
alias tconf="nvim ~/.tmux.conf"

# ================ FASD ==================== #
alias jj='zz'
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection

# ================ BREW ==================== #
alias restart_khd="brew services restart khd"
alias restart_kwm="brew services retart kwm"

# ================ TASKWARRIOR ==================== #
# TaskWarrior
#
alias t="task" # for work
alias trm="task rm"
alias tm="task modify"
alias tn="task note"
alias tdn="task denote"
alias ta="task add"
alias td="task done"
alias to="taskopen"
alias ts="task sync"
alias tc="task context"
alias tls="task ls"
alias tlsn="task ls +next" 
alias tin="task in"
alias tcc="task context none"
alias tda="task context da"
alias tu="task undo"
alias tn="task note"
alias tun="task denote"


# ================ RANGER  ==================== #
alias r="ranger"
alias rs="sudo ranger"

# ================ MUSIC  ==================== #
alias hp="http-prompt"
alias music="ncmpcpp"
alias splay="mpc play"
alias mstart="mpc add http://aerex.me:8023/mpd.ogg; mpc play"
alias sstop="mpc stop"
alias mplay="mpc play"
alias yt="mpsyt"
alias news="newsboat"
alias mail="neomutt"
alias pdf="zathura"
alias rm="trash"
alias note="notes"

# ================ VIM  ==================== #
alias v="nvim"
# ================ VIM  ==================== #
# ================ ZSH  ==================== #
alias zae="nvim ~/.config/zsh/conf.d/aliases.zsh; source ~/.config/zsh/conf.d/aliases.zsh"
alias zase="nvim ~/.config/zsh/conf.d/aliases.sec.zsh; source ~/.config/zsh/conf.d/aliases.sec.zsh"
alias zaev="nvim ~/.config/zsh/conf.d/env.sec.zsh"
alias sz="source ~/.zshrc"
alias zs="sz"
alias zrc="nvim ~/.zshrc; source ~/.zshrc"
# ================ JIRA  ==================== #
# Note: Anything prefix with a `j` is a jira alias
alias j="jira"
alias jcr="jira create"
alias jc="jira c"
alias jcs="jira cs"
alias jqa="jira lqa"
alias jconf="nvim ~/.jira.d/config.yml"
alias jqu="jira list --query"
alias jdev="jira dev"
alias js="jira sm"
alias jep="jira EPIC"
alias jec="nvim ~/.jira.d/templates/create"
alias jcr="jira create"
alias jlog="jira list-backlog-me"
alias jloga="jira list-backlog"
# ================ JIRA  ==================== #


# Note: Anything prefix with a `b` is a build/jenkins/nestor alias
alias b="nestor"
alias bq="nestor queue"
alias bb="nestor dashboard"

# ================ KHAL  ==================== #
alias cals="vdirsyncer sync"
#alias ckd="v ~/.khdrc"
#setenv SWIFTENV_ROOT "$HOME/.swiftenv"
#setenv PATH "$SWIFTENV_ROOT/bin" $PATH
#status --is-interactive; and . (swiftenv init -|psub)
#status --is-interactive; and . (rbenv init -|psub)

alias wttr="curl wttr.in?0"

