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

function gcod() {
  dev_branch=$(git branch --list | sed 's/\*\s//' | tr -d ' ' | grep -E '^dev$')
  git checkout $dev_branch
}

function gcom() {  
  master_branch=$(git branch --list | sed 's/\*\s//' | tr -d ' ' | grep -E '^ma(in|ster)')
  git checkout $master_branch
}

function gmm() {
  master_branch=$(git branch --list | sed 's/\*\s//' | tr -d ' ' | grep -E '^ma(in|ster)')
  git merge $master_branch
}

function ghpc() {
  _gh_exists

  gh pr comment $@
}

function ghc() { 
  _gh_exists
  gh issue comment $@
}

function ghpm() { 
  _gh_exists

  gh pr list --author @me

}

function ghb() { 
  _gh_exists

  BROWSE=$(which google-chrome) gh issue view $@ --web

}

function ghe() { 
  _gh_exists

  gh issue edit $@
}

function ghy() {
  local skip
  
  #===  FUNCTION  ================================================================
  #         NAME:  usage
  #  DESCRIPTION:  Display usage information.
  #===============================================================================
  function usage ()
  {
    echo "Usage:  ghy [options] 

Options:
-h|help            Display this message
-t|title           Copy gh title to clipboard
-u|url|l|link      Copy gh url/link to clipboard"
      skip=1
  
  }    # ----------  end of function usage  ----------
  
  #-----------------------------------------------------------------------
  #  Handle command line arguments
  #-----------------------------------------------------------------------
  
  while getopts ":htuls" opt
  do
    case $opt in
  
    h|help )  usage; ;;
    t|title) PROP="title";;
    u|l|link|url) PROP="url";;
    * ) printf "\\033[31mOption does not exist: -$OPTARG\\033[0m\\n\n";usage; skip=1 ;;
    esac    # --- end of case ---
  done
  shift $(($OPTIND-1))

  if [[ -z $skip ]]; then 
    ISSUE=$1
    _gh_exists

    if [[ -z $(command -v jq) ]]; then 
      echo 'Missing jq'
      exit 1
    fi
    gh issue view $ISSUE --json $PROP | jq -r ".$PROP" | copy
  fi
}

function ghyt() { 
  ISSUE=$1
  _gh_exists

  if [[ $(command -v jq) ]]; then
    gh issue view $ISSUE --json title | jq -r '.title' | copy
  else
    echo 'Missing jq'
  fi
}


function ghyl() { 
  ISSUE=$1
  _gh_exists

  if [[ $(command -v jq) ]]; then
    gh issue view $ISSUE --json url | jq -r '.url' | copy
  else
    echo 'Missing jq'
  fi
}

function ghvs(){
  ISSUE=$1
  _gh_exists

  if [[ $(command -v jq) ]]; then
    gh issue view $ISSUE --json state | jq -r '.state'
  else
    echo 'Missing jq'
  fi
}

function gws(){
  if [[ $(command -v ghwork) ]]; then
    dir=$(ghwork)
    if [[ -n $dir ]]; then
      cd $dir
    fi
  fi
}

