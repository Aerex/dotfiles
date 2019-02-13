#!/bin/zsh
# command name: httpj
function httpj(){
  FILE_NAME=$(rand 40)
  TMPFILE=$(mktemp /tmp/$FILE_NAME.json)
  nvim $TMPFILE
  http "$@" < $TMPFILE
  rm $TMPFILE
}
