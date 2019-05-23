function tw(){
  TASK=$1
  TIME=$2

  if [ -z $TASK ]; then
    echo 'Need a task'
    exit 1
  fi

  if [ -z $TIME ]; then
    echo 'Need a time'
    exit 1
  fi

  task modify $TASK wait:$TIME "$@"

}
