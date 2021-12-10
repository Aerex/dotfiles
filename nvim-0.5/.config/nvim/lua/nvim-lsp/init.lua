-- TODO: Need to figure out why requiring modules creates a loop
--local utils = require('nvim-lsp').utils
local lsp_status = require('lsp-status')
local lsp_signature = require('lsp_signature')
local lsp_document_symbol_callback = require('nvim-fzf.lsp').document_symbols
local lsp_references_callback = require('nvim-fzf.lsp').references
local utils = require('nvim-lsp.utils')
--vim.g.completion_enable_auto_popup = 0
-- configure lsp-status
lsp_status.config({
  status_symbol = ''
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}



local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local function keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  local function set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Attach LSP status
 lsp_status.on_attach(client)

 -- Attach LSP Signature
 lsp_signature.on_attach({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    doc_lines = 10, -- only show one line of comment set to 0 if you do not want API comments be shown
    hint_enable = true, -- virtual hint enable
    hint_prefix = ' ',
    hint_scheme = 'String',
    handler_opts = {
      border = 'shadow'   -- double, single, shadow, none
    },
    decorator = {'`', '`'}  -- or decorator = {'***', '***'}  decorator = {'**', '**'} see markdown help
  })

-- Set diagnostic symbols
vim.fn.sign_define('LspDiagnosticsSignError', {text='✖', texthl='LspDiagnosticsDefaultError'})
vim.fn.sign_define('LspDiagnosticsSignWarning', {text='⚠', texthl='LspDiagnosticsDefaultWarning'})
vim.fn.sign_define('LspDiagnosticsSignInformation', {text='כֿ',texthl='LspDiagnosticsDefaultInformation'})
vim.fn.sign_define('LspDiagnosticsSignHint', {text='', texthl='LspDiagnosticsDefaultHint'})

  -- LSP keymap
 local opts = { noremap=true, silent=true }
  keymap('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  keymap('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  keymap('n', '<c-w>]', '<cmd>split <bar> lua vim.lsp.buf.definition()<CR>', opts)
  keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  keymap('n', '<M-D>', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  keymap('n', '<M-O>', '<cmd>lua require(\'nvim-fzf.lsp\').document_symbols()<CR>', opts)
  keymap('n', '<leader>ca', '<cmd>CodeActionMenu<CR>', opts)
  keymap('v', '<leader>ca', '<cmd>CodeActionMenu<CR>', opts)
  keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  keymap('n', '<leader>,d', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  keymap('n', '<leader>lr', '<cmd>LspRestart<CR>', opts)
end

-- load lsp servers
-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
--local sumneko_root_path = vim.fn.stdpath('cache') .. '/lspconfig/sumneko_lua/lua-language-server'
--local sumneko_binary = sumneko_root_path .. '/bin/Linux/lua-language-server'
--require'lspconfig'.sumneko_lua.setup {
--  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
--  on_attach = on_attach,
--  capabilities = capabilities,
--  settings = {
--    Lua = {
--      runtime = {
--        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--        version = 'LuaJIT',
--        -- Setup your lua path
--        path = vim.split(package.path, ';'),
--      },
--      diagnostics = {
--        -- Get the language server to recognize the `vim` global
--        globals = {'vim'},
--      },
--      workspace = {
--        -- Make the server aware of Neovim runtime files
--        library = {
--          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
--          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
--        },
--      },
--      telemetry = {
--        enable = false
--      }
--    }
--  }
--}
require'lspconfig'.pylsp.setup{
  on_attach=on_attach,
  autostart = true,
  capabilities = capabilities,
  settings = {
    pyls = {
      plugins = {
        pycodestyle =  {enabled = false},
        pylint =  { enabled = false },
        black = {enabled = true},
        pyflakes = {enabled = false}
      }
    }
  }
}

require'lspconfig'.gopls.setup{
  on_attach=on_attach,
  capabilities = capabilities,
    settings = {
      gopls = {
        staticcheck = true
      },
    }
}

vim.cmd[[
augroup gopls
	autocmd!
	autocmd BufWritePre *.go :silent! lua vim.lsp.buf.formatting()
	autocmd BufWritePre *.go :silent! lua require'nvim-lsp.utils'.goimports(3000)
augroup END
]]

require'lspconfig'.vimls.setup {
  on_attach=on_attach,
  capabilities = capabilities
}

require'lspconfig'.intelephense.setup {
  on_attach=on_attach,
  capabilities = capabilities
}

require'lspconfig'.bashls.setup {
  on_attach=on_attach,
  capabilities = capabilities
}

local efm_settings, efm_filetypes = utils.get_efm_configs()
require'lspconfig'.efm.setup {
  on_attach=on_attach,
  filetypes = efm_filetypes,
  settings = efm_settings,
  capabilities = capabilities
}

require'lspconfig'.jsonls.setup {
  capabilities = capabilities,
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
        end
      }
    }
}

require('lspkind').init({
  with_text = true,
  symbol_map = utils.symbol_map,
})

-- Register the progress handle
lsp_status.register_progress()
vim.lsp.handlers['textDocument/documentSymbol'] = lsp_document_symbol_callback
vim.lsp.handlers['textDocument/references'] = lsp_references_callback
