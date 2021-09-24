"This feature allows the ge command to follow named anchors in links of the form file#anchor or just #anchor,
"where file may omit the .md extension as usual. Two variables control its operation:
let g:vim_markdown_follow_anchor = 0

"Auto-write when following link
"If you follow a link like this [link text](link-url) using the ge shortcut, this option will automatically save any edits
"you made before moving you:
let g:vim_markdown_autowrite = 0

"By default, scripts are blocked. To allow scripts to run, edit your .vimrc and add
"let g:instant_markdown_allow_unsafe_content = 1

let g:vimwiki_list = [{'path': '~/Documents/notes',
                      \ 'syntax': 'markdown', 'ext': '.md', 'links_space_char': '_'}]
let g:vimwiki_global_ext = 0


" Disable default link
let g:vimwiki_key_mappings = { 'links': 0 }

autocmd FileType vimwiki nmap <silent> <leader>tl <Plug>VimwikiToggleListItem<CR>
autocmd FileType vimwiki vmap <silent> <leader>tl <Plug>VimwikiToggleListItem<CR>
autocmd FileType vimwiki nmap <silent> <leader>mp <Plug>MarkdownPreview<CR>

"let g:mkdp_browserfunc = 'OpenCLIBrowser'

function! OpenCLIBrowser(url)
  exec W3m . a:url
  "Open new terminal buffer
endfunction
