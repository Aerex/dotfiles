local api = vim.api
local autocmd = require('utils').autocmd


local create_group = function(name)
  return api.nvim_create_augroup(name, { clear = true })
end

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

autocmd('TermOpen', {
  pattern = '*toggleterm#*',
  callback = function()
    local terminal, okt = pcall(require, 'terminals')
    if okt then
      terminal.set_terminal_keymaps()
    end
  end
})
