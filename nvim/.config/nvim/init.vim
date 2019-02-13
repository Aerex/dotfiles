" ensure vim-plug is installed and then load it
call plug#begin('~/.config/nvim/plugged')

  " ================ General Config ====================
set relativenumber               
set nu
set backspace=indent,eol,start  "Allow backspace in insert mode
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

" Don't add the comment prefix when I hit enter or o/O on a comment line.
autocmd FileType * setlocal formatoptions-=r formatoptions-=o



let g:vimtex_compiler_progname = 'nvr'

" Pressing space in normal mode is mapped to left so you must override this
" default
let mapleader="\<Space>"
let maplocalleader="\<Space>"
map <leader>w :w<CR>
map <leader>zz ZQ 
map <leader>xx ZZ 

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

" Don't add the comment prefix when I hit enter or o/O on a comment line.
autocmd FileType * setlocal formatoptions-=cro

" clear highlights by hitting ESC
" or by hitting enter in normal mode
nnoremap <CR> :noh<CR><CR>

" ================ Dictionary ===========================
set dictionary+=/usr/share/dict/words
inoremap <F12> <C-X><C-K>
au FileType journal, txt set complete+=k


" ================ Command Key Binding ===================
cnoremap <C-h> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>

" ================ Source ZSH Alias  ===========================
" Credits https://unix.stackexchange.com/a/71966
let $ZSH_ENV = $HOME . "/.zsh." . getpid()
au VimLeave * silent !exec rm -f "$ZSH_ENV"
silent !echo 'vim_setup() { shopt -s expand_aliases; trap write_aliases EXIT; eval "$@"; }; write_aliases() { typeset -f vim_setup write_aliases; alias; echo vim_setup \"\$@\";} > "$ZSH_ENV"; vim_setup "$@"' > "$BASH_ENV"
set shell=/bin/bash
" ================ Appearance ===========================
"enable transparent background
let g:seiya_auto_enable=1

" ================ Search ===========================

set clipboard+=unnamedplus
set hlsearch
set ignorecase 
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

map z/ <Plug>(incsearch-easymotion-/)
map z? <Plug>(incsearch-easymotion-?)
map zg/ <Plug>(incsearch-easymotion-stay)

let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

map <leader>ra :s/<C-R><C-W>/


" ================ Indentation ======================
"
" ================ Fonts ======================
set guifont=Meslo_LG_L_DZ_Regular_Nerd_Font_Complete:h12


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

map <C-a> <Nop>
map <C-x> <Nop>
" ================ Windows  =======================

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
nnoremap <C-h> <C-W>h
nnoremap <C-W><leader> <C-W>=

"split better way
set splitright


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

" ================ Folds ============================

set expandtab
au BufEnter,BufRead *.python setlocal fdm=indent
au FileType python set foldmethod=indent
set foldmethod=syntax   "fold based on indent
set foldnestmax=5       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================ File Types  =======================
autocmd Syntax   javascript   setlocal isk+=$, ts=2
autocmd FileType markdown,text,txt setlocal tw=120 linebreak nolist
autocmd FileType xml,xsd,xslt,javascript setlocal ts=2

" ================ Plugins =======================
Plug 'mileszs/ack.vim'
Plug 'gu-fan/riv.vim' , {'for': ['rst'] } 
Plug 'waiting-for-dev/vim-www'
Plug 'scrooloose/nerdtree'
Plug 'bartlibert/vim-jira-complete'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-commentary'
Plug 'itchyny/lightline.vim'
Plug 'nanotech/jellybeans.vim' "Load colorschemes
Plug 'https://github.com/Valloric/YouCompleteMe', {'do': './install.py'}
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive' " Git fugitive
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-scripts/YankRing.vim'
Plug 'michaeljsmith/vim-indent-object', { 'for': ['python'] }
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-dispatch'
Plug 'xolox/vim-misc'
Plug 'dagwieers/asciidoc-vim'
Plug 'pedrosans/vim-notes'
Plug 'vim-scripts/utl.vim'
Plug 'moll/vim-node', {'for': ['javascript']}
Plug 'beloglazov/vim-online-thesaurus'
Plug 'codeindulgence/vim-tig'
Plug 'w0rp/ale'
Plug 'ledger/vim-ledger', { 'for': ['ledger'] }
Plug 'mildred/vim-ledger-mode', { 'for': ['ledger'] }
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'mhinz/vim-startify'
Plug 'greyblake/vim-preview'
Plug 'janko-m/vim-test'
Plug 'blindFS/vim-taskwarrior'
Plug 'haya14busa/incsearch.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'lervag/vimtex'
Plug 'blindFS/vim-taskwarrior'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-abolish'
Plug 'critium/vim-node-debugger' 
"Plug 'vimwiki/vimwiki'
Plug 'vim-scripts/ShowMarks'
Plug 'dhruvasagar/vim-table-mode'
Plug 'haya14busa/incsearch.vim'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-jdaddy'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'tpope/vim-dadbod'

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
" ================ Plugin / Setting Configuration  =======================
so ~/.config/nvim/settings.vim

call plug#end()
" ================ Colors  =======================
colorscheme jellybeans
highlight LineNr ctermfg=grey
