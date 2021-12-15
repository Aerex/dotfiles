" automatically open NERDTree when VIM starts up
"autocmd vimenter * NERDTree
" Close NERDTree if it is the last buffer opened 
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"
"" Credits to https://github.com/rizidoro/dotfiles/blob/844e98dae347c9bd2e6702b81d79e802e0c0a09c/vim/settings.vim
"" Open the project tree and expose current file in the nerdtree with Ctrl-\
"" calls NERDTreeFind iff NERDTree is active, current window contains a modifiable file, and we're not in vimdiff
"function! OpenNerdTree()
"    if &modifiable && strlen(expand('%')) > 0 && !&diff
"        NERDTreeFind
"    else
"        NERDTreeToggle
"    endif
"endfunction
"
"map <Leader>n :call OpenNerdTree()<CR>
"map <Leader><Leader>n :NERDTreeFocus<CR>
"
"au VimEnter * call NERDTreeAddKeyMap({
"      \ 'key': 'yy',
"      \ 'callback': 'NERDTreeMapYankHandler',
"      \ 'quickhelpText': 'Copy a file',
"      \ 'scope': 'FileNode' })
"
"au VimEnter * call NERDTreeAddKeyMap({
"      \ 'key': 'pp',
"      \ 'callback': 'NERDTreeMapPasteHandler',
"      \ 'quickhelpText': 'Paste file into a directory. If a file exists added `_` suffix',
"      \ 'scope': 'DirNode' })
"
"
"
"function! NERDTreeMapYankHandler(filenode)
"  let b:copyNodeFile  = g:NERDTreeFileNode.GetSelected()
"endfunction
"
"function! NERDTreeMapPasteHandler(dirnode)
"  let dirNode = a:dirnode.path
"  let copiedNodeFile = b:copyNodeFile
"  let existingFile = a:dirnode.findNode(copiedNodeFile)
"
"  if empty(existingFile)
"      call dirNode.addChild(copiedNodeFile)
"      call nerdtree#echo("Pasted file " . copiedNodeFile.path . " to directory " . dirNode)
"endfunction
"
"
"
"" NERDTress File highlighting
"function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
"  exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
"  exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
"endfunction
"
"
"call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
"call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
"call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
"call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
"call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
"call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
"call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')
"
"let g:NERDTreeDirArrowExpandable = '▸'
"let g:NERDTreeDirArrowCollapsible = '▾'
"
"let g:NERDTreeMouseMode = 2
"let g:NERDTreeWinSize = 30
"let g:NERDTreeMinimalUI=1
"
"let g:NERDTreeShowHidden=1
