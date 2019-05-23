alias _view_jira_issue_or_commit='if [[ $(echo {+2..}) = *DA* ]]; then jira view {+2..}; else git log -200 --pretty=format:%s $(echo {+2..} | sed \"s/$/../\") fi"'
# fcop - checkout git branch/tag, with a preview showing the commits between the tag/branch and HEAD
fcop() {
  local tags branches target
  tags=$(
git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
git branch --all | grep -v HEAD |
sed "s/.* //" | sed "s#remotes/[^/]*/##" |
sort -u | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
(echo "$tags"; echo "$branches") |
    fzf --no-hscroll --no-multi --delimiter="\t" -n 2 \
    --bind "ctrl-e:execute:(if [[ $(echo {+2..}) = *DA* ]]; then jira view $(echo {+2..}); else return; fi)" \
    --bind "ctrl-d:execute:(if [[ $(echo {+2..}) = *DA* ]]; then git branch -d $(echo {+2..}); else return; fi)"\
    --ansi --preview="jira view {+2..}") 
}

fdb(){
local branches target_branches
  branches=$(git --no-pager branch) 
  target_branches=$(echo "$branches" |
    fzf -m --no-hscroll \
    --bind "ctrl-m:toggle-in" \
    --ansi --preview="echo {} | cut -d : -f 1 | xargs -I % sh -c 'jira view %'")\
  echo $target_branches
}


# fco - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
fco() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}


