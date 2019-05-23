function gup(){
  REMOTE_BRANCH=$1
  CURRENT_LOCAL_BRANCH=$(git rev-parse --abbrev-ref HEAD | sed "s/\n//" | tr -d ' ')

  if [ -z $REMOTE_BRANCH ]; then
    git push --set-upstream origin "${CURRENT_LOCAL_BRANCH}"
  else
    git push --set-upstream "$REMOTE_BRANCH" "$CURRENT_LOCAL_BRANCH"
  fi

}
