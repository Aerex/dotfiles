-- config options
vim.o.relativenumber  = true
vim.wo.relativenumber = true
vim.o.swapfile        = false
vim.bo.swapfile       = false
vim.o.number          = true
vim.wo.number         = true
vim.o.history         = 999
vim.o.termguicolors   = true
vim.o.laststatus      = 2
vim.g.mapleader       = ' '
vim.o.shiftwidth      = 2
vim.bo.shiftwidth     = 2
vim.o.softtabstop     = 2
vim.bo.softtabstop    = 2
vim.o.tabstop         = 2
vim.bo.tabstop        = 2
vim.o.expandtab       = true
vim.bo.expandtab      = true
vim.o.undodir         = vim.fn.stdpath('cache') .. '/undodir/'
vim.bo.undofile       = true
vim.o.undofile        = true
vim.o.hidden          = true
vim.o.clipboard       = vim.o.clipboard .. 'unnamedplus' -- use clipboard on everything
vim.o.showmode        = true
vim.o.autoread        = true

-- autocommands
vim.cmd('autocmd FileType * setlocal formatoptions-=r formatoptions-=o')
vim.cmd('autocmd VimResized * :wincmd =')

--buffers
vim.o.splitright = true

--- colors
vim.cmd('syntax on')
vim.cmd('colorscheme base16-nord')
vim.g.seiya_auto_enable = 1
vim.g.seiya_target_groups = vim.fn.has('nvim') == 1 and {'guibg'} or {'ctermbg'}
vim.cmd('hi rainbowcol7 guifg=#D8DEE9')
-- misc
vim.g.vifm_embed_split = true
vim.g.notes_dir = '~/Documents/repos/.private/notes'
vim.g.surround_mappings_style = 'surround'
vim.g.miniyank_filename = vim.fn.stdpath('cache') .. '/.miniyank.mpack'

-- Remove trailing spaces after saving for certain file types
vim.api.nvim_exec([[autocmd BufWritePre *.php,*.lua,*.md %s/\s\+$//e ]], '')

-- load plugins
require('load_plugins')
require('mappings')
