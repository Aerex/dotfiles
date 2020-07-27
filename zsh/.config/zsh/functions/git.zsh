#RED='\033[00;31m'
#RESTORE='\033[0m'
#function gco(){
#  IS_REPO=$(git rev-parse --is-inside-work-tree 2> /dev/null)
#
#   if [ $IS_REPO != "true" ]; then
#      echo "$RED" "Not a git repository" "$RESTORE"
#      return 1
#   fi
#
#    git branch | fzf-tmux +m --ansi | tr -d ' ' | read target_branch 
#    target_branch=$(echo $target_branch | sed s/*//g  | tr -d ' ' 1> /dev/null)
#
#    git checkout "$target_branch" 
#  }
#
function gup(){
  REMOTE_BRANCH=$1
  CURRENT_LOCAL_BRANCH=$(git rev-parse --abbrev-ref HEAD | sed "s/\n//" | tr -d ' ')

  if [ -z $REMOTE_BRANCH ]; then
    git push --set-upstream origin "${CURRENT_LOCAL_BRANCH}"
  else
    git push --set-upstream "$REMOTE_BRANCH" "$CURRENT_LOCAL_BRANCH"
  fi

}
