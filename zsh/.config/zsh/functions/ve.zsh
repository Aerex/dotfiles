function ve (){
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
