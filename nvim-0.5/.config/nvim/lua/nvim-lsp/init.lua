-- TODO: Need to figure out why requiring modules creates a loop
--local utils = require('nvim-lsp').utils
local lsp_status = require('lsp-status')
local lsp_signature = require('lsp_signature')
local lsp_document_symbol_callback = require('nvim-fzf.lsp').document_symbols local lsp_references_callback = require('nvim-fzf.lsp').references
local utils = require('nvim-lsp.utils')
--
-- configure lsp-status
lsp_status.config({
  status_symbol = ''
})

vim.diagnostic.config({
  virtual_text = true,
  float = false,
  underline = true,
  signs = true,
  update_in_insert = false,
})

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

local on_attach = function(client, bufnr)
  --vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local function keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      -- Enable underline, use default values
      underline = true,
      -- Enable virtual text, override spacing to 4
      virtual_text = {
        spacing = 4,
      },
      -- Use a function to dynamically turn signs off
      -- and on, using buffer local variables
      signs = true,
      -- Disable a feature
      update_in_insert = false,
    }
  )


  local ok_tsu, ts_utils = pcall(require, 'nvim-lsp-ts-utils')
  if ok_tsu then
    ts_utils.setup({})
    -- required to fix code action ranges and filter diagnostics
    ts_utils.setup_client(client)
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
      border = 'rounded'   -- double, single, shadow, none
    },
    auto_close_after = 10,
    decorator = {'`', '`'}  -- or decorator = {'***', '***'}  decorator = {'**', '**'} see markdown help
  })

-- Set diagnostic symbols
vim.fn.sign_define('DiagnosticSignError', {text='✖', texthl='DiagnosticSignError'})
vim.fn.sign_define('DiagnosticSignWarn', {text='⚠', texthl='DiagnosticSignWarn'})
vim.fn.sign_define('DiagnosticSignInfo', {text='כֿ',texthl='DiagnosticSignInfo'})
vim.fn.sign_define('DiagnosticSignHint', {text='', texthl='DiagnosticSignHint'})

  -- LSP keymap
 local opts = { noremap=true, silent=true }
  keymap('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  keymap('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  keymap('n', '<C-w>]', '<cmd>vsplit<bar>lua vim.lsp.buf.definition()<CR>', opts)
  keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  keymap('n', '<M-D>', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  if vim.bo.filetype == 'typescript' then
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', ':TSLspRenameFile<CR>', opts)
  else
    keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  end
  keymap('n', '<M-O>', '<cmd>lua require(\'nvim-fzf.lsp\').document_symbols()<CR>', opts)
  keymap('n', '<leader>ca', '<cmd>CodeActionMenu<CR>', opts)
  keymap('v', '<leader>ca', '<cmd>CodeActionMenu<CR>', opts)
  keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  keymap('n', '<leader>,d', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  keymap('n', '<leader>xD', '<cmd>lua vim.diagnostic.disable()<CR>', opts)
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
  root_dir = function(fname)
    local util = require'lspconfig.util'
    local root_files = {
      'pyproject.toml',
      'setup.py',
      '__init__.py',
      'setup.cfg',
      'requirements.txt',
      'Pipfile',
    }
    return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
  end,
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
        staticcheck = true,
        usePlaceholders = false
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

require'lspconfig'.tsserver.setup{
  on_attach = on_attach,
  capabilities = capabilities
}

require'lspconfig'.jsonls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
        end
      }
    }
}

if vim.fn.executable('solargraph') then
  require'lspconfig'.solargraph.setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end

require('lspkind').init({
  mode = 'symbol_text',
  preset = 'codicons', -- need to install vscode-codicons
  symbol_map = utils.symbol_map
})

local ok_null, null_ls = pcall(require, 'null-ls')
if ok_null then
  null_ls.setup({
      debug = true,
      sources = {
          null_ls.builtins.diagnostics.eslint,
          null_ls.builtins.code_actions.eslint, -- eslint or eslint_d
          null_ls.builtins.formatting.eslint_d -- prettier, eslint, eslint_d, or prettierd
      },
  })
end
-- Register the progress handle
lsp_status.register_progress()
vim.lsp.handlers['textDocument/documentSymbol'] = lsp_document_symbol_callback
vim.lsp.handlers['textDocument/references'] = lsp_references_callback
