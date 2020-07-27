function kubel() {
  ENV=$1
  SERVICE=$2
  FLAG=$3
  
  if [ -z $ENV ]; then
    echo "Missing env"
    return 1
  fi

  if [[ $ENV != 'stage' ]] && [[ $ENV != 'test' ]] && [[ $ENV != 'prod' ]]; then
    echo "$ENV is not a valid env"
    return 1
  fi

  PODS=$(kubectl get pods --namespace ${ENV})
    
  if [ -z $SERVICE ]; then
    echo "Missing service name"
    return 1
  fi

  case $SERVICE in 
    hs)
      POD_NAME=$(echo $PODS | tail -n +2 | grep $SERVICE | head -n +1 | awk '{if($3 == "Running")print $1}')
      ;;
    *) 
        echo 'Coud not find matching service name'
        return 1 
        ;;
  esac

  kubectl logs $POD_NAME --namespace ${ENV} $3

}
