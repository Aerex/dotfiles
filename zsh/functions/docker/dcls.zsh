function dcls(){


  CONTAINERS=$(docker ps -a | awk '{ print $1 }' | tail -n +2)
  if [ -z $CONTAINERS ]; then
    printf "No Docker containers to delete\n"
  else
    printf "\nDeleting all docker containers...\n"
    echo $CONTAINERS | xargs -I%  docker stop %
    echo $CONTAINERS | xargs -I%  docker rm -f %
    docker ps -a
  fi

  IMAGES=$(docker images | awk '{ print $3 }' | tail -n +2)
  if [ -z $IMAGES ]; then
    printf "No Docker images to delete"
  else 
    printf "\nDeleting all docker images...\n" 
    echo $IMAGES | xargs -I% docker rmi % -f
    docker images
  fi
}
