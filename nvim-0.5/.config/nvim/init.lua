-- install packer.nvim automatically
--local execute = vim.api.nvim_command
--local install_path = vim.fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
--if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
--	execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
--	execute 'packadd packer.nvim'
--end
-- config options
vim.o.relativenumber = true
vim.o.number         = true
vim.o.history        = 1000
vim.o.termguicolors  = true
vim.o.laststatus 	   = 2

-- colors
vim.cmd('syntax on')
vim.cmd('colorscheme base16-nord')
vim.g.seiya_auto_enable = 1
vim.g.seiya_target_groups = vim.fn.has('nvim') and {'guibg'} or {'ctermbg'}


vim.api.nvim_set_keymap('n', '<Leader>ue', "<cmd>UltiSnipsEdit<cr>", { noremap = true, silent = true })
-- Remove trailing spaces after saving
vim.api.nvim_exec([[
  autocmd BufWritePre * :%s/\s\+$//e)
]], '')

-- load plugins
require('load_plugins')

-- TODO: Find a cleaner way to load plugin configs
require('lsp')
require('nvim-git')
require('statusline')
require('completion')
