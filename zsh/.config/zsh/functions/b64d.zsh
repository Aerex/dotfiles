function b64d(){
  ENCODED_STRING=$1

  if [ -z $ENCODED_STRING ]; then
    echo "Missing encoded base 64 string"
    return 1
  fi

  echo $ENCODED_STRING | base64 --decode

}
