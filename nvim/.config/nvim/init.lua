--  _   _ _____ _____     _____ __  __
-- | \ | | ____/ _ \ \   / /_ _|  \/  |
-- | |\  | |__| |_| |\ V /  | || |  | |
-- |_| \_|_____\___/  \_/  |___|_|  |_|
--
-- config options
require('options')
local autocmd = require('utils').autocmd

--vim.cmd('autocmd FileType * setlocal formatoptions-=r formatoptions-=o')
autocmd('VimResized', {
  pattern = '*',
  command = 'wincmd ='
})
autocmd('VimEnter', {
  pattern = '*',
  callback = function()
    vim.fn.system('kill -s SIGWINCH $PPID')
  end
})
--vim.cmd('autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"')

--vim.cmd('autocmd VimResized * :wincmd =')
-- FIXME(me): Figure out why set spell is being enabled in all buffers
--vim.cmd('autocmd BufEnter qutebrowser-editor* set spell wrap')
--vim.cmd('autocmd FileType trans set keywordprg=trans\\ -no-ansi\\ ja: ')
vim.o.grepprg="rg --vimgrep --no-heading --smart-case"
vim.o.grepformat="%f:%l:%c:%m"

--buffers
vim.o.splitright = true
vim.g.seiya_auto_enable = 1
vim.g.seiya_target_groups = vim.fn.has('nvim') == 1 and {'guibg'} or {'ctermbg'}
vim.cmd('hi rainbowcol7 guifg=#D8DEE9')
--vim.cmd[[hi GitGutterAdd guifg=#4ca64c guibg=none]]
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

-- misc
vim.g.vifm_embed_split = true
vim.g.notes_dir = '~/Documents/repos/.private/notes'
vim.g.surround_mappings_style = 'surround'
vim.g.miniyank_filename = vim.fn.stdpath('cache') .. '/.miniyank.mpack'

-- Remove trailing spaces after saving for certain file types
vim.api.nvim_exec([[autocmd BufWritePre *.php,*.lua,*.md,*.go %s/\s\+$//e ]], '')
-- Enable spell on markdown and vimwiki filetypes
vim.api.nvim_exec([[autocmd BufEnter * if matchstr(&filetype, '\(markdown\)\|\(vimwiki\)') | set spell | endif ]], '')

-- load plugins
require('plugins')
require('mappings')
require('colors').setup()

vim.api.nvim_create_autocmd('VimEnter', {
  pattern = {'*'},
  command = 'syntax on',
})

local ok, _ = pcall(require, 'nvim-local')
if ok then
  -- NOTE(me): Find a better event to fire this function
  vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
    pattern =  {'*.go', '*.feature', '*.ts', '*.java'},
    callback = function()
      set_local_config()
    end
  })
end

local ok_v, notify = pcall(require, 'notify')
if ok_v then
  -- set vim-notify to handle notifications
  vim.notify = notify
end

vim.ui.select = require'nvim-fzf.uiselect'
