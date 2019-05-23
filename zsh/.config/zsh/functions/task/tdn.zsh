function tdn(){
  TASK_NUMBER=$1

  if [[  -z TASK_NUMBER ]]; then
    echo "Missing task number"
    return 1
  fi

  task $TASK_NUMBER denote

}
