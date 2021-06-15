vim.o.shortmess                         = vim.o.shortmess .. 'c'
vim.g.completion_matching_smart_case    = 1
vim.g.completion_auto_change_source     = 1
vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}
vim.g.completion_enable_snippet         = 'UltiSnips'
vim.g.completion_trigger_keyword_length = 3
vim.o.completeopt                       = 'menuone,noinsert'
vim.g.completion_enable_auto_popup      = 1
vim.g.completion_enable_auto_hover      = 1
vim.g.completion_confirm_key 		= '<Enter>'
vim.api.nvim_set_keymap('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
vim.api.nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', {expr = true})
vim.api.nvim_set_keymap('i', '<CR>', 'pumvisible() ? "\\<Plug>(completion_confirm_compeltion)" : "\\<CR>"', {expr = true})
vim.g.completion_chain_complete_list = {
	{complete_items = {'lsp', 'snippet'}},
	{ mode = '<c-p>'},
        { mode = '<c-n>'}
}

