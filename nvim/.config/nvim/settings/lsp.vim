let g:diagnostic_enable_virtual_text = 0
let g:diagnostic_auto_popup_while_jump = 1
function! NvimLspKeyMapping()
    nnoremap <buffer><silent> <leader>rn                                                          <cmd>lua vim.lsp.buf.rename()<CR>
    nnoremap <silent> gd                                                                          <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <buffer><silent> gr                                                                  <cmd>lua vim.lsp.buf.references()<CR>
    nnoremap <silent> <c-]>                                                                       <cmd>lua vim.lsp.buf.declaration()<CR>
    nnoremap <buffer><silent> gD                                                                  <cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap <buffer><silent> gt                                                                  <cmd>lua vim.lsp.buf.type_definition()<CR>
    nnoremap <buffer><silent> 1gD                                                                  <cmd>lua vim.lsp.buf.type_definition()<CR>
    nnoremap <buffer> <silent> <c-LeftMouse>                                                      <cmd>lua vim.lsp.buf.definition()<CR>
    "Displays hover information about the symbol under the cursor in a floating window.
    "Calling the function twice will jump into the floating window.
    nnoremap <buffer><silent> K                                                                   <cmd>lua vim.lsp.buf.hover()<CR>
    "Lists all the call sites of the symbol under the cursor in the quickfix window.
    "FIXME: Does not work for...
    " php
    nnoremap <buffer><silent> <leader>ic                                                          <cmd>lua vim.lsp.buf.incoming_calls()<CR>
    "Lists all the items that are called by the symbol under the cursor in the quickfix window.
    "FIXME: Does not work for...
    " php
    vnoremap <buffer><silent> <leader>oc                                                          <cmd>lua vim.lsp.buf.outgoing_calls()<CR>
    "Lists all symbols in the current buffer in the quickfix
    nnoremap <buffer><silent> <leader>O                                                           <cmd>lua vim.lsp.buf.document_symbol()<CR>
    nnoremap <buffer><silent> g0                                                                  <cmd>lua vim.lsp.buf.document_symbol()<CR>
    "Selects a code action from the input list that is available at the current cursor position.
    nnoremap <buffer><silent> <c-i>                                                                <cmd>lua vim.lsp.buf.code_action()<CR>
    "Displays signature information about the symbol under the cursor in a floating window.
    inoremap <buffer><silent> <c-k>                                                               <cmd>lua vim.lsp.buf.signature_help()<CR>
    " nnoremap <buffer><silent> <leader>de :lua require'lsp-extensions'.peek_definition()<cr>
    " nmap <buffer> <silent> gD  <c-w>vgd
    nnoremap <buffer><silent> gW                                                          <cmd>lua vim.lsp.buf.workspace_symbol()<cr>
    nnoremap <buffer> <silent> <c-LeftMouse>                                                      <cmd>lua require'nvim-treesitter-refactor.navigation'.goto_definition_lsp_fallback()<CR>
    nnoremap <buffer> <silent> <leader>ld                                                         <cmd>lua vim.lsp.util.show_line_diagnostics()<cr>

    if &filetype != "tex" 
        inoremap <buffer><silent> (     <cmd>lua vim.lsp.buf.signature_help()<CR>(
    endif


    if &filetype == "java" 
        nnoremap <buffer><silent> <c-s> :w<cr><cmd>lua vim.lsp.buf.formatting();require'jdtls'.organize_imports()<cr>
    elseif &filetype == "lua" 

    else 
        nnoremap <buffer><silent> <c-s> :w<cr><cmd>lua vim.lsp.buf.formatting()<cr>
    endif
    setlocal omnifunc=v:lua.vim.lsp.omnifunc
endfunction
