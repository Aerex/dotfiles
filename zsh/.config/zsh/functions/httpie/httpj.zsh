#!/bin/zsh
# command name: httpj
function httpj(){
  if [ ! -d /tmp/httpie ]; then
    mkdir /tmp/httpie
  fi

  FILE_NAME=$(rand 40 | sed 's/\//%/')
  TMPFILE=`mktemp /tmp/httpie/${FILE_NAME}.XXXXXX.json`
  nvim $TMPFILE
  http "$@" < $TMPFILE
  if [ -f $TMPFILE ];  then
    \rm $TMPFILE
  fi
}
