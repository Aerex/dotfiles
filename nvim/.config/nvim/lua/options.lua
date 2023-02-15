local g = vim.g
local o = vim.o
local bo = vim.bo
local wo = vim.wo
local opt = vim.opt

o.relativenumber  = true
wo.relativenumber = true
o.swapfile        = false
bo.swapfile       = false
o.number          = true
wo.number         = true
o.history         = 999
o.termguicolors   = true
o.laststatus      = 2
g.mapleader       = ' '
o.shiftwidth      = 2
bo.shiftwidth     = 2
o.softtabstop     = 2
bo.softtabstop    = 2
o.tabstop         = 2
bo.tabstop        = 2
o.expandtab       = true
o.dictionary      = "/usr/share/dict/words"
bo.expandtab      = true
o.undodir         = vim.fn.stdpath('cache') .. '/undodir/'
bo.undofile       = true
o.undofile        = true
o.hidden          = true
opt.clipboard:append('unnamedplus')
opt.runtimepath:append('/usr/share/vifm/vim-doc/')
o.showmode        = true
o.autoread        = true
o.timeoutlen      = 100
o.foldmethod      = vim.bo.filetype == 'python' and 'indent' or 'syntax'
o.foldlevel       = 5
wo.signcolumn     = "auto:2"
o.smartindent     = true
opt.spell         = false
opt.spelllang     = { 'en_us' }
g.clipboard = {
  name = 'xsel_override',
  copy = {
    ['+'] = 'xsel --input --clipboard',
    ['*'] = 'xsel --input --primary',
  },
  paste = {
    ['+'] = 'xsel --output --clipboard',
    ['*'] = 'xsel --output --primary',
  },
  cache_enabled = 1,
}

-- disable builtin plugins
g.loaded_gzip = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_2html_plugin = 1
g.loaded_matchit = 1
g.loaded_matchparen = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1
g.loaded_netrwFileHandlers = 1
