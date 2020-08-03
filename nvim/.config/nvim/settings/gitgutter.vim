"Use a custom grep command
"If you use an alternative to grep, you can tell vim-gitgutter to use it here.
let g:gitgutter_grep = 'rg'

"To turn off signs by default
let g:gitgutter_signs = 0


if filereadable(expand('~/.config/nvim/plugged/vim-gitgutter/plugin/gitgutter.vim'))
	" Don't show gitgutter signs in files with more than 500 changes
	let g:gitgutter_max_signs = 500
endif
