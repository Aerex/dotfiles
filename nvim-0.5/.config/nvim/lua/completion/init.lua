vim.o.shortmess                         = vim.o.shortmess .. 'c'
vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}
vim.g.completion_enable_snippet         = 'UltiSnips'
vim.g.completion_trigger_keyword_length = 2
vim.o.completeopt                       = 'menuone,noinsert,noselect'

vim.api.nvim_set_keymap('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
vim.api.nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', {expr = true})
