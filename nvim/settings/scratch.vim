"If set to a valid file path the scratch window contents will be written to
"that path whenever the scratch window gets hidden. Contents won't be lost
"when exiting vim. When opening the scratch window for the first time the
"contents will be read into the scratch window.
"Absolute path results in global scratchpad:
"let g:scratch_persistence_file = '/tmp/scratch.vim'
"Projectwise scratchpads:
"let g:scratch_persistence_file = '.scratch.vim'
   
let g:scratch_persistence_file = '/tmp/scratch.vim'


let g:scratch_no_mappings = 1
let g:scratch_height = 20


nmap <leader>sp : ScratchPreview<CR>
nmap <leader>S <plug>(scratch-insert-reuse)
nmap <leader>sc <plug>(scratch-insert-clear)
xmap <leader>sr <plug>(scratch-selection-reuse)
xmap <leader>sc <plug>(scratch-selection-clear)


