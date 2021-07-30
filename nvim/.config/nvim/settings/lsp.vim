let g:db_ui_winwidth = 40
let g:db_ui_use_nerd_fonts = 1
let g:db_ui_show_database_icon = 1
let g:db_ui_show_help = 0
let g:db_ui_auto_execute_table_helpers = 1
let g:db_ui_execute_on_save = 0
let g:db_async = 1
" let g:completion_auto_change_source = 1

"imap  <c-j> <Plug>(completion_next_source)
"imap  <c-k> <Plug>(completion_prev_source)

"imap <tab> <Plug>(completion_smart_tab)
"imap <s-tab> <Plug>(completion_smart_s_tab)
" let g:lsc_server_commands = {
"   \ 'php': {
"   \    'command': 'intelephense --stdio',
"   \    'message_hooks': {
"   \        'initialize': {
"   \            'initializationOptions': {
"   \                 'storagePath': '/tmp/intelephense',
"   \                  'licenceKey': '0002LT9FKR8PD8H',
"   \                  'clearCache': 1
"   \            },
"   \        },
"   \        'workspace_config': {
"   \             'intelephense.files.exclude': ['**/node_modules/**']
"   \        },
"   \    },
"   \ },
"   \ }
" let g:completion_enable_snippet = 'UltiSnips'
" let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
" if (has('nvim-0.5'))
" endif

autocmd FileType php let g:completion_trigger_character = ['$', '->', '::']
let g:completion_enable_auto_hover = 0

function! NvimLspKeyMapping()
    "nnoremap <silent> <leader>p                                                                  <cmd> lua require('telescope.builtin').git_files(require('telescope.themes').get_dropdown{ prompt_prefix = 'GitFiles>', set_env = {} })<CR>
    nnoremap <silent> <leader>Gs                                                                 <cmd> lua require('neogit').open({ kind = 'split' })<CR>
    nnoremap <silent> <leader>,p                                                                 <cmd> lua require('telescope.builtin').find_files()<CR>
    nnoremap <silent> <leader>ag                                                                 <cmd> lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
    noremap <silent> <leader>rg                                                                  <cmd> lua require('telescope').extensions.fzf_writer.staged_grep()<CR>
    noremap <silent> <leader>b                                                                   <cmd> Telescope buffers<CR>

    nnoremap <silent> <leader>lof                                                                <cmd> lua require'telescope.builtin'.oldfiles{}<CR>
    nnoremap <silent> <leader>lL                                                                 <cmd> lua print(vim.lsp.get_log_path())<CR>
    nnoremap <silent> <leader>lht                                                                <cmd> lua require'telescope.builtin'.help_tags{}<CR>
    nnoremap <buffer><silent> <leader>rn                                                         <cmd> lua vim.lsp.buf.rename()<CR>
    nnoremap <silent> gd                                                                         <cmd> lua vim.lsp.buf.declaration()<CR>
    nnoremap <silent><leader>M                                                                   <cmd> lua require('telescope.builtin').keymaps()<CR>
    nnoremap <buffer><silent> gr                                                                 <cmd> Telescope lsp_references<CR>
    nnoremap <buffer><silent> xr                                                                 <cmd> Trouble lsp_references<CR>
    nnoremap <silent> <c-]>                                                                      <cmd> lua vim.lsp.buf.definition()<CR>
    nnoremap <buffer><silent> gi                                                                 <cmd> Trouble lsp_implementations<CR>
    nnoremap <buffer><silent> gt                                                                 <cmd> lua vim.lsp.buf.type_definition()<CR>
    nnoremap <buffer><silent> 1gD                                                                <cmd> lua vim.lsp.buf.type_definition()<CR>
    nnoremap <buffer><silent> <leader>lgc                                                        <cmd> lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>
    nnoremap <buffer> <silent> <c-LeftMouse>                                                     <cmd> lua vim.lsp.buf.definition()<CR>
    nnoremap <silent> qf                                                                         <cmd> lua require'telescope.builtin'.quickfix()<CR>
    "Displays hover information about the symbol under the cursor in a floating window.
    "Calling the function twice will jump into the floating window.
    nnoremap <buffer><silent> K                                                                  <cmd> call <SID>show_documentation()<CR>
    "Lists all the call sites of the symbol under the cursor in the quickfix window.
    "FIXME: Does not work for...
    " php
    nnoremap <buffer><silent> <leader>ic                                                         <cmd> lua vim.lsp.buf.incoming_calls()<CR>
    "Lists all the items that are called by the symbol under the cursor in the quickfix window.
    "FIXME: Does not work for...
    " php
    vnoremap <buffer><silent> <leader>oc                                                         <cmd> lua vim.lsp.buf.outgoing_calls()<CR>
    "Lists all symbols in the current buffer in the quickfix
    nnoremap <buffer><silent> <leader>O                                                          <cmd> lua require'telescope.builtin'.lsp_document_symbols{}<CR>
    nnoremap <buffer><silent> g0                                                                 <cmd> lua require'telescope.builtin'.lsp_document_symbols{}<CR>
    "Selects a code action from the input list that is available at the current cursor position.
    nnoremap <buffer><silent> <M-i>                                                              <cmd> Lspsaga code_action<CR>
    vnoremap <buffer><silent> <M-i>                                                              <cmd> Lspsaga range_code_action<CR>
    "Displays signature information about the symbol under the cursor in a floating window.
    inoremap <buffer><silent> <c-k>                                                              <cmd> lua vim.lsp.buf.signature_help()<CR>
    " nnoremap <buffer><silent> <leader>de :lua require'lsp-extensions'.peek_definition()<cr>
    " nmap <buffer> <silent> gD  <c-w>vgd
    nnoremap <buffer><silent> gW                                                                 <cmd> lua vim.lsp.buf.workspace_symbol()<cr>
    nnoremap <buffer> <silent> <c-LeftMouse>                                                     <cmd> lua require'nvim-treesitter-refactor.navigation'.goto_definition_lsp_fallback()<CR>
    nnoremap <buffer> <silent> <leader>ld                                                        <cmd> Trouble lsp_document_diagnostics<CR>
    nnoremap <buffer> <silent> <leader>lD                                                        <cmd> Trouble lsp_workspace_diagnostics<CR>

    nnoremap <buffer> <silent> <leader>lb                                                        <cmd> lua require('telescope.builtin').buffers()<CR>
    " nnoremap <buffer> <silent> <F9>                                                              <cmd> lua require('dap').toggle_breakpoint()<CR>
    " nnoremap <buffer> <silent> <F10>                                                             <cmd> lua require'dap'.step_over()<CR>
    " nnoremap <buffer> <silent> <F5>                                                              <cmd> lua require('dap').continue()<CR>
    nnoremap <silent> ]d                                                                         <cmd> lua vim.lsp.diagnostic.goto_next()<CR>
    nnoremap <silent> [d                                                                         <cmd> lua vim.lsp.diagnostic.goto_prev()<CR>
    "scroll up hover doc
    nnoremap <silent> <C-f>                                                                      <cmd> lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
    "scroll down hover doc or scroll in definition preview (Doesn't override
    "Ldefault behavior
    nnoremap <silent> <C-b>                                                                      <cmd> lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>

    nnoremap <buffer><silent> <leader>lr                                                         <cmd> call ReloadLSP()<CR>

    function! ReloadLSP()
      lua vim.lsp.stop_client(vim.lsp.get_active_clients())
      edit
    endfunction

    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      else
        if exists('g:loaded_lspsaga')
          execute 'Lspsaga hover_doc'
        else
          lua vim.lsp.buf.hover()
        endif
      endif
    endfunction

    " let g:telescope_cache_results = 1
    " let g:telescope_prime_fuzzy_find  = 1

    if &filetype == "java"
        nnoremap <buffer><silent> <c-s> :w<cr><cmd>lua vim.lsp.buf.formatting();require'jdtls'.organize_imports()<cr>
    elseif &filetype == "lua"
    else
        nnoremap <buffer><silent> <c-s> :w<cr><cmd>lua vim.lsp.buf.formatting()<cr>
    endif
    if &filetype == 'sql'
      let g:completion_trigger_character = ['.', '"', '`', '[']
    endif
    if &filetype == "markdown"
        nnoremap <buffer><silent> B <cmd>MarkdownPreview<CR>
    endif
    if &filetype == 'php'
      set iskeyword+=$
    endif
    setlocal omnifunc=v:lua.vim.lsp.omnifunc

    command! TreeGrep  :lua require'telescope.builtin'.treesitter()<cr>
endfunction
