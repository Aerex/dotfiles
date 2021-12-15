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
set shell=/usr/bin/zsh
set visualbell                  "No sounds
set noerrorbells t_vb=          " disable annoying beeping
set autoread                    "Reload files changed outside vim
set noswapfile                  "No swap files generated
set undofile
set undodir=~/.config/nvim/tmp/undodir


"set cmdheight=2
" Don't add the comment prefix when I hit enter or o/O on a comment line.
autocmd FileType * setlocal formatoptions-=r formatoptions-=o

autocmd BufEnter init.vim map <leader>pi :PlugInstall<CR>
autocmd BufEnter init.vim map <leader>pc :PlugClean<CR>
autocmd BufEnter init.vim map <leader>pu :PlugUpdate<CR>

"Autoload init.vim when save
"autocmd BufWritePost init.vim source %

" clear highlights by hitting ESC
" or by hitting enter in normal mode
nnoremap <CR> :noh<CR><CR>

set statusline=%F%m%r%h%w\  "fullpath and status modified sign
set statusline+=\ %y "filetype
set statusline+=\ %{fugitive#statusline()}
" this line below pushes everything below it to the right hand side
set statusline+=%=
set statusline+=\%l
" this line below adds Git Time Metric status line
set statusline+=\ %{exists('*GTMStatusline')?'['.GTMStatusline().']':''}

let g:vimtex_compiler_progname = 'nvr'
" Pressing space in normal mode is mapped to left so you must override this
" default
let mapleader="\<Space>" 
let maplocalleader="\<Space>"


"To map <Esc> to exit terminal-mode:
if has("nvim")
  au TermOpen * tnoremap <Esc> <c-\><c-n>
  au FileType fzf tunmap <Esc>
endif

map <leader>w :w<CR>
map <leader>zz :q!<CR>
" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden


map <silent> <buffer> <leader>rv :so ~/.config/nvim/init.vim<CR>
map <silent> <leader>rb :call ReloadBuffer()<CR>

function! ReloadBuffer()
  echo "Reloading Buffer"
  edit
endfunction


" switch cursor to line when in insert mode, and block when not
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
	\,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
	\,sm:block-blinkwait175-blinkoff150-blinkon175
" ================ Appearance ===========================

let g:seiya_auto_enable=1

" ================ Search ===========================

set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital
set clipboard+=unnamedplus



" ================ Indentation ======================

set autoindent
set smartindent
set smarttab


"au BufEnter,BufRead *.python setlocal fdm=indent
"au FileType python set equalprg=autopep8\ -
"au BufWritePre *.python %s/\s\+$//e
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

"set shiftwidth=4
"set softtabstop=4
"set tabstop=4
"set noexpandtab
" ================ Copy / Pasting  ======================

nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

filetype plugin on
filetype indent on

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" ================ Increment / Decrement   =======================
nnoremap <A-a> <C-a>
nnoremap <A-x> <C-x>
" ================ Windows  =======================

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
nnoremap <C-h> <C-W>h
nnoremap <C-w><leader> <C-w>=

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

au FileType python set foldmethod=indent
set foldmethod=syntax   "fold based on indent
set foldnestmax=7       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================ File Types  =======================
autocmd Syntax   javascript   setlocal isk+=$, ts=2
autocmd FileType markdown,text,txt setlocal linebreak nolist wrap
autocmd FileType xml,xsd,xslt,javascript setlocal ts=2
let g:vimspector_enable_mappings = 'HUMAN'

" ================ Plugins =======================
Plug 'puremourning/vimspector'
if has('nvim-0.4')
Plug 'neoclide/coc.nvim', {'tag': 'v0.0.78' }
endif
if has('nvim-0.5')
 Plug 'nvim-treesitter/nvim-treesitter'
 Plug 'neovim/nvim-lsp'
 Plug 'haorenW1025/diagnostic-nvim'  " A wrapper for neovim built in LSP diagnosis config
 Plug 'vigoux/treesitter-context.nvim',
 "Auto completion framework that aims to provide a better completion experience with neovim's built-in LSP. 
Plug 'nvim-lua/completion-nvim'
 Plug 'nvim-lua/popup.nvim'
endif
"Use FZF instead of coc.nvim built-in fuzzy finder.
Plug 'antoinemadec/coc-fzf'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'rstacruz/vim-closer'
Plug 'Shougo/echodoc.vim'
Plug 'yssl/QFEnter'
" (Optional) Multi-entry selection UI.
Plug 'godlygeek/tabular'

Plug 'wellle/targets.vim'
Plug 'KabbAmine/zeavim.vim'
Plug 'tpope/vim-abolish'
Plug 'Aerex/critiq.vim'
Plug 'sheerun/vim-polyglot'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'nanotech/jellybeans.vim' "Load colorschemes

Plug 'tpope/vim-fugitive' " Git fugitive
Plug 'TimUntersberger/neogit'
Plug 'vim-scripts/YankRing.vim'
Plug 'thinca/vim-textobj-function-javascript'
Plug 'Chiel92/vim-autoformat'
Plug 'tpope/vim-dispatch'
"Plug 'waiting-for-dev/vim-www'
"Plug 'xolox/vim-misc'
"Plug 'xolox/vim-notes'
"Plug 'ternjs/tern_for_vim', { 'for': ['javascript', 'javascript.jsx'], 'do': 'npm install' }
Plug 'moll/vim-node', {'for': ['javascript']}
"Plug 'elzr/vim-json', { 'for': 'json' }
"Plug 'tmhedberg/matchit'
Plug 'christoomey/vim-tmux-navigator'
Plug 'kshenoy/vim-signature'
Plug 'codeindulgence/vim-tig'
Plug 'w0rp/ale'
Plug 'ledger/vim-ledger', { 'for': ['ledger'] }
"Plug 'mildred/vim-ledger-mode', { 'for': ['ledger'] }
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
"Plug 'greyblake/vim-preview'
"Plug 'git-time-metric/gtm-vim-plugin'
"Plug 'kthibodeaux/pull-review'
Plug 'vifm/vifm.vim'
Plug 'chooh/brightscript.vim'
Plug 'janko-m/vim-test'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
Plug 'junegunn/vader.vim'
"Plug 'tpope/vim-jdaddy'
"Plug 'blindFS/vim-taskwarrior'
Plug 'haya14busa/incsearch.vim'
Plug 'lervag/vimtex'

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


if has('nvim-0.5')
  au VimEnter * lua require'init'.setup()
endif

call plug#end()

" ================ Colors  =======================
colorscheme jellybeans
highlight LineNr ctermfg=grey 

