#!/bin/bash

TMP_MUTT_ATTACH_DIR=/tmp/mutt_attachment
FILE_PATH=$1
FILE_NAME=$(basename $FILE_PATH)
OPEN_WITH_PROG=$2
CONTENT_TYPE=$3

# Create tmp attachment directory if it doesn't exist
if [ ! -d /tmp/mutt_attachment ]; then
  mkdir /tmp/mutt_attachment
fi

case $CONTENT_TYPE in
  text/html )
    FILE_TYPE='html'
    ;;
  *)
    FILE_TYPE='txt'
    ;;
esac


# Copy file so we don't lose it once neomutt deletes the original copy
cp "$FILE_PATH" "$TMP_MUTT_ATTACH_DIR/$FILE_NAME.$FILE_TYPE"


# Default to use xdg-open
OS=$(uname -s)
if [[ $OS == 'Linux' ]] && [[ -z $OPEN_WITH_PROG ]]; then
  xdg-open "$TMP_MUTT_ATTACH_DIR/$FILE_NAME.$FILE_TYPE"
elif [[ $OS == 'Linux' ]]; then
  $OPEN_WITH_PROG "$TMP_MUTT_ATTACH_DIR/$FILE_NAME.$FILE_TYPE"
else
  open -a $OPEN_WITH_PROG "$TMP_MUTT_ATTACH_DIR/$FILE_NAME.$FILE_TYPE"
  PROG=$(basename $OPEN_WITH_PROG)
  echo "Opening with \"$PROG\""
fi
