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

function tdn(){
  TASK_NUMBER=$1

  if [[  -z TASK_NUMBER ]]; then
    echo "Missing task number"
    return 1
  fi

  task $TASK_NUMBER denote
}
# task entry.after:now-<TIME-FILTER> <LIST-TYPE>
function teb_help(){
  echo "usage: teb <time-fitler> [<list-type>]\n"
  echo "<time-filter> The amount of time to go back for tasks\n"
  echo "<list-type>  How the list should be returned. Default: \"ls\\n"
}
function teb(){
  TIME_FILTER=$1 
  LIST_TYPE=$2

  if [ -z $TIME_FILTER ]; then
    printf "Error: Missing time\n"
    teb_help
    return 1;
  elif [ -z $LIST_TYPE ]; then
    LIST_TYPE=ls
  fi
  task entry.after:now-"${TIME_FILTER}" "${LIST_TYPE}" 
}

function ttk(){
  TASK_NUMBER=$1

  if [[ -z $TASK_NUMBER ]]; then
      'Missing task number'
      return 1
  fi

  task modify $TASK_NUMBER -in +next

}
