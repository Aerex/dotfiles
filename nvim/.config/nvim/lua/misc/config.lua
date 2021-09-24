local set_keymap = vim.api.nvim_set_keymap
local g = vim.g

-- VRC {{{1
vim.g.vrc_curl_opts = {
  ['--insecure'] = '',
  ['-i'] = ''
}
vim.g.vrc_set_default_mapping = 0
vim.api.nvim_exec([[
  au FileType rest nnoremap <leader>e   <cmd>call VrcQuery() <CR>
  ]],'')
---}}}

--- FZF {{{1
vim.g.nv_search_paths = {'~/Documents/notes'}
vim.api.nvim_set_keymap('n', '<Leader>N', ':NV<CR>', { noremap = true, silent = true })
--- FZF {{{2
g.nv_keymap = {
  ['ctrl-x'] = 'split ',
  ['ctrl-v'] = 'vertical split ',
  ['ctrl-t'] = 'tabedit '
}
g.nv_create_note_key = 'ctrl-w'
---}}}
---}}}
