#!/usr/bin/env zsh
function copy() {
  if [[ $(uname -s) == "Darwin" ]]; then
    pbcopy $@
  else 
    xsel --clipboard --input
  fi

}

zvm_vi_yank () {
	zvm_yank
	printf %s "${CUTBUFFER}" | xclip -sel c
	zvm_exit_visual_mode
}
