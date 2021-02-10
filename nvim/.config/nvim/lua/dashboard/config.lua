--vim.g.dashboard_executive = 'telescope'
--  \ 'load_dotfiles': {
--      \ 'description': ['  Open dotfiles         SPC f d'],
--      \ 'command': 
---- vim.g.dashboard_custom_selection = {
--   ['load_dotfiles'] = {
--     ['description'] = ['

--   }
-- }
-- SPC means leaderkey
vim.g.dashboard_default_executive = 'telescope'
vim.g.dashboard_custom_shortcut = {
  ['last_session']       = 'SPC s l',
  ['find_history']       = 'SPC f h',
  ['find_file']          = 'SPC f f',
  ['new_file']           = 'SPC c n',
  ['change_colorscheme'] = 'SPC t c',
  ['find_word']          = 'SPC f a',
  ['book_marks']         = 'SPC f b'
}

vim.g.dashboard_custom_shortcut_icon = {
  ['last_session'] = ' ',
  ['find_history'] = 'ﭯ ',
  ['find_file'] = ' ',
  ['new_file'] = ' ',
  ['change_colorscheme'] = ' ',
  ['find_word'] = ' ',
  ['book_marks'] = ' '
}

vim.g.dashboard_default_executive = 'fzf'
