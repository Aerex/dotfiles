--  _   _ _____ _____     _____ __  __
-- | \ | | ____/ _ \ \   / /_ _|  \/  |
-- | |\  | |__| |_| |\ V /  | || |  | |
-- |_| \_|_____\___/  \_/  |___|_|  |_|
--
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
vim.o.timeoutlen      = 500
vim.o.foldmethod      = vim.bo.filetype == 'python' and 'indent' or 'syntax'
vim.o.foldlevel       = 5
vim.o.signcolumn      = "auto:2"

-- autocommands
vim.cmd('autocmd FileType * setlocal formatoptions-=r formatoptions-=o')
vim.cmd('autocmd VimResized * :wincmd =')
vim.cmd('autocmd BufEnter qutebrowser-editor* set spell wrap')
vim.cmd('autocmd FileType trans set keywordprg=trans\\ -no-ansi\\ ja: ')

--buffers
vim.o.splitright = true

--- colors
vim.cmd('hi rainbowcol7 guifg=#D8DEE9')
vim.cmd[[hi GitGutterAdd guifg=#4ca64c guibg=none]]
vim.cmd[[hi GitSignAdd guifg=#4ca64c guibg=none]]
vim.cmd[[hi DiffAdd guifg=#4ca64c guibg=none]]
vim.cmd[[hi SpellBad guibg=#FF0000]]
vim.cmd[[hi DiffAdded guifg=#4ca64c guibg=none]]
vim.cmd[[hi DiffRemoved guifg=#BF616A guibg=none]]
vim.cmd[[hi Folded guifg=#D8DEE9]]
vim.cmd[[hi SignatureMarkText guifg=#ffa500]]
vim.cmd[[hi LineNr guifg=None]]
vim.cmd[[hi SignColumn guifg=None]]

vim.cmd('autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"')
-- FIXME: Workaround for enabling synax
--vim.cmd('autocmd BufEnter * :syntax on')

-- misc
vim.g.vifm_embed_split = true
vim.g.notes_dir = '~/Documents/repos/.private/notes'
vim.g.surround_mappings_style = 'surround'
vim.g.miniyank_filename = vim.fn.stdpath('cache') .. '/.miniyank.mpack'

-- Remove trailing spaces after saving for certain file types
vim.api.nvim_exec([[autocmd BufWritePre *.php,*.lua,*.md,*.go %s/\s\+$//e ]], '')

-- load plugins
require('load_plugins')
require('mappings')
require('colors')

local ok, _ = pcall(require, 'local')
if ok then
  vim.api.nvim_exec([[autocmd BufEnter *.go lua set_local_config()]], '')
end
