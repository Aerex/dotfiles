require'mapper'.add({
    n = {
      all = {
        ['gd']         = 'lua vim.lsp.buf.declaration()',
        ['gt']         = 'lua vim.lsp.buf.definition()',
        ['<leader>K']  = 'lua vim.lsp.buf.hover()',
        ['<leader>rn'] = 'lua vim.lsp.buf.rename()',
        ['gD']         = 'lua vim.lsp.buf.implementation()',
        ['<c-k>']      = 'lua vim.lsp.buf.signature_help()',
        ['1gD']        = 'lua vim.lsp.buf.type_definition()',
        ['gr']         = 'lua vim.lsp.buf.references()',
        ['<leader>1d'] = 'lua vim.lsp.util.show_line_diagnostics()'
      }
    }
})

--noremap('gd', '<cmd>lua vim.lsp.buf.declaration()<cr>')
--noremap('gt', '<cmd>lua vim.lsp.buf.definition()<cr>')
--vim.api.nvim_exec([[
--nnoremap <silent> gd             <cmd>lua vim.lsp.buf.declaration()<CR>
--nnoremap <silent> gt             <cmd>lua vim.lsp.buf.definition()<CR>
--nnoremap <silent> <leader>K      <cmd>lua vim.lsp.buf.hover()<CR>
--nnoremap <silent> <leader>rn     <cmd>lua vim.lsp.buf.rename()<CR>
--nnoremap <silent> gD             <cmd>lua vim.lsp.buf.implementation()<CR>
--nnoremap <silent> <c-k>          <cmd>lua vim.lsp.buf.signature_help()<CR>
--nnoremap <silent> 1gD            <cmd>lua vim.lsp.buf.type_definition()<CR>
--nnoremap <silent> gr             <cmd>lua vim.lsp.buf.references()<CR>
--nnoremap <silent> <leader>ld     <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>
--  ]], '')
