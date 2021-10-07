# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.bin:/usr/local/bin:$HOME/go/bin:$PATH

export ZLE_REMOVE_SUFFIX_CHARS=""


OS=$(uname -s)
if [ "$OS" = "Darwin" ]; then
  PYTHON_ROOT_37=/Library/Frameworks/Python.framework/Versions/3.7
  PYTHON_PATH_27=$HOME/Library/Python/2.7
  PYTHON_PATH_37=$HOME/Library/Python/3.7
  export GOROOT=/usr/local/Cellar/go/1.10.3/libexec
fi

# FZF
export FZF_DEFAULT_OPTS="--bind ctrl-g:jump --bind alt-j:preview-down --bind alt-k:preview-up"

export PATH=$PATH:/usr/local/sbin
[ -d $HOME/.local/bin ] && export PATH=$PATH:$HOME/.local/bin
[ -d $HOME/.gem/ruby/2.6.0/bin ] && export PATH=$PATH:$HOME/.gem/ruby/2.6.0/bin

# Go
export GOROOT=/usr/lib/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Android
export PATH=$PATH:/opt/android-sdk/tools/bin

# Powerline
if [ "$OS" = "Darwin" ]; then
  export POWERLINE_NO_ZSH_PROMPT=1
  . /Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/powerline/bindings/zsh/powerline.zsh
fi

# Misc
if [ -f ~/neovim/bin/nvim ]; then
  export EDITOR=~/neovim/bin/nvim
elif [ -f /usr/bin/nvim ]; then
  export EDITOR=/usr/bin/nvim
else
  export EDITOR=/usr/local/bin/nvim
fi

[[ $TMUX = "" ]] && export TERM="xterm-256color"
export NOTES_DIRECTORY=~/Documents/notes
export EDITOR=~/neovim/bin/nvim
#export EDITOR=/bin/nvim
export NOTES_EXT=""
export PAGER=vimpager
export BROWSER=$(which qutebrowser)


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
DISABLE_AUTO_UPDATE="true"

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


# Credits to https://github.com/Tuurlijk/dotfiles/blob/master/.zshrc
# Load zgen only if a user types a zgen command
zgen () {
	if [[ ! -s ${ZDOTDIR:-${HOME}}/.zgen/zgen.zsh ]]; then
		git clone --recursive https://github.com/tarjoilija/zgen.git ${ZDOTDIR:-${HOME}}/.zgen
	fi
	source ${ZDOTDIR:-${HOME}}/.zgen/zgen.zsh
	zgen "$@"
}

# Generate zgen init script if needed
# Credits to https://github.com/Tuurlijk/dotfiles/blob/master/.zshrc
if [[ ! -s ${ZDOTDIR:-${HOME}}/.zgen/init.zsh ]]; then
	zgen save
fi

# Load the oh-my-zsh's library.
# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#ANTIGEN_LOG=$HOME/.antigen/antigen.log
# Load Antigen ZSH Plugin Manager
#ANTIGEN_PATH=~/dotfiles
#source $ANTIGEN_PATH/antigen.zsh

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
[ "$OS" = "Darwin" ] && zgen load brew
zgen load tmux
zgen load $HOME/.config/zsh/themes/theunraveler-mod.zsh-theme
zgen load $HOME/.config/zsh/plugins/vim-mode-redux
zgen save
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
export HISTSIZE=30000
export SAVEHIST=${HISTSIZE}


# LOCALE

# ensure we have correct locale set (this is mostly for MacOS)
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

ZSH_CUSTOM=$HOME/.config/zsh

# User configuration
if [ -d $ZSH_CUSTOM/conf.d ]; then
  for file in $ZSH_CUSTOM/conf.d/**.zsh; do
    source $file
  done
fi

if [ -d $ZSH_CUSTOM/functions ]; then
  for file in $ZSH_CUSTOM/functions/*.zsh; do
    source $file
  done
fi
# export MANPATH="/usr/local/man:$MANPATH"
#

# make backward-word and forward-word move to each word separated by a '/'
export WORDCHARS=''

# limit correction only to commands
setopt correct

# When offering typo corrections, do not propose anything which starts with an underscore (such as many of Zsh's shell functions)
CORRECT_IGNORE='_*'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export ANDROID_HOME=/opt/android-sdk

export JA_GTC_SOURCE='ja' # your preferred source language code
export JA_GTC_TARGET='en' # your preferred target language code
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
source ~/tmuxinator.zsh

export PYENV_ROOT="$HOME/.pyenv"
export PATH=$PATH:/$PYENV_ROOT
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
if command -v zoxide 1>/dev/null 2>&1; then 
   eval "$(zoxide init zsh)" 
fi

