-- vim: foldmethod=marker
-- FIXME: E5113: Error while calling lua chunk: ...d/lsp_extensions.nvim/lua/lsp_extensions/inlay_hints.lua:65: bad argument #1 to 'ipairs' (table expected, got number)

-- local ok = pcall(require, "lsp_extensions")

-- if ok then
--   vim.cmd [[
--    autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require'lsp_extensions'.inlay_hints{}
--    ]]
--   require "lsp_extensions".inlay_hints {
--     highlight = "Comment",
--     prefix = " > ",
--     aligned = false,
--     only_current_line = false
--   }
-- end
require('colorizer').setup()
-- Telescope {{{1
local ok, trouble = pcall(require, 'trouble')
if ok then
  trouble.setup{}
  vim.cmd[[ au FileType Trouble noremap <silent> <C-n> <cmd>lua require('trouble').action('next')<CR>]]
  vim.cmd[[ au FileType Trouble noremap <silent> <C-p> <cmd>lua require('trouble').action('previous')<CR>]]
end
local ok, _ = pcall(require, 'telescope')
if ok then
  require("telescope").setup {
    defaults = {
      mappings = {
        i = {
          ["<C-x>"] = require('telescope.actions').select_horizontal,
          ["<C-s>"] = require('telescope.actions').select_horizontal,
          ["<C-c>"] = require('telescope.actions').close,
          ['<C-j>'] = require('telescope.actions').move_selection_next,
          ['<C-k>'] = require('telescope.actions').move_selection_previous,
          ['<C-x>'] = require'trouble.providers.telescope'.open_with_trouble
        },
        n = {
          ["q"] = require('telescope.actions').close,
          ["<C-c>"] = require('telescope.actions').close,
          ["<C-s>"] = require('telescope.actions').select_horizontal,
          ["<C-x>"] = require('telescope.actions').select_horizontal,
          ["<A-j>"] = require('telescope.actions').preview_scrolling_up,
          ["<A-k>"] = require('telescope.actions').preview_scrolling_up,
          ["<Tab>"] = require('telescope.actions').toggle_selection,
          ['<C-x>'] = require'trouble.providers.telescope'.open_with_trouble
        }
      },
      -- file_sorter = require('telescope.sorters').get_fzy_sorter,
      file_previewer = require('telescope.previewers').vim_buffer_cat.new,
      grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
      qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    },
    extensions = {
      fzf_writer = {
        minimum_grep_characters = 4,
        minimum_files_characters = 4,
        -- Disabled by default.
        -- Will probably slow down some aspects of the sorter, but can make color highlights.
        -- I will work on this more later.
        use_highlighter = false
      },
      fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
      },
      gh = { },
      dap = { }
    }
  }
  -- require('telescope').load_extension('fzy_native')
  require('telescope').load_extension('gh')
  require('telescope').load_extension('dap')

  vim.g.telescope_cache_results = 1
  vim.g.telescope_prime_fuzzy_find = 1
end
-- local ok, telescope = pcall(require, "telescope")
-- if ok then
--   local _, actions = pcall(require, 'telescope.actions')
--   vim.g.telescope_cache_results = 1
--   vim.g.telescope_prime_fuzzy_find = 1
--   telescope.setup = {
--     defaults = {
--       mappings = {
--         n = {
--           ["q"] = actions.close,
--           ["<C-c>"] = actions.close,
--           ["<C-x>"] = actions.goto_file_selection_split,
--           ["<A-j>"] = actions.preview_scrolling_up,
--           ["<A-k>"] = actions.preview_scrolling_up
--         },
--          i = {
--            ["<C-x>"] = actions.goto_file_selection_split,
--            ["<C-c>"] = actions.close
--          }
--       }
--     },
--     extensions = {
--       fzf_writer = {
--         minimum_grep_characters = 4,
--         minimum_files_characters = 4,
--         -- Disabled by default.
--         -- Will probably slow down some aspects of the sorter, but can make color highlights.
--         -- I will work on this more later.
--         use_highlighter = false,
--       },
--       ghcli = { },
--       dap = {}
--     },
--   }
  -- telescope.extensions = {
  --   fzf_writer = {
  --     minimum_grep_characters = 4,
  --     minimum_files_characters = 4,
  --     -- Disabled by default.
  --     -- Will probably slow down some aspects of the sorter, but can make color highlights.
  --     -- I will work on this more later.
  --     use_highlighter = false,
  --   },
  --   ghcli = { },
  --   dap = {}
  -- }
-- end
--}}}
-- Completion {{{1
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = false;
    ultisnips = true;
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.g.loaded_ultisnips == 1 and vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
    print('expandsnipp')
    return vim.fn['UltiSnips#ExpandSnippetOrJump']()
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.g.loaded_ultisnips and vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
    return vim.fn["UltiSnips#JumpBackwards"]()
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

function _G.completions()
    if vim.fn.pumvisible() == 1 then
        if vim.fn.complete_info()["selected"] ~= -1 then
            return vim.fn["compe#confirm"]("<CR>")
        end
    end
    return t "<CR>"
end


vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true, noremap = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
--vim.api.nvim_set_keymap('i', '<CR>', 'v:lua.s_completions()', { expr = true})
vim.api.nvim_set_keymap('i', '<C-f>', 'compe#scroll({\'delta\': +4 })', { expr = true})
vim.api.nvim_set_keymap('i', '<C-d>', 'compe#scroll({\'delta\': -4 })', { expr = true})
vim.api.nvim_set_keymap('i', '<C-Space>', 'compe#complete()', { expr = true})

--inoremap <silent><expr> <C-Space> compe#complete()
--inoremap <silent><expr> <C-e>     compe#close('<C-e>')
-- local completion_nvim_ok, _ = pcall(require, "completion")
-- if completion_nvim_ok then
--   vim.g.completion_enable_auto_hover = '0'
-- vim.g.completion_auto_change_source = 1
-- vim.g.completion_matching_strategy_list = {'exact', 'substring'} -- {'exact', 'substring', 'fuzzy', 'all'}
-- vim.g.completion_sorting = 'none'
-- vim.g.completion_matching_smart_case = 1
-- vim.g.completion_chain_complete_list =
--     {
--         default = {
--             default = {
--                 {complete_items = {'lsp', 'snippet'}},
--                 {complete_items = {'buffer'}}, {mode = '<C-p>'},
--                 {mode = '<C-n>'}
--             },
--             comment = {},
--             string = {{complete_items = {'path'}, triggered_only = {'/'}}}
--         },
--         python = {
--             default = {
--                 {complete_items = {'ts'}},
--                 {complete_items = {'lsp', 'snippet'}},
--                 {complete_items = {'buffer'}}, {mode = '<C-p>'},
--                 {mode = '<C-n>'}
--             },
--             comment = {},
--             string = {{complete_items = {'path'}, triggered_only = {'/'}}}
--         },
--         lua = {default = {{complete_items = {'ts'}}}},
--         vim = {default = {{complete_items = {'snippet'}}, {mode = 'cmd'}}}
--     }
-- vim.g.completion_enable_auto_popup = 1
-- vim.g.completion_enable_auto_paren = 1
-- vim.g.completion_enable_snippet = 'UltiSnips'
-- vim.g.completion_confirm_key = '<Enter>'
-- vim.cmd [[ augroup completion_nvim_autocmd ]]
-- vim.cmd [[ autocmd! ]]
-- vim.cmd [[ autocmd BufEnter * if &filetype != "TelescopePrompt" |  lua require'completion'.on_attach()]]
-- vim.cmd [[ autocmd BufEnter *         let g:completion_trigger_character = ['.'] ]]
-- vim.cmd [[ autocmd FileType sql let g:completion_trigger_character = ['.', '"', '`', '['] ]]
-- vim.cmd [[ autocmd FileType sql let g:completion_trigger_character = ['.', '::', '$'] ]]
-- vim.cmd [[ augroup END ]]
-- vim.cmd [[
-- autocmd BufEnter * lua require'completion'.on_attach()
-- ]]
-- vim.cmd [[
-- inoremap <expr> <cr>    pumvisible() ? "\<Plug>(completion_confirm_completion)" : "\<cr>"
-- ]]

-- vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}
-- vim.g.completion_enable_snippet = 'UltiSnips'
-- vim.g.completion_trigger_keyword_length = 2
-- vim.o.completeopt = 'menuone,noinsert,noselect'
-- vim.cmd [[set shortmess+=c]] -- Don't show match info.
-- vim.g.completion_matching_ignore_case = 1
--end
-- Lsp Utils / TextDocument {{{2
-- No longer working
-- local lsp_utils_ok, lsp_utils = pcall(require, "lsputil")
--   if lsp_utils then
-- vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
-- vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
-- vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
-- vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
-- vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
-- vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
-- vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
-- vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler
-- vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
-- vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
-- vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
-- vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
-- vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
-- vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
-- vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
-- vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler

--      vim.g.lsp_utils_location_opts = {
--        height = 0,
--        mode = 'editor',
--        list = {
--          border = true,
--          coloring = true
--        },
--        preview = {
--          title = 'Location Preview'
--        },
--        keymaps = {
--          n = {
--            ['<C-n>'] = 'j',
--            ['<C-p>'] = 'k'
--          }
--        }
--      }
--      vim.g.lsp_utils_symbols_opts = {
--        height = 0,
--        mode = 'editor',
--        list = {
--          border = true,
--          coloring = true
--        },
--        preview = {
--          title = 'Symbol Preview'
--        },
--        keymaps = {
--          n = {
--            ['<C-n>'] = 'j',
--            ['<C-p>'] = 'k'
--          }
--        }
--      }
--      vim.g.lsp_utils_codeactions_opts = {
--        height = 0,
--        mode = 'editor',
--        list = {
--          border = true,
--          coloring = true,
--          title = 'Code Action'
--        }

--      }
-- end
-- }}}
-- require 'lsp_overrides'
-- Diagnostics {{{1
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
  -- This will disable virtual text, like doing:
  -- let g:diagnostic_enable_virtual_text = 0
  virtual_text = {
    spacing = 4
  },

  -- This is similar to:
  -- let g:diagnostic_show_sign = 1
  -- To configure sign display,
  --  see: ":help vim.lsp.diagnostic.set_signs()"
  signs = true,

  -- This is similar to:
  -- "let g:diagnostic_insert_delay = 1"
  update_in_insert = false,
})
-- vim.cmd [[
-- autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
-- ]]
vim.fn.sign_define("LspDiagnosticsSignError", {text="✖", texthl="LspDiagnosticsDefaultError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text="⚠", texthl="LspDiagnosticsDefaultWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text="כֿ",texthl="LspDiagnosticsDefaultInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text="", texthl="LspDiagnosticsDefaultHint"})
-- Treesitter {{{1
require('nvim-treesitter.config')

local lsp_status = require('lsp-status')
lsp_status.config({
  indicator_errors = '✖',
  indicator_warnings = '⚠',
  indicator_info = 'כֿ',
  status_symbol = ' ',
  indicator_hint = '',
  indicator_ok = '',
})

vim.g.completion_customize_lsp_label = {
  Function      = '',
  Method        = 'ƒ',
  Variable      = '',
  Constant      = '',
  Struct        = 'פּ',
  Class         = '',
  Interface     = '禍',
  Text          = '',
  Enum          = '',
  EnumMember    = '',
  Module        = '',
  Color         = '',
  Property      = '襁',
  Field         = '綠',
  Unit          = '',
  File          = '',
  Value         = '',
  Event         = '鬒',
  Folder        = '',
  Keyword       = '',
  Snippet       = '',
  Operator      = '洛',
  Reference     = ' ',
  TypeParameter = '',
  Default       = ''
}
lsp_status.register_progress()

-- completion_customize_lsp_label as used in completion-nvim
lsp_status.config { kind_labels = vim.g.completion_customize_lsp_label }

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}
require'lspconfig'.intelephense.setup {
  capabilities = capabilities,
  on_attach = function(client)
    vim.fn.NvimLspKeyMapping()
    lsp_status.register_client(client.name)
    -- Credits to https://github.com/klaskow/dotfiles/blob/8b69956b91447f7de071e906eedd4c84f9091f34/nvim/lua/on_attach_status.lua
    -- Set up autocommands for refreshing the statusline when LSP information changes
    vim.api.nvim_command('augroup lsp_aucmds')
    vim.api.nvim_command('au! * <buffer>')
    vim.api.nvim_command('au User LspDiagnosticsChanged redrawstatus!')
    vim.api.nvim_command('au User LspMessageUpdate redrawstatus!')
    vim.api.nvim_command('au User LspStatusUpdate redrawstatus!')
    vim.api.nvim_command('augroup END')
    -- If the client is a documentSymbolProvider, set up an autocommand
    -- to update the containing function
    if client.resolved_capabilities.document_symbol then
      vim.api.nvim_command('augroup lsp_aucmds')
      vim.api.nvim_command(
      'au CursorHold <buffer> lua require("lsp-status").update_current_function()'
      )
      vim.api.nvim_command('augroup END')
    end
    lsp_status.on_attach(client)
    require "lsp_signature".on_attach({
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      floating_window = false, 
      hint_enable = true,
      log_path = os.getenv('HOME') .. './cache/nvim/lsp_status.log',
      handler_opts = {
        border = "single"
      }
    })
  end
}
local ok, lspconfig = pcall(require, 'lspconfig')
if ok then
  --local configs = require "lspconfig.configs"
  -- local default_callback = vim.lsp.callbacks["textDocument/publishDiagnostics"]
  -- vim.lsp.callbacks["textDocument/publishDiagnostics"] = function(...)
  --   default_callback(...)
  --   require "lsp-ext".update_diagnostics()
  -- end
  local function on_attach(...)
    vim.fn.NvimLspKeyMapping()
  end


  lspconfig.cssls.setup {
    on_attach = on_attach
  }
  -- javascript
  lspconfig.tsserver.setup {
    on_attach = on_attach
  }
  lspconfig.jsonls.setup { }
  -- php
  -- lspconfig.intelephense.setup {
  --   on_attach = on_attach
  -- }
  -- vim
  lspconfig.vimls.setup {
    on_attach = on_attach
  }
  -- init_options = {
  --   outline = true
  -- },
  -- callbacks = {
  --   ['dart/textDocument/publishOutline'] = require('lsp_extensions.dart.outline').get_callback(),
  -- }
  --vue
  lspconfig.vuels.setup {
    on_attach = on_attach
  }
  -- yaml
  lspconfig.yamlls.setup {
    on_attach = on_attach
  }
  -- html
  lspconfig.html.setup {
    on_attach = on_attach
  }
  -- python
  lspconfig.pyls.setup {
    on_attach = on_attach
  }
  -- angular
  lspconfig.angularls.setup {
    on_attach = on_attach,
  }

  -- sql
  lspconfig.sqlls.setup {
    on_attach = on_attach,
    cmd = {"sql-language-server", "-d", "up", "--method", "stdio"}
  }
  -- docker
  lspconfig.dockerls.setup {
    on_attach = on_attach
  }

  local system_name
  if vim.fn.has("mac") == 1 then
    system_name = "macOS"
  elseif vim.fn.has("unix") == 1 then
    system_name = "Linux"
  elseif vim.fn.has('win32') == 1 then
    system_name = "Windows"
  else
    print("Unsupported system for sumneko")
  end

  -- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
  local sumneko_root_path = os.getenv('HOME') .. '/Documents/repos/git/lua-language-server'
  local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

  require'lspconfig'.sumneko_lua.setup {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
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
      },
    },
  }


  -- c++/c/objective-C/objective-C++
  lspconfig.clangd.setup {
    on_attach = on_attach
  }
end

local ok, colorizer = pcall(require, "colorizer")
if ok then
  colorizer.setup {
    "css",
    "javascript",
    "html",
    "php"
  }
end
local ok, dap = pcall(require, "dap")
if ok then
  dap.adapters.php = {
    type = "executable",
    name = "vscode-php-debug",
    command = "node",
    args = { os.getenv('HOME') .. '/vscode_extensions/out/phpDebug.js' }
  }
  dap.configurations.php = {
    {
      name = "Listen for XDebug (foundation)",
      type = "php",
      request = "launch",
      port = 9000,
      pathMappings = {
        ["/opt/samcart/samcart-core/current"] = "${workspaceRoot}"
      }
    },
    {
      type = "php",
      name = "Listen for XDebug (courses)",
      request = "Launch file",
      port = 9000,
      pathMappings = {
        ["/opt/courses/courses-core/current"] = "${workspaceRoot}"
      }
    }
  }
  require('dap').set_log_level('TRACE')
  -- require'dap'.set_exception_breakpoints()
  --require('dap').defaults.fallback.exception_breakpoints = {''}

  dap.repl.commands =
  vim.tbl_extend(
  "force",
  dap.repl.commands,
  {
    continue = {".continue", "c"},
    next_ = {".next", "n"},
    into = {".into", "s"},
    out = {".out", "r"},
    scopes = {".scopes", "a"},
    threads = {".threads", "t"},
    frames = {".frames", "f"},
    exit = {"exit", ".exit"},
    up = {".up", "j"},
    down = {".down", "k"},
    goto_ = {".goto", "g"},
    into_targets = {".into_targets", "t"},
    capabilities = {".capabilities", ".ca"},
    custom_commands = {
      [".echo"] = function(text)
        dap.repl.append(text)
      end
    }
  }
  )
  vim.cmd('au FileType dap-repl lua require("dap.ext.autocompl").attach()')

  vim.api.nvim_set_keymap('n', '<F3>', '<cmd>lua require\'dap\'.stop()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<F5>', '<cmd>lua require\'dap\'.continue()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<F10>', '<cmd>lua require\'dap\'.step_over()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<F11>', '<cmd>lua require\'dap\'.step_into()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<F12>', '<cmd>lua require\'dap\'.step_out()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>,db', '<cmd>lua require\'dap\'.toggle_breakpoint()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>,dc', '<cmd>lua require\'dap\'.toggle_breakpoint(vim.fn.input(\'Breakpoint Condition: \'), nil, nil, true)<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>,dl', '<cmd>lua require\'dap\'.toggle_breakpoint(nil, nil, vim.fn.input(\'Log point message: \'), true)<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>,dr', '<cmd>lua require\'dap\'.repl.toggle({height=15})<CR>', { noremap = true, silent = true })
  --vim.api.nvim_buf_set_keymap(0, '', 'cc', 'line(".") == 1 ? "cc" : "ggcc"', { noremap = true, expr = true })
  vim.g.dap_virtual_text = true -- 'all frames'
  vim.fn.sign_define("DapBreakpoint", {text = "●", texthl = "", linehl = "", numhl = ""})
  vim.fn.sign_define('DapStopped', {text='▶', texthl='', linehl='NvimDapStopped', numhl=''})
end

-- Dashboard {{{1
require('dashboard.config')

--- Misc {{{1
require('misc.config')
--}}}

require('nvim-gitsigns').setup()

require('dadbod')

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
    Unit = '',
    Value = '',
    Enum = '了',
    Keyword = '',
    Snippet = '﬌',
    Color = '',
    File = '',
    Folder = '',
    EnumMember = '',
    Constant = '',
    Struct = '',
    D =' ',
    DB = ''
  },
})

local ok, neogit = pcall(require, 'neogit')
if ok then
  neogit.setup {
    disable_signs = false,
    disable_context_highlighting = false,
    -- customize displayed signs
    signs = {
      -- { CLOSED, OPENED }
      section = { ">", "v" },
      item = { ">", "v" },
      hunk = { "", "" },
    },
    -- override/add mappings
    mappings = {
      -- modify status buffer mappings
      status = {
        ["Tab"] = "Toggle",
        ["B"] = "BranchPopup"
      }
    }
  }
end
require'todo-comments'.setup{}
require'toggleterm'.setup{
  open_mapping = [[<c-t>]]
}
