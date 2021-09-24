function M.setup ()
  -- MISC
  vim.api.nvim_exec([[
    nnoremap <silent><leader>N :NV<CR>
  ]], '')
  -- LSP
   vim.api.nvim_exec([[
    nnoremap <silent> gl                                                                         <cmd>lua vim.lsp.buf.declaration()<CR>
    nnoremap <silent> gd                                                                         <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <silent> gr                                                                         <cmd>lua vim.lsp.buf.references()<CR>
    nnoremap <silent> gi                                                                         <cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap <silent> gy                                                                         <cmd>lua vim.lsp.buf.type_definition()<CR>

    nnoremap <silent> <M-i>                                                                      <cmd>lua vim.lsp.buf.code_action()<CR>
    nnoremap <silent> <leader>k                                                                  <cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <silent> <leader>rn                                                                 <cmd>lua vim.lsp.buf.rename()<CR>
    nnoremap <silent> <leader>d                                                                  <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>
    nnoremap <silent> <leader>ca                                                                 <cmd>lua vim.lsp.buf.signature_help()<CR>
    nnoremap <buffer> <silent> <c-LeftMouse>                                                     <cmd>lua require'nvim-treesitter.refactor.navigation'.goto_definition_lsp_fallback()<CR>

    nnoremap <silent> <leader>p                                                                  <cmd>lua require('telescope.builtin').git_files(require('telescope.themes').get_dropdown{ prompt_prefix = 'GitFiles>', set_env = {} })<CR>
    nnoremap <silent> <leader>,p                                                                 <cmd>lua require('telescope.builtin').find_files()<CR>
    nnoremap <silent> <leader>ag                                                                 <cmd>lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
    noremap <silent> <leader>rg                                                                  <cmd>lua require('telescope').extensions.fzf_writer.staged_grep()<CR>
    noremap <silent> <leader>b                                                                   <cmd>Telescope buffers<CR>

    nnoremap <silent> <leader>lof                                                                <cmd>lua require'telescope.builtin'.oldfiles{}<CR>
    nnoremap <silent> <leader>lL                                                                 <cmd>lua print(vim.lsp.get_log_path())<CR>
    nnoremap <silent> <leader>lht                                                                <cmd>lua require'telescope.builtin'.help_tags{}<CR>
    nnoremap <buffer><silent> <leader>rn                                                         <cmd>lua vim.lsp.buf.rename()<CR>
    nnoremap <silent> gd                                                                         <cmd>lua vim.lsp.buf.declaration()<CR>
    nnoremap <silent><leader>M                                                                   <cmd>lua require('telescope.builtin').keymaps()<CR>
    nnoremap <buffer><silent> gr                                                                 <cmd>lua require'telescope.builtin'.lsp_references()<CR>
    nnoremap <silent> <c-]>                                                                      <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <buffer><silent> gi                                                                 <cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap <buffer><silent> gt                                                                 <cmd>lua vim.lsp.buf.type_definition()<CR>
    nnoremap <buffer><silent> 1gD                                                                <cmd>lua vim.lsp.buf.type_definition()<CR>
    nnoremap <buffer><silent> <leader>lgc                                                        <cmd>lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>
    nnoremap <buffer> <silent> <c-LeftMouse>                                                     <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <silent> qf                                                                         <cmd>lua require'telescope.builtin'.quickfix()<CR>
    nnoremap <buffer><silent> K                                                                  <cmd>call <SID>show_documentation()<CR>
    nnoremap <buffer><silent> <leader>ic                                                         <cmd>lua vim.lsp.buf.incoming_calls()<CR>
    vnoremap <buffer><silent> <leader>oc                                                         <cmd>lua vim.lsp.buf.outgoing_calls()<CR>
    nnoremap <buffer><silent> <leader>O                                                          <cmd>lua require'telescope.builtin'.lsp_document_symbols{}<CR>
    nnoremap <buffer><silent> g0                                                                 <cmd>lua require'telescope.builtin'.lsp_document_symbols{}<CR>
    nnoremap <buffer><silent> <M-i>                                                              <cmd>lua vim.lsp.buf.code_action()<CR>
    vnoremap <buffer><silent> <M-i>                                                              <cmd>lua require'telescope.builtin'.lsp_range_code_actions{}<CR>
    inoremap <buffer><silent> <c-k>                                                              <cmd>lua vim.lsp.buf.signature_help()<CR>
    nnoremap <buffer><silent> gW                                                                 <cmd>lua vim.lsp.buf.workspace_symbol()<cr>
    nnoremap <buffer> <silent> <c-LeftMouse>                                                     <cmd>lua require'nvim-treesitter-refactor.navigation'.goto_definition_lsp_fallback()<CR>
    nnoremap <buffer> <silent> <leader>ld                                                        <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>

    nnoremap <buffer> <silent> <leader>lb                                                        <cmd>lua require('telescope.builtin').buffers()<CR>
    nnoremap <buffer> <silent> <F9>                                                              <cmd>lua require('dap').toggle_breakpoint()<CR>
    nnoremap <buffer> <silent> <F10>                                                             <cmd>lua require'dap'.step_over()<CR>
    nnoremap <buffer> <silent> <F5>                                                              <cmd>lua require('dap').continue()<CR>
      ]], '')
end
