let g:fzf_session_path = $HOME . '/.config/nvim/sessions'
"let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
" Border color
" let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Todo' } }

" Border style (rounded / sharp / horizontal)
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Todo', 'border': 'sharp' } }
" Shortcuts for opening up results in splits
let g:fzf_action = {
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
nnoremap <silent> <leader>p  :GFiles<CR>
nnoremap <silent> <leader>,p :Files<CR>
nnoremap <silent> <leader>H  :History<CR>
nnoremap <silent> <leader>m  :Marks<CR>
nnoremap <silent> <leader>S  :Sessions<CR>
nnoremap <silent> <leader>M  :Maps<CR>
nnoremap <silent> <leader>L  :Lines<CR>
nnoremap <silent> <leader>b  :Buffers<CR>
nnoremap <silent> <leader>v  :Commands<CR>
nnoremap <silent> <leader>yr :Registers<CR>

  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --smart-case '.shellescape(<q-args>), 1,
    \   fzf#vim#with_preview(), <bang>0)

  " command! -bang -nargs=* History
  "   \ call fzf#vim#history(
  "   \   'rg --column --line-number --no-heading --smart-case '.shellescape(<q-args>), 1,
  "   \   fzf#vim#with_preview(), <bang>0)


 autocmd  FileType fzf set laststatus=0 noshowmode noruler
       \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--info=inline', '--prompt', '> ']}), <bang>0)
 " command! -bang -nargs=? -complete=dir Files
 "       \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({ 'op tions': ['--prompt', '> '],'source': 'rg --iglob !node_modules! ""'}), <bang>0)

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

 function! s:setcwd()
   let cph = expand('%:p:h', 1)
   if cph =~ '^.\+://' | retu | en
   for mkr in ['.git/', '.hg/', 'node_modules/', '.svn/', '.bzr/', '_darcs/', '.vimprojects', '.config/nvim/']
     let wd = call('find'.(mkr =~ '/$' ? 'dir' : 'file'), [mkr, cph.';'])
     if wd != '' | let &acd = 0 | brea | en
   endfo
   exe 'lc!' fnameescape(wd == '' ? cph : substitute(wd, mkr.'$', '.', ''))
 endfunction

 autocmd BufEnter * call s:setcwd()

 let g:yankring_history_file = '.yankring-history'
 let s:yr_elem_hash = {}
 function! s:get_yankring() 
   function! s:get_clipboard()
    let yr_history_list = []
    let filepath = g:yankring_history_dir . '/' . g:yankring_history_file . '_v2.txt'
    if filereadable(filepath)
      let yr_history_list = readfile(filepath)
    endif
    return yr_history_list

   endfunction
  silent let clipboard_output = s:get_clipboard()
  let content_list = []
  let display_nbr = 1
  for line in clipboard_output
      let display_content = substitute(line, ',V$', '', '')
      if (display_content != '')
        call add(content_list, display_content)
        let s:yr_elem_hash[display_content] = display_nbr
      endif
      let display_nbr += 1
  endfor
  return content_list
 endfunction

function! s:yr_get_element_paste_handler(line)
  let l:clip = get(s:yr_elem_hash, a:line, 0)
  YRGetElem(l:clip)
endfunction


" Custom fzf functions
function! FZFYankRing()
  call fzf#run({
  \ 'source':  s:get_yankring(),
  \ 'sink':    function('s:yr_get_element_paste_handler'),
  \ 'options': '--info=inline --ansi --prompt "Clipboard> " ',
  \ 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Todo', 'border': 'sharp' } 
  \})
endfunction
"TODO: work on later
" function! Settings()
"   call fzf#run({
"   \ 'source':  s:get_yankring(),
"   \ 'sink':    function('s:yr_get_element_paste_handler'),
"   \ 'options': '--info=inline --ansi --prompt "Clipboard> " ',
"   \ 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Todo', 'border': 'sharp' } 
"   \})
" endfunction

command! -nargs=* -bang Registers call FZFYankRing()

" Preview 1}}}
" floating window size ratio
let g:fzf_preview_floating_window_rate = 0.9

" " fzf command default options
" let g:fzf_preview_default_fzf_options = { '--reverse': v:true, '--preview-window': 'wrap' }

" Add fzf quit mapping
let g:fzf_preview_quit_map = 0

" " jump to the buffers by default, when possible
" let g:fzf_preview_buffers_jump = 0

" Commands used for fzf preview.
" The file name selected by fzf becomes {}
if executable('bat')
  let g:fzf_preview_command = 'bat --color=always --plain {-1}' " Installed bat
else 
  let g:fzf_preview_command = 'cat'                               " Not installed bat
endif

" Commands used to get the file list from project
if executable('rg')
  let g:fzf_preview_filelist_command = 'rg --files --hidden --follow --no-messages -g \!"* *"' " Installed ripgrep
else
  let g:fzf_preview_filelist_command = 'git ls-files --exclude-standard'               " Not Installed ripgrep
endif

" Commands used to get the file list from git reposiroty
" let g:fzf_preview_git_files_command = 'git ls-files --exclude-standard'

" Commands used to get the file list from current directory
if executable('rg')
  let g:fzf_preview_directory_files_command = 'rg --files --hidden --follow --no-messages -g \!"* *"'
else
  let g:fzf_preview_directory_files_command = 'git ls-files'
endif

" Commands used to get the git status file list
let g:fzf_preview_git_status_command = "git status --short --untracked-files=all | awk '{if (substr($0,2,1) !~ / /) print $2}'"

" " Commands used for git status preview.
" let g:fzf_preview_git_status_preview_command =  "[[ $(git diff -- {-1}) != \"\" ]] && git diff --color=always -- {-1} || " .
" \ "[[ $(git diff --cached -- {-1}) != \"\" ]] && git diff --cached --color=always -- {-1} || " .
" \ g:fzf_preview_command

" Commands used for project grep
if executable('rg')  
  let g:fzf_preview_grep_cmd = 'rg --line-number --no-heading --color=never'
endif

" " MRU and MRW cache directory
let g:fzf_preview_cache_directory = expand('~/.cache/vim/fzf_preview')

" " If this value is not 0, disable mru and mrw
" let g:fzf_preview_disable_mru = 0

" Commands used for current file lines
if executable('bat')
  let g:fzf_preview_lines_command = 'bat --color=always --plain --number'
endif

 " Commands used for preview of the grep result
" let g:fzf_preview_grep_preview_cmd = expand('<sfile>:h:h') . '/bin/preview_fzf_grep'

" " Cache directory for mru and mrw
" let g:fzf_preview_cache_directory = expand('~/.cache/vim/fzf_preview')

" Keyboard shortcuts while fzf preview is active
let g:fzf_preview_preview_key_bindings = 'ctrl-alt-j:preview-page-down,ctrl-alt-k:preview-page-up,?:toggle-preview'

" " Specify the color of fzf
" let g:fzf_preview_fzf_color_option = ''

" " Set the processes when selecting an element with fzf
" let g:fzf_preview_custom_processes = {}
" " For example, set split to ctrl-s
" " let g:fzf_preview_custom_processes['open-file'] = fzf_preview#remote#process#get_default_processes('open-file')
" " on coc extensions
" " let g:fzf_preview_custom_processes['open-file'] = fzf_preview#remote#process#get_default_processes('open-file', 'coc')
" " let g:fzf_preview_custom_processes['open-file']['ctrl-s'] = g:fzf_preview_custom_processes['open-file']['ctrl-x']
" " call remove(g:fzf_preview_custom_processes['open-file'], 'ctrl-x')

" " Use as fzf preview-window option
" let g:fzf_preview_fzf_preview_window_option = ''
" " let g:fzf_preview_fzf_preview_window_option = 'up:30%'

" Use vim-devicons
let g:fzf_preview_use_dev_icons = 1

" devicons character width
let g:fzf_preview_dev_icon_prefix_string_length = 3

" " Devicons can make fzf-preview slow when the number of results is high
" " By default icons are disable when number of results is higher that 5000
let g:fzf_preview_dev_icons_limit = 5000

" " The theme used in the bat preview
" $FZF_PREVIEW_PREVIEW_BAT_THEME = 'ansi-dark'nnoremap <silent> <leader>,p [fzf-p]
"}}}



