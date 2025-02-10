--  _   _ _____ _____     _____ __  __
-- | \ | | ____/ _ \ \   / /_ _|  \/  |
-- | |\  | |__| |_| |\ V /  | || |  | |
-- |_| \_|_____\___/  \_/  |___|_|  |_|
--
-- config options
require('config.options')
require('config.mappings')
local autocmd = require('utils').autocmd
vim.loader.enable()

if vim.fn.executable('rg') then
  vim.o.grepprg = "rg --vimgrep --no-heading --smart-case"

  vim.o.grepformat = "%f:%l:%c:%m"
end

if vim.fn.executable('ug') then
  vim.o.grepprg = 'ugrep -RInk -j -u --tabs=1 --ignore-files'
  vim.o.grepformat = '%f:%l:%c:%m,%f+%l+%c+%m,%-G%f\\|%l\\|%c\\|%m'
end

--buffers
vim.g.seiya_auto_enable = 1
vim.g.seiya_target_groups = vim.fn.has('nvim') == 1 and { 'guibg' } or { 'ctermbg' }
-- vim.cmd('hi rainbowcol7 guifg=#D8DEE9')
--vim.cmd[[hi GitGutterAdd guifg=#4ca64c guibg=none]]
-- vim.cmd [[hi GitSignAdd guifg=#4ca64c guibg=none]]
-- vim.cmd [[hi DiffAdd guifg=#4ca64c guibg=none]]
-- vim.cmd [[hi SpellBad guibg=#FF0000]]
-- vim.cmd [[hi DiffAdded guifg=#4ca64c guibg=none]]
-- vim.cmd [[hi DiffRemoved guifg=#BF616A guibg=none]]
-- vim.cmd [[hi Folded guifg=#D8DEE9]]
-- vim.cmd [[hi SignatureMarkText guifg=#ffa500]]
-- vim.cmd [[hi LineNr guifg=None]]
-- vim.cmd [[hi SignColumn guifg=None]]

-- vim.cmd('autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"')
autocmd({ 'VimEnter' }, {
  pattern = { '*' },
  callback = function()
    vim.fn.execute('!kill -s SIGWINCH $PPID', 'silent')
  end
})

-- misc
vim.g.vifm_embed_split = true
vim.g.notes_dir = '~/Documents/repos/.private/notes'
vim.g.surround_mappings_style = 'surround'

-- Enable spell on markdown and vimwiki filetypes
autocmd({ 'BufEnter' }, {
  pattern = { '*' },
  callback = function()
    if vim.tbl_contains({ 'markdown', 'vimwiki' }, vim.o.filetype) then
      vim.cmd [[set spell]]
    end
  end
})
-- vim.api.nvim_exec([[autocmd BufEnter * if matchstr(&filetype, '\(markdown\)\|\(vimwiki\)') | set spell | endif ]], '')

-- load plugins
require('packages')

vim.api.nvim_create_autocmd('VimEnter', {
  pattern = { '*' },
  command = 'syntax on',
})

local ok, nlocal = pcall(require, 'nvim-local')
if ok then
  -- NOTE(me): Find a better event to fire this function
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    pattern = { '*.go', '*.feature', '*.ts', '*.java' },
    callback = function()
      nlocal.setup()
    end
  })
end

local ok_v, notify = pcall(require, 'notify')
if ok_v then
  -- set vim-notify to handle notifications
  vim.notify = notify
end

vim.ui.select = require 'plugins.configs.pickers.fzf.uiselect'
