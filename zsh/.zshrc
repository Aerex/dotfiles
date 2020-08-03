# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$HOME/go/bin:$PATH

export ZLE_REMOVE_SUFFIX_CHARS=""
export XDG_CONFIG_PATH=$HOME/.config

. $HOME/z.sh

OS=$(uname -s)
if [ "$OS" = "Darwin" ]; then 
  PYTHON_ROOT_37=/Library/Frameworks/Python.framework/Versions/3.7
  PYTHON_PATH_27=$HOME/Library/Python/2.7
  PYTHON_PATH_37=$HOME/Library/Python/3.7
  export GOROOT=/usr/local/Cellar/go/1.10.3/libexec
  export RTV_BROWSER=$(which qutebrowser)
fi

export PATH=$PATH:/usr/local/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:/usr/local/sbin 
# Python
export PATH=$PATH:$PYTHON_PATH_27/bin 
export PATH=$PYTHON_PATH_37/bin:$PATH
export PATH=$PATH:$PYTHON_ROOT_37/bin 

# Go
export GOPATH=$HOME/go
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin 
export PATH=$PATH:$GOROOT/bin

export PYTHONWARNINGS="ignore:Unverified HTTPS request"

# Powerline
export POWERLINE_NO_ZSH_PROMPT=1 
. /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/powerline/bindings/zsh/powerline.zsh

# Misc
export EDITOR=$HOME/.nix-profile/bin/nvim
export NOTES_DIRECTORY=~/Documents/notes
export PAGER=less
export BROWSER=qutebrowser
export RTV_EDITOR=$(which nvim)

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?

# Load User functions
if [ -d $HOME/.config/zsh/functions ]; then
  for file in $HOME/.config/zsh/functions/**/*.zsh; do
      source $file
  done
fi


# Load ZLE Widgets and Functions
if [ -d $HOME/.config/zsh/widgets ]; then
  for file in $HOME/.config/zsh/widgets/*.zsh; do
    source $file
  done
fi

  # Zsh's history-beginning-search-backward is very close to Vim's C-x C-l
  history-beginning-search-backward-then-append() {
    zle history-beginning-search-backward
    zle vi-add-eol
  }
  zle -N history-beginning-search-backward-then-append

  # Load zgen only if a user type a zgen command
  zgen() {
    if [[ ! -s ${ZDOTDIR:-${HOME}}/.zgen/zgen.zsh ]]; then
      git clone --recursive https://github.com/tarjoilija/zgen.git ${ZDOTDIR:-${HOME}}/.zgen
    fi
    source ${ZDOTDIR:-${HOME}}/.zgen/zgen.zsh
    zgen "$@"
  }
  if [[ ! -s ${ZDOTDIR:-${HOME}}/.zgen/init.zsh ]]; then
    zgen save
  fi


# [zsh-git-prompt] location
export __GIT_PROMPT_DIR=~/.zsh/bundles/olivierverdier/zsh-git-prompt

# use Haskell's version of zsh-git-prompt (if available)
if [[ -f $__GIT_PROMPT_DIR/src/.bin/gitstatus ]]; then GIT_PROMPT_EXECUTABLE="haskell"; fi

zgen load zsh-users/zsh-autosuggestions
zgen load olivierverdier/zsh-git-prompt
zgen oh-my-zsh plugins/ssh-agent
zgen oh-my-zsh plugins/shrink-path
zgen load zsh-users/zsh-completions
zgen load pjg/zsh-vim-plugin
zgen load taskwarrior
zgen load tmux
zgen load $HOME/.config/zsh/themes/theunraveler-mod.zsh-theme
zgen load $HOME/.config/zsh/plugins/vim-mode-redux
#antigen bundle olivierverdier/zsh-git-prompt
##antigen bundle zsh-users/zsh-completions
##antigen bundle pjg/zsh-vim-plugin
## antigen bundle lukechilds/zsh-better-npm-completion
## antigen bundle brew
#antigen bundle $HOME/.config/zsh/themes theunraveler-mod.zsh-theme  --no-local-clone
#antigen bundle $HOME/.config/zsh/plugins/vim-mode-redux vim-mode-redux.zsh --no-local-clone
#antigen apply

#ZSH_THEME="theunraveler-mod"
#ZSH_THEME="theunraveler"



# Options
# zsh will not beep
setopt no_beep
# make cd push the old directory onto the directory stack
setopt auto_pushd
# Report the status of background jobs immediately, rather than waiting until just before printing a prompt.
setopt notify
# Turn off terminal driver flow control (CTRL+S/CTRL+Q)
setopt noflowcontrol
stty -ixon -ixoff
# Do not kill background processes when closing the shell.
setopt nohup

# History
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=${HISTSIZE}


# LOCALE

# ensure we have correct locale set (this is mostly for MacOS)
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

ZSH_CUSTOM=$HOME/.config/zsh

# User configuration
if [ -d $ZSH_CUSTOM/conf.d ]; then
  for file in $ZSH_CUSTOM/conf.d/*.zsh; do
    source $file
  done
fi
# export MANPATH="/usr/local/man:$MANPATH"
#
#
export FZF_DEFAULT_OPTS="--bind \"K:preview-up,J:preview-down,ctrl-g:jump\""

# make backward-word and forward-word move to each word separated by a '/'
export WORDCHARS=''

# limit correction only to commands
setopt correct

# When offering typo corrections, do not propose anything which starts with an underscore (such as many of Zsh's shell functions)
CORRECT_IGNORE='_*'


# general exceptions
#for i in {'cp','git','gist','man','mv','mysql','mkdir'}; do
#  alias $i="nocorrect $i"
#done
#
#source ~/.bin/tmuxinator.zsh


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

if [ -e /Users/noamfo/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/noamfo/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
