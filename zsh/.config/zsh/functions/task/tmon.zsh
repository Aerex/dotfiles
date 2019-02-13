# task entry.after:now-<TIME-FILTER> <LIST-TYPE>
function tmon_help(){
  echo "usage: tmon <TASK-ID>"
  echo "<TASK-ID> The task id\n"
}
function tmon(){
  TASK_ID=$1 

  if [ -z $TASK_ID ]; then
    printf "Error: Missing TASK_ID\n"
    tmon_help
    return 1;
  fi
  task modify $TASK_ID -in +next 
}
