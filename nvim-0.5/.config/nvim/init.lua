-- config options
vim.o.relativenumber  = true
vim.wo.relativenumber = true
vim.o.swapfile        = false
vim.bo.swapfile       = false
vim.o.number          = true
vim.wo.number         = true
vim.o.history         = 1000
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
vim.o.undodir         = os.getenv('HOME') .. '/.cache/nvim/undodir/'
vim.bo.undofile       = true
vim.o.undofile        = true
vim.o.hidden          = true
vim.o.clipboard       = vim.o.clipboard .. 'unnamedplus' -- use clipboard on everything
vim.o.showmode        = true
vim.o.autoread        = true

--
vim.cmd('autocmd FileType * setlocal formatoptions-=r formatoptions-=o')
vim.cmd('autocmd VimResized * :wincmd =')
--
----buffers
vim.o.splitright = true
--
---- colors
-- TODO: Find lua vim colorscheme and syntaxequivalent
vim.cmd('syntax on')
vim.cmd('colorscheme base16-nord')
vim.g.seiya_auto_enable = 1
vim.g.seiya_target_groups = vim.fn.has('nvim') == 1 and {'guibg'} or {'ctermbg'}
vim.g.vifm_embed_split = true

vim.g.notes_dir = '~/Documents/repos/.private/notes'
vim.g.surround_mappings_style = 'surround'
-- Remove trailing spaces after saving
--vim.api.nvim_exec([[
--  autocmd BufWritePre * :%s/\s\+$//e)
--]], '')


-- load plugins
require('load_plugins')
require('mappings')
require('snippets')
-- TODO: Find a cleaner way to load plugin configs
require('nvim-completion')
require('nvim-lsp')
require('nvim-git')
require('statusline')
