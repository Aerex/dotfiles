#!/bin/zsh
# command name: httpj
function httpj(){
  # Create filename (replace `/` with `%` so mktemp does't break
  FILE_NAME=$(rand 40 | sed -E 's/\//%/g')
  TMPFILE=`mktemp /tmp/${FILE_NAME}.XXXXXX.json`
  nvim $TMPFILE
  http "$@" < $TMPFILE
  if [ -f $TMPFILE ];  then
    \rm $TMPFILE
  fi
}
