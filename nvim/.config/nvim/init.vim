
"███╗░░██╗███████╗░█████╗░██╗░░░██╗██╗███╗░░░███╗
"████╗░██║██╔════╝██╔══██╗██║░░░██║██║████╗░████║
"██╔██╗██║█████╗░░██║░░██║╚██╗░██╔╝██║██╔████╔██║
"██║╚████║██╔══╝░░██║░░██║░╚████╔╝░██║██║╚██╔╝██║
"██║░╚███║███████╗╚█████╔╝░░╚██╔╝░░██║██║░╚═╝░██║

" ensure vim-plug is installed and then load it

" ================ General Config ==================== {{{1
let g:OS = substitute(system('uname -s'),"\n","","")
set path=.,/usr/local/include,/usr/include
set encoding=UTF-8
set modeline
" Turns on filetype detection, filetype plugins, and filetype indenting all of which add nice extra features to whatever language you're using
filetype plugin indent on
" Turns on filetype detection if not already on, and then applies filetype-specific highlighting.
" Don't redraw screen when executing macros, regs, and other commands
set lazyredraw
set number
set relativenumber
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
set viminfo='1000
set sessionoptions+=tabpages,globals "Remember tabnames when restoring sessions
set signcolumn=auto:4 " Prevent different signs from hidding other signs

if &filetype == 'php'
  set iskeyword+=$
endif

" Pressing space in normal mode is mapped to left so you must override this
" default
let mapleader="\<Space>"
let maplocalleader="\<Space>"

"Python
if (OS == "Darwin" && !has('python3'))
  let g:python3_host_prog = '/usr/local/bin/python3'
  let g:UltiSnipsNoPythonWarning = 1
endif


" Toggling
" function to toggle spell on and off
function! ToggleSpell()
  if &spell==0
    set spell
    echo "Enabled spellcheck"
  else
    set nospell
    echo "Disabled spellcheck"
  endif
endfunction
map <silent><leader>,ts :call ToggleSpell()<CR>

"Create easy map for toggling set wrap
function! ToggleWrap()
  if &wrap==0
    set wrap
    echo "Enabled wraping"
  else
    set nowrap
    echo "Disabled wraping"
  endif
endfunction
map <silent><leader>,tw :call ToggleWrap()<CR>

" Don't add the comment prefix when I hit enter (r) or o/O (o) on a comment line.
autocmd FileType * setlocal formatoptions-=r formatoptions-=o
autocmd FileType crontab setlocal nobackup nowritebackup

"FIXME: Need a better way to run only if current buffer is init.vim
" autocmd FileType vim map <silent> <leader>pi :PlugInstall<CR>
" autocmd FileType vim map <silent> <leader>pu :PlugUpdate<CR>
" autocmd FileType vim map <silent> <leader>pc :PlugClean<CR>


" Remove trailing spaces
noremap <silent> <leader>rts :%s/\s\+$//e<CR>

" To use echodoc, you must increase 'cmdheight' value.
set noshowmode
"To map <Esc> to exit terminal-mode:
" tnoremap <Esc> <C-\><C-n>
" autocmd TermOpen fzf <Esc> <C-c>

"Autoload init.vim after each save
"autocmd BufWritePost init.vim source %


let g:miniyank_filename = $HOME."/.miniyank.mpack"
noremap Y y$

let g:patchreview_patch_needs_crlf = 1
let g:vimtex_compiler_progname = 'nvr'
let g:github_user = 'Aerex'

map <leader>w :w<CR>
map <leader>zz ZQ
map <leader>xx ZZ

"Map :join due to easy-motion
nmap <leader>jo :join<CR>
vmap <leader>jo :join<CR>

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

set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

au BufEnter,BufRead *.python setlocal fdm=indent
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
"au BufEnter,BufRead *.php setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab tw=98
au BufEnter,BufRead *.php set nocompatible
autocmd BufWritePost *.php,*.js :%s/\s\+$//e

filetype plugin on
filetype indent on

" Display tabs and trailing spaces visually
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
"set list listchars=tab:\ \ ,trail:·

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
nnoremap <silent> ]t gT
nnoremap <silent> [t gt
if (OS == "Darwin")
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

set completeopt=menuone,noinsert,noselect
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
autocmd FileType markdown,text,txt setlocal tw=0 wrap linebreak nolist
autocmd FileType xml,xsd,xslt,javascript,javascript.jsx setlocal ts=2
autocmd BufEnter,BufRead PULLREQ_EDITMSG setlocal wrap
autocmd BufEnter,BufRead create* setlocal wrap tw=190
autocmd BufEnter,BufRead subtask* setlocal wrap tw=190


" ================ Plugins ======================= {{{1

call plug#begin('~/.config/nvim/plugged')

" ================ LSP ======================= {{{2
if has('nvim-0.5')
  Plug 'lukas-reineke/indent-blankline.nvim', { 'branch' : 'lua' }
  Plug 'glepnir/lspsaga.nvim'
  Plug 'nvim-lua/lsp-status.nvim'
  "Rainbow parentheses for neovim using tree-sitter. Needs nvim-treesitter.
  Plug 'p00f/nvim-ts-rainbow'
  " A high-performance color highlighter for Neovim which has no external dependencies
  Plug 'norcalli/nvim-colorizer.lua'
  "A dark neovim colorscheme written in lua and syntax based on nvim-treesitter
  Plug 'glepnir/dashboard-nvim'
  " forked of vim-web-devicons (works well with barbar)
  Plug 'kyazdani42/nvim-web-devicons'
  " Plug 'natebosch/vim-lsc'
  Plug 'nvim-treesitter/nvim-treesitter'
  " View treesitter information directly in Neovim!
  Plug 'nvim-treesitter/playground'
 " An implementation of the Popup API from vim in Neovim. Hope to upstream when complete
  Plug 'nvim-lua/popup.nvim'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'folke/trouble.nvim'
  Plug 'folke/todo-comments.nvim'
  " A fuzzy finder like fzf but uses builtin nvim
  Plug 'nvim-lua/telescope.nvim'
  "Incorporating fzf into telescope using plenary's job writer functionality
  Plug 'nvim-telescope/telescope-fzf-writer.nvim'
  " FZY style sorter that is compiled
  Plug 'nvim-telescope/telescope-fzy-native.nvim'
  Plug 'nvim-telescope/telescope-github.nvim'
  Plug 'nvim-telescope/telescope-dap.nvim'
  Plug 'onsails/lspkind-nvim'
  " Plugin to work with GitHub issues and PRs from Neovim.
  if executable('gh')
    Plug 'pwntester/octo.nvim'
  endif
  Plug 'akinsho/nvim-toggleterm.lua'
  " Neovim treesitter integration with the Angular framework.
  "Plug 'nvim-treesitter/nvim-treesitter-angular'
  "Collection of common configurations for the Nvim LSP client.
  Plug 'neovim/nvim-lspconfig'
  "A Debug Adapter Protocol client implementation for Neovim (>= 0.5)
  Plug 'mfussenegger/nvim-dap'
  "" A high-performance color highlighter for Neovim which has no external dependencies! Written in performant Luajit.
  ""set termguicolors     " enable true colors support
  ""Plug 'norcalli/nvim-colorizer.lua'
  "" Utility to perform actions like go-to-definition, code-quickfix, etc
  "" or nvim-diagnostic
  " Plug 'RishabhRD/nvim-lsputils'
  " Plug 'RishabhRD/popfix'
  ""Refactor modules for nvim-treesitter
  Plug 'nvim-treesitter/nvim-treesitter-refactor'
  "" LSP Extensions
  "Plug 'nvim-lua/lsp_extensions.nvim'
  "View treesitter information directly in Neovim
  Plug 'nvim-treesitter/playground'
  "Create your own textobjects using tree-sitter queries!
  Plug 'Aerex/nvim-treesitter-textobjects'
  ""A context.vim clone using treesitter
  "Plug 'vigoux/treesitter-context.nvim'
  ""An auto completion framework that aims to provide a better completion experience with neovim's built-in LSP.
"  Plug 'nvim-lua/completion-nvim'
  Plug 'hrsh7th/nvim-compe'
  Plug 'ray-x/lsp_signature.nvim'
  "" A wrapper for neovim built in LSP diagnosis config
  "" or nvim-lsputils
  "@deprecated built in current master
  "Plug 'nvim-lua/diagnostic-nvim'
  Plug 'kristijanhusak/vim-dadbod-ui'
  Plug 'tpope/vim-dadbod'
  Plug 'kristijanhusak/vim-dadbod-completion'
  Plug 'TimUntersberger/neogit'

endif
"}}}
" A live Lisp REPL
"Plug 'jpalardy/vim-slime'
Plug 'chrisbra/csv.vim'
Plug 'chriskempson/base16-vim'
" This plugins make it easier to rename a vim tab
Plug 'gcmt/taboo.vim'
" This plugin adds support for searching, saving, and deleting Vim sessions with fzf.vim.
Plug 'dominickng/fzf-session.vim'
"A document generator which will generate a proper documentation skeleton based on certain expressions (mainly functions)
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
" Visually select increasingly larger regions of text using the same key combination.
Plug 'terryma/vim-expand-region'
" Allows you to use <Tab> for all your insert completion needs
"Plug 'ervandew/supertab'
" Vim folding for PHP functions and/or classes, properties with their phpdoc
" Plug 'rayburgemeestre/phpfolding.vim', { 'for': ['php'] }
" Add icons to your vim

Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'
"Vim plugin for developers fighting against conflicts.
"All features are available if and only if an opened buffer contains a conflict marker.
"Plug 'rhysd/conflict-marker.vim'
" A note-taking app where searching for a note and creating one are the same operation using FZF
if executable('rg')
  Plug 'alok/notational-fzf-vim'
endif
"FIXME: Check documentation to configure
"Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release', 'do': ':UpdateRemotePlugins' }
"Vim sugar for the UNIX shell commands that need it the most.
Plug 'tpope/vim-eunuch'
" Plugin for lining up text
Plug 'godlygeek/tabular'
" Plugin to help send requests to and display responses from RESTful services in Vim.
Plug 'diepm/vim-rest-console'
" Plugin to format based on filetype
Plug 'Chiel92/vim-autoformat'
Plug 'vifm/vifm.vim'
" Open a Quickfix item in a window you choose
Plug 'yssl/QFEnter'
" Enable repeating supported plugin maps with \"."
Plug 'tpope/vim-repeat'
Plug 'junegunn/vim-easy-align'
"Plug 'sheerun/vim-polyglot'
Plug 'christoomey/vim-tmux-navigator'
Plug 'mileszs/ack.vim'
if executable('node') && !has('nvim-0.5')
  Plug 'neoclide/coc.nvim', {'do': 'npm install --frozen-lockfile'}
endif
Plug 'gu-fan/riv.vim' , {'for': ['rst'] }
Plug 'tpope/vim-commentary'
Plug 'itchyny/lightline.vim'
Plug 'nanotech/jellybeans.vim' "Load colorschemes
"Plug 'tpope/vim-surround'
" Better version of vim-surround
Plug 'machakann/vim-sandwich'
Plug 'tpope/vim-fugitive' " Git fugitive
"Plug 'gregsexton/gitv', {'on': ['Gitv']}
Plug 'vim-scripts/YankRing.vim'
Plug 'bfredl/nvim-miniyank'
Plug 'tpope/vim-dispatch'
"Plug 'pedrosans/vim-misc'
"Plug 'luochen1990/rainbow'
Plug 'w0rp/ale', { 'for': ['javascript']}
Plug 'ledger/vim-ledger', { 'for': ['ledger'] }
Plug 'mildred/vim-ledger-mode', { 'for': ['ledger'] }

let g:loaded_ultisnips = 0
if (has('python3'))
  Plug 'SirVer/ultisnips'
  let g:loaded_ultisnips = 1
endif
Plug 'honza/vim-snippets'
Plug 'janko-m/vim-test'
"Plug 'puremourning/vimspector'
Plug 'haya14busa/incsearch.vim'
"Plug 'ludovicchabant/vim-gutentags'
"Plug 'airblade/vim-gitgutter'
if executable('node')
  "Plug 'blindFS/vim-taskwarrior'
endif
Plug 'vimwiki/vimwiki'
Plug 'moll/vim-bbye'
" Doesn't work with tasks dependencies
" @see https://github.com/tools-life/taskwiki/issues/75
"Plug 'tools-life/taskwiki'
Plug 'tweekmonster/startuptime.vim'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-abolish'
Plug 'hashivim/vim-terraform', { 'for': ['ts'] }
Plug 'tpope/vim-rhubarb'
Plug 'kshenoy/vim-signature'
Plug 'dhruvasagar/vim-table-mode'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-jdaddy'
Plug 'haya14busa/incsearch-easymotion.vim'
if executable('w3m')
  Plug 'yuratomo/w3m.vim'
endif
if OS == 'Darwin'
  "Plug 'editorconfig/editorconfig-vim'
  "Plug 'paulkass/jira-vim', { 'do': 'pip install -r requirements.txt' }
endif

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug', 'vimwiki']}
"}}}
" ================ Plugin / Setting Configuration  ======================= {{{1
so ~/.config/nvim/settings.vim


call plug#end()

" Use vim-surround mapping for wim-sandwich (don't override s key in normal mode)
runtime macros/sandwich/keymap/surround.vim
" ================ Colors  =============================================== {{{1
"colorscheme jellybeans
colorscheme base16-nord


if g:colors_name == 'base16-nord'
  hi! DiffRemoved guifg=#BF616A
  hi! DiffAdded guifg=#88C0D0
  hi! DiffChange guifg=#A3BE8C
endif

let g:indent_blankline_filetype_exclude = ['help', 'vimwiki', 'man', 'dashboard', 'TelescopePrompt', 'conf']

highlight! Normal ctermbg=NONE guibg=NONE
if has("termguicolors")
    set t_8f=\[[38;2;%lu;%lu;%lum
    set t_8b=\[[48;2;%lu;%lu;%lum
    set termguicolors
    " Default value: ['ctermbg']
    let g:seiya_target_groups = has('nvim') ? ['guibg'] : ['ctermbg']

  " Enable transparency in colorscheme
   highlight! LineNr ctermfg=grey guibg=NONE guifg=white
 if exists('g:loaded_Signature')
    highlight SignatureMarkText guibg=None
  endif
endif

if has('nvim-0.5')
  luafile ~/.config/nvim/lua/init.lua
endif
" vim: nowrap fdm=marker tw=190
