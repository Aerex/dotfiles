#!/bin/bash

action=$1
value=$2

function usage()
{
    echo "usage: commit"
    exit 1
}

os=$(uname -s)
if [ "$os" = "Darwin" ]; then 
  copy_command=pbcopy
else
  copy_command=xclip -b
fi

[ "$#" -lt 1 ] && usage



case $action in
  commit)
    echo -n $value | $copy_command  
    ;;
  *)
    usage
  ;;
esac
