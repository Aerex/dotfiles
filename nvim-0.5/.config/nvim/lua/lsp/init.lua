local utils = require('lsp').utils
local lsp_status = require('lsp-status')
local lsp_signature = require('lsp_signature')
local diagnostic = require('diagnostic')
local completion = require('completion')

local on_attach = function(client, bufnr)
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  local function keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  local function set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Attach LSP Completion
completion.on_attach(client)
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

  -- Attach LSP Diagnostic
  diagnostic.on_attach(client)


  -- LSP keymap
 local opts = { noremap=true, silent=true }
  keymap('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  keymap('n', 'gD', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
end

-- load lsp servers
require'lspconfig'.sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", utils.sumneko_root_path .. "/main.lua"},
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
      telemetry = {
        enable = false
      }
    }
  }
}

require'lspconfig'pyls.setup{
  on_attach=on_attach,
  autostart = true,
  settings = {
    pyls = {
      plugins = {
        pycodestyle =  { enabled = false },
        pylint =  { enabled = false },
        black = {enabled = true},
        pyflakes = {enabled = false}
      }
    }
  }
}

require'lspconfig'gopls.setup{
  on_attach=on_attach
}

require'lspconfig'.vimls.setup {
  on_attach=on_attach
}

require'lspconfig'.bashls.setup {
  on_attach=on_attach
}

require('lspkind').init({
  with_text = true,
  symbol_map = {
    Text = '',
    Method = 'ƒ',
    Function = '',
    Constructor = '',
    Variable = '',
    Class = '',
    Interface = 'ﰮ',
    Module = '',
    Property = '',
    Enum = '了',
    Keyword = '',
    Snippet = '﬌',
    Color = '',
    File = '',
    Folder = '',
    EnumMember = '',
    Constant = '',
    Struct = ''
  },
})

-- Register the progress handle
lsp_status.register_progress()
