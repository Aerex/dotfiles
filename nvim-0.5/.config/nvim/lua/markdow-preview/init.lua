require'mapper'.add({
  n = {
    markdown = {
      ['<C-s>'] = 'MarkdownPreview',
      ['<M-s>'] = 'MarkdownPreviewStop',
      ['<C-p>'] = 'MarkdownPreviewToggle',
    }
  }
})
--vim.api.nvim_exec([[
--  autocmd FileType markdown nmap    <silent><C-s>               <cmd>MarkdownPreview<CR>
--  autocmd FileType markdown nmap    <silent><M-s>               <cmd>MarkdownPreviewStop<CR>
--  autocmd FileType markdown nmap    <silent><C-p>               <cmd>MarkdownPreviewToggle<CR>
--]], '')
