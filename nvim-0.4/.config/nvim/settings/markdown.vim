"This feature allows the ge command to follow named anchors in links of the form file#anchor or just #anchor, 
"where file may omit the .md extension as usual. Two variables control its operation:
let g:vim_markdown_follow_anchor = 1

"Auto-write when following link
"If you follow a link like this [link text](link-url) using the ge shortcut, this option will automatically save any edits
"you made before moving you:
let g:vim_markdown_autowrite = 1

autocmd FileType markdown nnoremap <leader><leader>o :ComposerOpen<CR>
autocmd FileType markdown nnoremap <leader><leader>u :ComposerUpdate<CR>

"Specifies a specific browser for the plugin to use. If not set,
"then the plugin will try to determine the default browser.
let g:markdown_composer_open_browser = 0

"Whether the server should automatically start when a markdown
"file is opened.
let g:markdown_composer_autostart = 1

"By default, scripts are blocked. To allow scripts to run, edit your .vimrc and add
"let g:instant_markdown_allow_unsafe_content = 1

