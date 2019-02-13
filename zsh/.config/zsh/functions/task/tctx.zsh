# task context define <NAME> <FILTER>
function tctx(){
  NAME=$1 
  FILTER=$2

  if [ -z $NAME ]; then
    echo "Missing a name for context"
    return 1;
  elif [ -z $FILTER ]; then
    echo "Missing filter"
    return 1;
  fi
  task context define $NAME $FILTER 
}
