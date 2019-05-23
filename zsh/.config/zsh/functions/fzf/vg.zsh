# Open a file at specified linenumber in $EDITOR using ag and fzf
vg() {
  local file
  local line


  read -r file line <<<"$(ag --nobreak --noheading $@ | fzf -0 -1 | awk -F: '{print $1, $2}')"

  if [[ -n $file ]]
  then
     $EDITOR $file +$line
  fi
}
