-- TODO: Need to figure out why requiring modules creates a loop
--local utils = require('nvim-lsp').utils
local lsp_status = require('lsp-status')
local lsp_signature = require('lsp_signature')
local lsp_document_symbol_callback = require('nvim-fzf.lsp').document_symbols local lsp_references_callback = require('nvim-fzf.lsp').references
local utils = require('nvim-lsp.utils')
--
-- configure lsp-status
lsp_status.config({
  status_symbol = '',
  show_filename = true,
  current_function = false
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
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
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

  local ok, goto_preview = pcall(require, 'goto-preview')
  if ok then
    goto_preview.setup{
      width = 120; -- Width of the floating window
      height = 15; -- Height of the floating window
      border = {"↖", "─" ,"┐", "│", "┘", "─", "└", "│"}; -- Border characters of the floating window
      default_mappings = false; -- Bind default mappings
      debug = false; -- Print debug information
      opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
      resizing_mappings = false; -- Binds arrow keys to resizing the floating window.
      post_open_hook = function(buf, wind)
        vim.keymap.set('n', '\\gpd',  function() goto_preview.goto_preview_definition() end, { silent = true, buffer = buf})
        vim.keymap.set('n', '\\gpi', function() goto_preview.goto_preview_implementation() end, { silent = true, buffer = buf})
        vim.keymap.set('n', '\\gpr', function() goto_preview.goto_preview_references() end, { silent = true, buffer = buf})
      end; -- A function taking two arguments, a buffer and a window to be ran as a hook.
      references = { -- Configure the telescope UI for slowing the references cycling window.
        telescope = require'telescope.themes'.get_dropdown({ hide_preview = false })
      };
    -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
    focus_on_open = true; -- Focus the floating window when opening it.
    dismiss_on_move = false; -- Dismiss the floating window when moving the cursor.
    force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
    bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
  }
  end


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
  vim.keymap.set('n', 'gd',  function() vim.lsp.buf.declaration() end, { silent = true, buffer = bufnr })
  vim.keymap.set('n', '<c-]>', function() vim.lsp.buf.definition() end, { silent = true, buffer = bufnr })
  vim.keymap.set('n', '<C-w>]', function() vim.cmd('vsplit'); vim.lsp.buf.definition() end, { silent = true, buffer = bufnr })
  --keymap('n', '<C-w>]', '<cmd>vsplit<bar>lua vim.lsp.buf.definition()<CR>', opts)
  keymap('n', '<C-w>]', '<cmd>vsplit<bar>lua vim.lsp.buf.definition()<CR>', opts)
  keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- TODO(me): Create a fzf lsp_implementation method. Use telescope
  -- temp
  keymap('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts)
  keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  keymap('n', '\\wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  keymap('n', '\\wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  keymap('n', '\\wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  keymap('n', '<M-D>', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.keymap.set('n', '<leader>rn', function() vim.lsp.buf.rename() end, { silent = true, buffer = bufnr })
  -- FIXME(me): nvim-fzf.lsp#document_symbols is not working on selected
  keymap('n', '<A-O>', '<cmd>lua require(\'nvim-fzf.lsp\').document_symbols()<CR>', opts)
  --keymap('n', '<A-O>', '<cmd>Telescope lsp_document_symbols<CR>', opts)
  keymap('n', '<leader>ca', '<cmd>CodeActionMenu<CR>', opts)
  keymap('v', '<leader>ca', '<cmd>CodeActionMenu<CR>', opts)
  keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  keymap('n', '<leader>di', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.keymap.set('n', '<leader>,d', function() vim.diagnostic.open_float() end, { silent= true, buffer = bufnr })
  keymap('n', '<leader>xD', '<cmd>lua vim.diagnostic.disable()<CR>', opts)
  keymap('n', '<leader>lr', '<cmd>LspRestart<CR>', opts)
  keymap('n', '<leader>ll', '<cmd>LspLog<CR>', opts)

  local ok_d, _ = pcall(require, 'jdtls')
  if ok_d and vim.bo.filetype == 'java' then
    require'jdtls.setup'.add_commands()
    require'jdtls'.setup_dap()
  end
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
    pylsp = {
      plugins = {
        pycodestyle =  {enabled = false},
        pylint =  {enabled = false},
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
        usePlaceholders = false
      },
    }
}
local gopls_grp = vim.api.nvim_create_augroup('gopls', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  group = gopls_grp,
  callback = function()
    vim.lsp.buf.formatting()
    require'nvim-lsp.utils'.goimports(2000)
  end
})

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

--local efm_settings, efm_filetypes = utils.get_efm_configs()
--require'lspconfig'.efm.setup {
--  on_attach=on_attach,
--  filetypes = efm_filetypes,
--  settings = efm_settings,
--  capabilities = capabilities
--}

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

require'lspconfig'.bashls.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

if vim.fn.executable('solargraph') then
  require'lspconfig'.solargraph.setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end

local ok_j, _ = pcall(require, 'jdtls')
if ok_j then
  local project_name = require'lspconfig.util'.root_pattern({'.project', 'pom.xml','java.security'})(vim.fn.getcwd())
  if project_name then
    -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
    local config = {
      -- The command that starts the language server
      -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
      cmd = {

        -- 💀
        'java', -- or '/path/to/java11_or_newer/bin/java'
        -- depends on if `java` is in your $PATH env variable and if it points to the right version.

        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
      '-Xms1g',
      '--add-modules=ALL-SYSTEM',
      '--add-opens', 'java.base/java.util=ALL-UNNAMED',
      '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    -- 💀
    '-jar', '/home/noamfo/.local/share/jdt-language-server/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',


    -- 💀
    '-configuration', '/home/noamfo/.local/share/jdt-language-server/config_linux',
                    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
                    -- Must point to the                      Change to one of `linux`, `win` or `mac`
                    -- eclipse.jdt.ls installation            Depending on your system.


    -- 💀
    -- See `data directory configuration` section in the README
    '-data', '/home/noamfo/Documents/eclipse/' .. project_name,
  },

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
    }
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {}
  },
  on_attach = on_attach
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.

local jdtls_grp = vim.api.nvim_create_augroup('jdtls', {})
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'java',
  group = jdtls_grp,
  callback = function()
    require('jdtls').start_or_attach(config)
  end
})
end
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
      log = {
        enable = true,
        level = "debug",
        use_console = "async",
      },
      sources = {
          null_ls.builtins.diagnostics.eslint,
          null_ls.builtins.code_actions.eslint, -- eslint or eslint_d
          null_ls.builtins.formatting.eslint_d -- prettier, eslint, eslint_d, or prettierd
      },
      on_attach = on_attach
  })
end
-- Register the progress handle
lsp_status.register_progress()
vim.lsp.handlers['textDocument/documentSymbol'] = lsp_document_symbol_callback
vim.lsp.handlers['textDocument/references'] = lsp_references_callback
