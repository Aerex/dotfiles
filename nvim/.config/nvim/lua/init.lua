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
local ok, _ = pcall(require, 'telescope') 
if ok then 
  require("telescope").setup {
    defaults = {
      mappings = {
        i = {
          ["<C-x>"] = require('telescope.actions').goto_file_selection_split,
          ["<C-s>"] = require('telescope.actions').goto_file_selection_split,
          ["<C-c>"] = require('telescope.actions').close,
          ['<C-j>'] = require('telescope.actions').move_selection_next,
          ['<C-k>'] = require('telescope.actions').move_selection_previous
        },
        n = {
          ["q"] = require('telescope.actions').close,
          ["<C-c>"] = require('telescope.actions').close,
          ["<C-s>"] = require('telescope.actions').goto_file_selection_split,
          ["<C-x>"] = require('telescope.actions').goto_file_selection_split,
          ["<A-j>"] = require('telescope.actions').preview_scrolling_up,
          ["<A-k>"] = require('telescope.actions').preview_scrolling_up
        }
      }
    },
    extensions = {
      fzf_writer = {
        minimum_grep_characters = 4,
        minimum_files_characters = 4,
        -- Disabled by default.
        -- Will probably slow down some aspects of the sorter, but can make color highlights.
        -- I will work on this more later.
        use_highlighter = true
      },
      ghcli = { },
      dap = { }
    }
  }
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
local completion_nvim_ok, completion_nvim = pcall(require, "completion")
if completion_nvim_ok then
  vim.cmd [[
  autocmd BufEnter * lua require'completion'.on_attach()
  ]]
  vim.cmd [[
  inoremap <expr> <cr>    pumvisible() ? "\<Plug>(completion_confirm_completion)" : "\<cr>"
  ]]
  vim.g.completion_confirm_key = '<Enter>'

  vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}
  vim.g.completion_enable_snippet = 'UltiSnips'
  vim.g.completion_trigger_keyword_length = 2
  vim.o.completeopt = 'menuone,noinsert,noselect'
  vim.cmd [[set shortmess+=c]] -- Don't show match info.

end
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
    virtual_text = false,

    -- This is similar to:
    -- let g:diagnostic_show_sign = 1
    -- To configure sign display,
    --  see: ":help vim.lsp.diagnostic.set_signs()"
    signs = true,

    -- This is similar to:
    -- "let g:diagnostic_insert_delay = 1"
    update_in_insert = false,
  })
 vim.cmd [[
 autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
 ]]
 vim.fn.sign_define("LspDiagnosticsSignError", {text="✖", texthl="LspDiagnosticsDefaultError"})
 vim.fn.sign_define("LspDiagnosticsSignWarning", {text="⚠", texthl="LspDiagnosticsDefaultWarning"})
 vim.fn.sign_define("LspDiagnosticsSignInformation", {text="כֿ",texthl="LspDiagnosticsDefaultInformation"})
 vim.fn.sign_define("LspDiagnosticsSignHint", {text="", texthl="LspDiagnosticsDefaultHint"})
-- Treesitter {{{1
local ok, _ = pcall(require, "nvim-treesitter.configs")
if ok then
  vim.cmd [[
  set foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
  ]]
  require "nvim-treesitter.configs".setup(
  {
    -- https://github.com/nvim-treesitter/nvim-treesitter#highlight
    -- highlight {{{2
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = {"html", "lua", "php", "python"} -- list of language that will be disabled
    },
    --}}}
    -- tree_docs {{{2
    -- https://github.com/nvim-treesitter/nvim-tree-docs
    tree_docs = {
      enable = false
    },
    --}}}
    -- playground {{{2
    playground = {
      enable = true
    },
    --}}}
    -- incremental_selection {{{2
    incremental_selection = {
      -- this enables incremental selection
      enable = true,
      disable = {},
      keymaps = {
        init_selection = "<enter>", -- maps in normal mode to init the node/scope selection
        node_incremental = "<enter>", -- increment to the upper named parent
        scope_incremental = "Ts", -- increment to the upper scope (as defined in locals.scm)
        node_decremental = "<bs>"
      }
    },
    indent = {
      disable = { "php" },
    },
    node_movement = {
      -- this enables incremental selection
      enable = true,
      highlight_current_node = true,
      disable = {"python"},
      keymaps = {
        move_up = "<a-k>",
        move_down = "<a-j>",
        move_left = "<a-h>",
        move_right = "<a-l>",
        swap_up = "<s-a-k>",
        swap_down = "<s-a-j>",
        swap_left = "<s-a-h>",
        swap_right = "<s-a-l>",
        select_current_node = "<leader>ff"
      }
    },
    textobjects = {
      select = {
        enable = true,
        disable = {},
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["aC"] = "@class.outer",
          ["iC"] = "@class.inner",
          ["ac"] = "@conditional.outer",
          ["ic"] = "@conditional.inner",
          ["ae"] = "@block.outer",
          ["ie"] = "@block.inner",
          ["al"] = "@loop.outer",
          ["il"] = "@loop.inner",
          ["is"] = "@statement.inner",
          ["as"] = "@statement.outer",
          ["ad"] = "@comment.outer",
          ["id"] = "@comment.inner",
          ["am"] = "@call.outer",
          ["im"] = "@call.inner"
        }
      },
      swap = {
        enable = true,
        swap_next = {
          ["<a-l>"] = "@parameter.inner",
          ["<a-f>"] = "@function.outer",
          ["<a-s>"] = "@statement.outer"
        },
        swap_previous = {
          ["<a-L>"] = "@parameter.inner",
          ["<a-F>"] = "@function.outer",
          ["<a-S>"] = "@statement.outer"
        }
      },
      lsp_interop = {
        enable = true,
        peek_definition_code = {
          ["<leader>df"] = "@function.outer",
          ["<leader>dF"] = "@class.outer"
        },
        peek_type_definition_code = {
          ["<leader>TF"] = "@class.outer"
        }
      },
      move = {
        enable = true,
        goto_next_start = {
          ["]]"] = "@function.outer",
          ["]c"] = "@class.outer",
        },
        goto_next_end = {
          ["]["] = "@function.outer",
          ["]C"] = "@class.outer",
        },
        goto_previous_start = {
          ["[["] = "@function.outer",
          ["[m"] = "@class.outer",
        },
        goto_previous_end = {
          ["[]"] = "@function.outer",
          ["[M"] = "@class.outer",
        }
      }
    },
    fold = {
      enable = true,
      disable = { "html" }
    },
    refactor = {
      highlight_current_scope = {
        enable = false,
        inverse_highlighting = true,
        disable = {"python"}
      },
      highlight_definitions = {
        enable = true
      },
      smart_rename = {
        enable = true,
        disable = {},
        keymaps = {
          smart_rename = "<leader>rn"
        }
      },
      navigation = {
        enable = true,
        disable = {},
        keymaps = {
          goto_definition = "gd",
          list_definitions = "gD",
          list_definitions_toc = "gO",
          goto_next_usage = "<a-*>",
          goto_previous_usage = "<a-#>"
        }
      }
    },
    ensure_installed = "all",
    update_strategy = 'newest'
  }
  )
end

local ok, lspconfig = pcall(require, 'lspconfig')
if ok then
  local configs = require "lspconfig.configs"
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
  lspconfig.html.setup { }
  lspconfig.jsonls.setup { }
  -- php
 lspconfig.intelephense.setup {
   cmd = { '/Users/noamfo/.nvm/versions/node/v12.18.3/bin/intelephense', '--stdio' },
   init_options = {
     licenceKey = '0002LT9FKR8PD8H'
   },
   on_attach = on_attach
 }
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
-- css
lspconfig.cssls.setup {
  on_attach = on_attach
}
-- html
lspconfig.html.setup {
  on_attach = on_attach
}
-- vim
-- lspconfig.vimls.setup {
--   on_attach = on_attach
-- }
-- python
lspconfig.pyls.setup {
  on_attach = on_attach
}
-- c++/c/objective-C/objective-C++
lspconfig.clangd.setup {
  on_attach = on_attach
}
-- php
-- if not lspconfig.php_lsp then
--   configs.php_lsp = {
--     default_config = {
--       cmd = {'php ~/Documents/repos/git/php-language-server/bin/php-language-server.php'};
--       filetypes = {'php'};
--       root_dir = function(fname)
--         local cwd  = vim.loop.cwd();
--         local root = util.root_pattern("composer.json", ".git")(pattern);

--         -- prefer cwd if root is a descendant
--         return util.path.is_descendant(cwd, root) and cwd or root;
--       end;
--       settings = {};
--     };
--   }
-- end
-- lspconfig.php_lsp.setup {
--   on_attach = on_attach
-- }
end

-- local ok, colorizer = pcall(require, "colorizer")
-- if ok then
--   colorizer.setup {
--     "css",
--     "javascript",
--     "html",
--     "php"
--   }
-- end
local ok, dap = pcall(require, "dap")
if ok then
  dap.adapters.php = {
    type = "executable",
    name = "vscode-php-debug",
    -- TODO: parameterize os path
    command = "node",
    args = { os.getenv('HOME') .. '/bin/vscode-php-debug' }
    -- command = "node vscode-php-debug" -- symlink from built binary from repo
  }
  dap.configurations.php = {
    {
      type = "php",
      name = "Listen for XDebug (core)",
      request = "Launch file",
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
  --vim.g.dap_virtual_text = true -- 'all frames'
  vim.fn.sign_define("DapBreakpoint", {text = "●", texthl = "", linehl = "", numhl = ""})
  vim.fn.sign_define('DapStopped', {text='▶', texthl='', linehl='NvimDapStopped', numhl=''})
end

-- Dashboard {{{1
vim.g.dashboard_default_executive = 'fzf'
vim.g.dashboard_custom_shortcut_icon = {}
vim.g.dashboard_custom_shortcut_icon['last_session'] = ' '
vim.g.dashboard_custom_shortcut_icon['find_history'] = 'ﭯ '
vim.g.dashboard_custom_shortcut_icon['find_file'] = ' '
vim.g.dashboard_custom_shortcut_icon['new_file'] = ' '
vim.g.dashboard_custom_shortcut_icon['change_colorscheme'] = ' '
vim.g.dashboard_custom_shortcut_icon['find_word'] = ' '
vim.g.dashboard_custom_shortcut_icon['book_marks'] = ' '

