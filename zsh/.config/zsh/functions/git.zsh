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

function _gh_exists() { 
  if [[ -z $(command -v gh) ]]; then
    printf "gh not installed"
    exit 1
  fi
}

function ghv() { 
  _gh_exists

  REPO_OPT=""
  if [ ! -z $GH_ISSUE_REPO ]; then
    gh issue view -R $GH_ISSUE_REPO $@
  else
    gh issue view $@
  fi

}

function ghvd() { 
  ISSUE=$1
  _gh_exists
  if [[ $(command -v fx) ]] && [[ $(command -v mdv) ]]; then
    gh issue view $ISSUE --json body | fx '.body' | mdv - 
  else _ghv $1
  fi
  
}

function ghpv() { 
  _gh_exists

  gh pr view $@

}

function ghpm() { 
  _gh_exists

  gh pr list --assignee @me

}

function ghb() { 
  _gh_exists

  BROWSE=$(which google-chrome) gh issue view $@ --web

}


