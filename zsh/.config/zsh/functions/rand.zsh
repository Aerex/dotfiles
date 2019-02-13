function rand(){
  NUM_OF_CHARS=$1
  COPY_TO_CLIP=$2 
  OS=$(uname -s)
  
  if [ -z $NUM_OF_CHARS ]; then
     NUM_OF_CHARS=10 
   fi

   RAND=$(base64 /dev/urandom | head -c $NUM_OF_CHARS)

  if [ ! -z $COPY_TO_CLIP ]; then
    if [ $OS == "Darwin" ]; then
      echo $RAND | pbcopy
    else
      echo $RAND | xsel -b -i
    fi
  else
    echo $RAND
  fi


}

