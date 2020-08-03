" ensure vim-plug is installed and then load it
call plug#begin('~/.config/nvim/plugged')

" ================ General Config ==================== {{{1
let OS=substitute(system('uname -s'),"\n","","")
set relativenumber               
set lazyredraw
set nu
set backspace=indent,eol,start  "Allow backspace in insert mode
set diffopt+=iwhite             "Avoid whitespace comparison
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
let g:spellfile_URL = 'http://ftp.vim.org/vim/runtime/spell' " Spell runtime dictionary
set showmode                    "Show current mode down the bottom
set shell=/bin/zsh
set visualbell                  "No sounds
set noerrorbells t_vb=          " disable annoying beeping
set autoread                    "Reload files changed outside vim
set noswapfile                  "No swap files generated
set undofile
set undodir=~/.config/nvim/tmp/undodir

" function to toggle spell on and off
function! ToggleSpell()
  if &spell==0
    set spell 
  else
    set nospell
  endif
endfunction

" Don't add the comment prefix when I hit enter or o/O on a comment line.
autocmd FileType * setlocal formatoptions-=r formatoptions-=o
autocmd FileType crontab setlocal nobackup nowritebackup

autocmd BufEnter init.vim map <silent> <leader>pi :PlugInstall<CR>
autocmd BufEnter init.vim map <silent> <leader>pu :PlugUpdate<CR>
autocmd BufEnter init.vim map <silent> <leader>pc :PlugClean<CR>


" Remove trailing spaces
map <silent> <leader>rts :RemoveTrailingSpaces<CR>

" To use echodoc, you must increase 'cmdheight' value.
set noshowmode  
let g:echodoc_enable_at_startup = 1

"To map <Esc> to exit terminal-mode:
tnoremap <Esc> <C-\><C-n>
autocmd TermOpen fzf <Esc> <C-c>

"Autoload init.vim after each save
autocmd BufWritePost init.vim source %

let g:patchreview_patch_needs_crlf = 1
let g:vimtex_compiler_progname = 'nvr'
let g:github_user = 'Aerex'

" Pressing space in normal mode is mapped to left so you must override this
" default
let mapleader="\<Space>"
let maplocalleader="\<Space>"
map <leader>w :w<CR>
map <leader>zz ZQ 
map <leader>xx ZZ 

"Map :join due to easy-motion
nmap <leader>jo :join<CR>
vmap <leader>jo :join<CR>


"Create easy map for toggling set wrap 
function! ToggleWrap()
  if &wrap==0
    set wrap
  else
    set nowrap
  endif
endfunction
map ,tw :call ToggleWrap()<CR> 

"Map :e (reload buffer)
map <silent> <leader>rb :call ReloadLocalBuffer()<CR>

"Map reload vim init settings
map <silent> <leader>rv :so ~/.config/nvim/init.vim<CR>

function! ReloadLocalBuffer()
  execute "e"
  echo "Buffer Reloaded"
endfunction

"Easier way to go into command mode
map <leader><enter> :
map <leader>9 :

map ! :Dispatch <Right>
" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

" switch cursor to line when in insert mode, and block when not
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
	\,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
	\,sm:block-blinkwait175-blinkoff150-blinkon175

" Don't add the comment prefix when I hit enter in /* or // comment block
" Credits to https://stackoverflow.com/a/4896234/3456790
nnoremap <expr> O getline('.') =~ '^\s*//' ? 'O<esc>S' : 'O'
nnoremap <expr> o getline('.') =~ '^\s*//' ? 'o<esc>S' : 'o'
autocmd FileType vim nnoremap <expr> o getline('.') =~ '^\s*"' ? 'o<esc>S' : 'O'
autocmd FileType vim nnoremap <expr> o getline('.') =~ '^\s*"' ? 'o<esc>S' : 'o'
autocmd FileType * setlocal formatoptions-=cro

" clear highlights by hitting ESC
" or by hitting enter in normal mode
nnoremap <CR> :noh<CR><CR>
map <f1>  :noh<CR><CR>

"Install plugins

" ================ Dictionary =========================== {{{1
set dictionary+=/usr/share/dict/words
inoremap <F12> <C-X><C-K>
"au FileType journal, txt set complete+=k


" ================ Command Key Binding =================== {{{1
cnoremap <C-a> <Home>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
inoremap <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"
inoremap <expr> <C-E> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"
inoremap <expr> <C-F> col('.')>strlen(getline('.'))?"\<Lt>C-F>":"\<Lt>Right>"
cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>

" ================ Source ZSH Alias  =========================== {{{1
" Credits https://unix.stackexchange.com/a/71966
"let $ZSH_ENV = $HOME . "/.zshvimrc." . getpid()
"au VimLeave * silent !exec rm -f "$ZSH_ENV"
"silent !echo 'vim_setup() { shopt -s expand_aliases; trap write_aliases EXIT; eval "$@"; }; write_aliases() { typeset -f vim_setup write_aliases; alias; echo vim_setup \"\$@\";} > "$ZSH_ENV"; vim_setup "$@"' > "$ZSH_ENV"
"set shell=/bin/zsh
" ================ Appearance =========================== {{{1
"enable transparent background
let g:seiya_auto_enable=1

let g:jellybeans_overrides = {
\    'MatchParen': { 'guifg': 'ffffff', 'guibg': '556779' },
\}

" ================ Search =========================== {{{1

set clipboard+=unnamedplus
set hlsearch
set ignorecase 
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

map z/ <Plug>(incsearch-easymotion-/)
map z? <Plug>(incsearch-easymotion-?)
map zg/ <Plug>(incsearch-easymotion-stay)

"let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" ================ Indentation ======================
"
" ================ Fonts ======================
if (OS == "Darwin")
set guifont=Meslo_LG_L_DZ_Regular_Nerd_Font_Complete:h12
endif 

set autoindent
set smartindent
set smarttab


au BufEnter,BufRead *.python setlocal fdm=indent
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab


filetype plugin on
filetype indent on

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" ================ Increment / Decrement   =======================

if (OS == "Darwin")
  map ++ <C-a>
  map -- <C-x>
endif
" ================ Windows  ==================== {{{1

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
nnoremap <C-h> <C-W>h
nnoremap <C-W><leader> <C-W>=

"split better way
set splitright


" ================ Tabs  ==================== {{{1
let g:tmux_navigator_no_mappings = 1
if (OS == "Darwin")
  nnoremap <silent> ]t gT
  nnoremap <silent> [t gt
  nnoremap <silent> <A-1> 1gt
  nnoremap <silent> <A-2> 2gt
  nnoremap <silent> <A-3> 3gt
  nnoremap <silent> <A-4> 4gt
endif
nnoremap <silent> <D-S-h> gT
nnoremap <silent> <D-S-l> gt
nnoremap <silent> <D-1> 1gt
nnoremap <silent> <D-2> 2gt
nnoremap <silent> <D-3> 3gt
nnoremap <silent> <D-4> 4gt



nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>
nnoremap <silent> <C-<Tab>> :TmuxNavigatePrevious<cr>
" ================ Completion =======================

set completeopt-=preview
set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

" ================ Folds ============================ {{{1

set expandtab
au BufEnter,BufRead *.python setlocal fdm=indent
au FileType python set foldmethod=indent
set foldmethod=syntax   "fold based on indent
set foldnestmax=5       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================ File Types  ======================= {{{1
autocmd Syntax javascript setlocal ts=2
autocmd FileType sql Autoformat 
autocmd BufEnter,BufRead *sql :Autoformat<cr>
autocmd FileType markdown,text,txt setlocal tw=190 linebreak nolist
autocmd FileType xml,xsd,xslt,javascript,javascript.jsx setlocal ts=2
" autocmd FileType javascript map nlt :Dispatch npm run lint<CR>
autocmd BufEnter,BufRead PULLREQ_EDITMSG setlocal wrap tw=190
autocmd BufEnter,BufRead create* setlocal wrap tw=190
autocmd BufEnter,BufRead subtask* setlocal wrap tw=190

" ================ Plugins ======================= {{{1
Plug 'ervandew/supertab'
Plug 'godlygeek/tabular'
Plug 'diepm/vim-rest-console'
Plug 'Shougo/echodoc.vim'

Plug 'Chiel92/vim-autoformat'
Plug 'vifm/vifm.vim'
" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }

" (Optional) Multi-entry selection UI.
" Open a Quickfix item in a window you choose
Plug 'yssl/QFEnter'
" Enable repeating supported plugin maps with \"." 
Plug 'tpope/vim-repeat'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf'
Plug 'sheerun/vim-polyglot'
Plug 'christoomey/vim-tmux-navigator'
Plug 'mileszs/ack.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'gu-fan/riv.vim' , {'for': ['rst'] } 
" Plug 'scrooloose/nerdtree'
Plug 'mnpk/vim-jira-complete'
Plug 'tpope/vim-commentary'
Plug 'itchyny/lightline.vim'
Plug 'nanotech/jellybeans.vim' "Load colorschemes
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive' " Git fugitive
Plug 'gregsexton/gitv', {'on': ['Gitv']}
"Plug 'junegunn/gv.vim'
Plug 'vim-scripts/YankRing.vim'
Plug 'tpope/vim-dispatch'
Plug 'pedrosans/vim-misc'
Plug 'luochen1990/rainbow'
" Plug 'moll/vim-node', {'for': ['javascript']}
Plug 'w0rp/ale', { 'for': ['javascript']}
Plug 'ledger/vim-ledger', { 'for': ['ledger'] }
Plug 'mildred/vim-ledger-mode', { 'for': ['ledger'] }
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'janko-m/vim-test'
Plug 'blindFS/vim-taskwarrior'
Plug 'haya14busa/incsearch.vim'
"Plug 'ludovicchabant/vim-gutentags'
Plug 'airblade/vim-gitgutter'
Plug 'blindFS/vim-taskwarrior'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-abolish'
Plug 'hashivim/vim-terraform'
Plug 'tpope/vim-rhubarb'
Plug 'kshenoy/vim-signature'
Plug 'dhruvasagar/vim-table-mode'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-jdaddy'
Plug 'junegunn/fzf.vim'
Plug '/usr/local/opt/fzf'
Plug 'haya14busa/incsearch-easymotion.vim'

function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction

Plug 'euclio/vim-markdown-composer', { 'for': ['markdown'], 'do': function('BuildComposer') }
" ================ Plugin / Setting Configuration  ======================= {{{1
so ~/.config/nvim/settings.vim

call plug#end()
" ================ Colors  =============================================== {{{1
colorscheme jellybeans
highlight LineNr ctermfg=grey
highlight Visual ctermfg=248 
" vim: nowrap fdm=marker tw=190

