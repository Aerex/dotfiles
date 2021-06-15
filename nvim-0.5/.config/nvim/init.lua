-- install packer.nvim automatically
--local execute = vim.api.nvim_command
--local install_path = vim.fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
--if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
--	execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
--	execute 'packadd packer.nvim'
--end
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
vim.bo.shiftwidth     = 2
vim.bo.softtabstop    = 2
vim.bo.tabstop        = 2
vim.bo.expandtab      = true
vim.o.undodir         = os.getenv('HOME') .. '/.cache/nvim/undodir/'
vim.bo.undofile       = true
vim.o.undofile        = true
vim.o.hidden          = true
vim.o.clipboard =  vim.o.clipboard .. 'unnamedplus' -- use clipboard on everything

vim.cmd('autocmd FileType * setlocal formatoptions-=r formatoptions-=o')

--buffers
vim.cmd('autocmd VimResized * :wincmd =')
vim.o.splitright = true

-- colors
vim.cmd('syntax on')

vim.cmd('colorscheme base16-nord')
vim.g.seiya_auto_enable = 1
vim.g.seiya_target_groups = vim.fn.has('nvim') == 1 and {'guibg'} or {'ctermbg'}

vim.g.vifm_embed_split = true

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


