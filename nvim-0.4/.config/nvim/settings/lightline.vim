" Add diagnostic info for https://github.com/itchyny/lightline.vim
let g:lightline = {
        \ 'colorscheme': 'custom',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename',  'modified' ] ],
      \   'right': [ ['percent', 'filepath'], ['lineinfo'] ]
      \ },
      \ 'component_function': {
      \    'cwd': 'getcwd', 
      \   'cocstatus': 'coc#status',
      \   'gitbranch': 'fugitive#head',
      \   'filepath': 'LightLineFilepath',  
      \   'fileformat': 'LightLineFileformat', 
      \   'filetype': 'LightLineFiletype', 
      \   'fileencoding': 'LightLineFileencoding', 
      \   'lineinfo': 'LightLineInfo'
      \ }
      \ }
", ['fileformat', 'fileencoding', 'filetype'] ]
function! LightLineFilepath()
    return '' != expand('%t') ? expand('%t') : '[No Name]'
endfunction
function! s:set_lightline_colorscheme(name) abort
  let g:lightline.colorscheme = a:name
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction


function! LightLineInfo()
  return winwidth(0) > 60 ? printf("%3d:%-2d", line('.'), col('.')) : ''
endfunction

function! s:lightline_colorschemes(...) abort
  return join(map(
        \ globpath(&rtp,"autoload/lightline/colorscheme/*.vim",1,1),
        \ "fnamemodify(v:val,':t:r')"),
        \ "\n")
endfunction

command! -nargs=1 -complete=custom,s:lightline_colorschemes LightlineColorscheme
      \ call s:set_lightline_colorscheme(<q-args>)


let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0
