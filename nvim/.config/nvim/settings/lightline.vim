" Add diagnostic info for https://github.com/itchyny/lightline.vim
let g:lightline = {
        \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left': [ [ 'mode',  'paste' ],
      \             [  'readonly', 'filename_treesitter',  'modified' ] ],
      \   'right': [ ['percent', 'filepath'], ['lineinfo'], ['gitgutter'] ]
      \ },
      \ 'component_function': {
      \    'cwd': 'getcwd', 
      \    'filename_treesitter': 'TreesitterFilenameStatus',
      \   'gitbranch': 'LightlineFugitive',
      \   'gitgutter': 'GitGutterStatus',
      \   'filepath': 'LightLineFilepath',  
      \   'fileformat': 'LightLineFileformat', 
      \   'filetype': 'LightLineFiletype', 
      \   'fileencoding': 'LightLineFileencoding', 
      \   'lineinfo': 'LightLineInfo'
      \ }
      \ }
", ['fileformat', 'fileencoding', 'filetype'] ]
function! LightLineFilepath()
  let s:file_path = expand('%t')
    if(s:file_path =~ "ranger")
			return "Ranger"
 		endif 
    return '' != expand('%t') ? expand('%t') : '[No Name]'
endfunction
function! s:set_lightline_colorscheme(name) abort
  let g:lightline.colorscheme = a:name
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

function! GitGutterStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', a, m, r)
endfunction
"set statusline+=%{GitStatus()}

function! LightlineFilename()
		return &ft ==# 'vimfiler' ? vimfiler#get_status_string() :
		      \  &ft ==# 'unite' ? unite#get_status_string() :
		      \ expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
	endfunction

function! TreesitterFilenameStatus() 
  let l:status = LightlineFilename()
  if exists('g:loaded_nvim_treesitter')
    let l:status = nvim_treesitter#statusline(90)
  endif
  if l:status == v:null || l:status == ''
    return LightlineFilename()
  endif
  return l:status
endfunction
function! LightlineFugitive()
  if exists('*FugitiveHead')
    let branch = FugitiveHead()
    return branch !=# '' ? ''.branch : ''
  endif
  return ''
endfunction

function! LightLineInfo()
  return winwidth(0) > 60 ? printf("%3d:%-2d", line('.'), col('.')) : ''
endfunction

"function! s:lightline_colorschemes(...) abort
"  return join(map(
"        \ globpath(&rtp,"autoload/lightline/colorscheme/*.vim",1,1),
"        \ "fnamemodify(v:val,':t:r')"),
"        \ "\n")
"endfunction
"
"command! -nargs=1 -complete=custom,s:lightline_colorschemes LightlineColorscheme
"      \ call s:set_lightline_colorscheme(<q-args>)
"
" autocmd User CocDiagnosticChange call lineline#update()

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0
