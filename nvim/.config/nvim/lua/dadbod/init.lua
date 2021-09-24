local g = vim.g
local buffer_options = vim.bo
local cmd = vim.cmd

g.db_ui_winwidth = 40
g.db_ui_use_nerd_fonts = 1
g.db_ui_show_database_icon = 1
g.db_ui_auto_execute_table_helpers = 1
g.db_ui_execute_on_save = 0
g.db_ui_show_help = 0
g.db_async = 1

if buffer_options.filetype == 'sql' then
  cmd [[
  nmap <leader>Q <Plug>(DBUI_ExecuteQuery)<CR>
  nmap <leader>S <Plug>(DBUI_SaveQuery)<CR>
  nmap <leader>B <cmd>DBUIToggle<CR>
  nmap <leader>L <cmd>DBLastQueryInfo<CR>
  ]]
end

