let g:ranger_win_width = '31'
let g:ranger_win_pos = 'leftabove'
let g:ranger_split_cmd = 'vsplit'
function! RangerInWindowSplit()
  let rangerCallback = { 'name': 'ranger', 'edit_cmd': 'edit '}
  function! rangerCallback.on_exit(job_id, code, event)
    try
      q
      wincmd l
      if filereadable("/tmp/chosenfile")
        for f in readfile("/tmp/chosenfile")
          exec self.edit_cmd . f
        endfor
        call delete("/tmp/chosenfile")
      endif
    endtry
  endfunction
  let currentPath = expand('%')
  topleft 30vs
  enew
  call termopen('ranger  --choosefiles=/tmp/chosenfile --cmd="set shorten_title=2"--cmd="set hostname_in_titlebar=false" --cmd="set automatically_count_files=false" --cmd="set viewmode=multipane" --cmd="set preview_script=false" --selectfile="' . currentPath . '"', rangerCallback )
  startinsert
endfunction


map <leader>rr :call RangerInWindowSplit()<CR>
