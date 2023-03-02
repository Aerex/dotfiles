zmodload zsh/zprof
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
#DISABLE_AUTO_UPDATE="true"

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

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
  print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh" 
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust

zinit light woefe/zsh-git-prompt
zinit snippet OMZP::ssh-agent
zinit snippet OMZP::shrink-path

zinit light jeffreytse/zsh-vi-mode
zinit ice lucide wait "2"
zinit light ytet5uy4/fzf-widgets
zinit light crater2150/tmsu-fzf
bindkey '^t' tmsu-fzf-change-directory
bindkey '^[t' tmsu-fzf-insert-file
bindkey '^O' tmsu-fzf-edit-file

zinit ice wait:2 lucid extract"" from"gh-r" as"command" mv"taskwarrior-tui* -> tt"
zinit load kdheepak/taskwarrior-tui
export FZSHELL_BIND_KEY='^b'
zinit ice lucide wait "2" atclone"./scripts/install.sh --no-instructions"
zinit load mnowotnik/fzshell 

ZSH_THEME="vi"
zinit snippet ~/.config/zsh/themes/vi.theme 
zinit ice if'[[ "$OS" == "Darwin" ]]'; zinit snippet OMZP::brew

zinit wait lucid for \
 silent atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zpcdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
 as"completion" \
    marlonrichert/zsh-autocomplete
zinit light Aloxaf/fzf-tab

export ZSH_CONFIG_HOME=$HOME/.config/zsh

# Load ZLE Widgts, Functions, and Configurations
if [ -d $ZSH_CONFIG_HOME ]; then
  for file in $ZSH_CONFIG_HOME/**/*.zsh; do
      source $file
  done
fi

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
# limit correction only to commands
setopt correct

function init_nvm() {
  zinit ice depth=1 wait lucid
  zinit light lukechilds/zsh-nvm  # This load nvm on first use of node, npm, etc
}

NVM_LOADED=$(zinit loaded | grep nvm)
function nvm() {
  if [[ -z $NVM_LOADED ]]; then
    zinit light lukechilds/zsh-nvm  # This load nvm on first use of node, npm, etc
  fi

  \nvm
}

if command -v zoxide 1>/dev/null 2>&1; then 
   eval "$(zoxide init zsh)" 
fi

# Source any local files if available
[[ -f ~/.override-bins ]] && source ~/.override-bins
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local 
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local 
