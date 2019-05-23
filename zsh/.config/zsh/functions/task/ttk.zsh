function ttk(){
  TASK_NUMBER=$1

  if [[ -z $TASK_NUMBER ]]; then
      'Missing task number'
      return 1
  fi

  task modify $TASK_NUMBER -in +next

}
