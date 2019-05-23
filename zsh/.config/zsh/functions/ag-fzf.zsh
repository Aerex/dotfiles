function ag-fzf(){

  HAS_AG=$(command -v ag) 
  if [ -z $HAS_AG ]; then
    echo 'ag is not found in your system'
    return 1;
  fi

  HAS_FZF=$(command -v fzf)
  if [ -z $HAS_FZF ]; then
    echo 'fzf not found in your system'
    return 1
  fi


  CMD_PARMS=$(ag "$@" | fzf --preview="echo {}")
  RESULT_FILE=$(awk -F':' '{print $1}')
  RESULT_LINE_NUM=$(awk -F':' '{print $2}')
  if [ -z $RESULT_FILE ]; then
    return 0
  fi

  nvim "$RESULT_FILE" +"$RESULT_LINE_NUM"
}
