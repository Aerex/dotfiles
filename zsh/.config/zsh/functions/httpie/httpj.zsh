#!/bin/zsh
# command name: httpj
function httpj(){
  FILE_NAME=$(rand 40)
  TMPFILE=$(mktemp /tmp/$FILE_NAME.json)
  NOT_EMPTY=$(cat TMPFILE | wc -c)
  if [ $NOT_EMPTY = 0 ]; then
    echo "content empty. exiting..." 
    exit 0
  fi
  nvim $TMPFILE
  http "$@" < $TMPFILE
  rm $TMPFILE
}
