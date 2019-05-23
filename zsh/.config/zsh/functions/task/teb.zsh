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
