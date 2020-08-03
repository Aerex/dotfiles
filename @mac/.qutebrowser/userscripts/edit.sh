#!/bin/bash 
# Open up a new iterm window with nvim in it, and quit after the editing is done
FILE=$1
FILE_NAME=$(basename $FILE)
TMP_QUTE_DIR=/tmp/qutebrowser_edits

if [ ! -d TMP_QUTE_DIR ]; then
  mkdir $TMP_QUTE_DIR 
fi

cp $FILE $TMP_QUTE_DIR/$FILE_NAME

alacritty -e $EDITOR "$TMP_QUTE_DIR/$FILE_NAME"

#ARGS=$@
#echo $ARGS
#nw='tell application "Alacritty"
#set newWindow to (create window with default profile)
#tell current session of newWindow
#write text "nvim '${ARGS}' > /dev/tty; exit 0"
#end tell
#end tell'
#
#osascript -e "$nw" &


#PID_INFO=$(ps aux | grep "nvim ${ARGS}" | awk '{print $2}')
#echo ${ARGS}
#echo $PID_INFO
#PID=$(echo $PID_INFO | awk '{print $2}')
#echo $PID
#echo '\n'
#while ps -p ${PID} > /dev/null 
#do
#	sleep 0.5
#done
#exit 0
