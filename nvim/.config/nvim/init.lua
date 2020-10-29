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

local completion_nvim_ok, completion_nvim = pcall(require, "completion")
if completion_nvim_ok then
  vim.cmd [[
  autocmd BufEnter * lua require'completion'.on_attach()
  ]]



end
local lsp_utils_ok, lsp_utils = pcall(require, "lsputil")
  if lsp_utils then
    vim.lsp.callbacks['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
    vim.lsp.callbacks['textDocument/references'] = require'lsputil.locations'.references_handler
    vim.lsp.callbacks['textDocument/definition'] = require'lsputil.locations'.definition_handler
    vim.lsp.callbacks['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
    vim.lsp.callbacks['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
    vim.lsp.callbacks['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
    vim.g.lsp_utils_location_opts = {
      height = 0,
      mode = 'editor',
      list = {
        border = true,
        coloring = true
      },
      preview = {
        title = 'Location Preview'
      },
      keymaps = {
        n = {
          ['<C-n>'] = 'j',
          ['<C-p>'] = 'k'
        }
      }
    }
    vim.g.lsp_utils_symbols_opts = {
      height = 0,
      mode = 'editor',
      list = {
        border = true,
        coloring = true
      },
      preview = {
        title = 'Symbol Preview'
      },
      keymaps = {
        n = {
          ['<C-n>'] = 'j',
          ['<C-p>'] = 'k'
        }
      }
    }
    vim.g.lsp_utils_codeactions_opts = {
      height = 0,
      mode = 'editor',
      list = {
        border = true,
        coloring = true,
        title = 'Code Action'
      }

    }
end

require 'lsp_overrides'
local diagnostic_nvim_ok, diagnostic_nvim = pcall(require, "diagnostic")
if diagnostic_nvim_ok then
  vim.cmd [[
  autocmd BufEnter * lua require'diagnostic'.on_attach()
  ]]
  vim.cmd [[
  autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()
  ]]
  vim.fn.sign_define("LspDiagnosticsErrorSign", {text="✖", texthl="LspDiagnosticsError"})
  vim.fn.sign_define("LspDiagnosticsWarningSign", {text="⚠", texthl="LspDiagnosticsWarning"})
  vim.fn.sign_define("LspDiagnosticsInformationSign", {text="כֿ",texthl="LspDiagnosticsInformation"})
  vim.fn.sign_define("LspDiagnosticsHintSign", {text="", texthl="LspDiagnosticsHint"})
  vim.g.diagnostic_enable_virtual_text = 0
  vim.g.diagnostic_auto_popup_while_jump = 1

end

local ok, _ = pcall(require, "nvim-treesitter.configs")
if ok then
  vim.cmd("set foldmethod=expr foldexpr=nvim_treesitter#foldexpr()")
  require "nvim-treesitter.parsers".get_parser_configs().php = {
    install_info = {
      url = "https://github.com/tree-sitter/tree-sitter-php",
      files = {"src/parser.c"}
    }
  }
  require "nvim-treesitter.parsers".get_parser_configs().javascript = {
    install_info = {
      url = "https://github.com/tree-sitter/tree-sitter-javascript",
      files = {"src/parser.c"}
    }
  }
  require "nvim-treesitter.configs".setup(
  {
    -- https://github.com/nvim-treesitter/nvim-treesitter#highlight
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = {"html", "lua", "php"} -- list of language that will be disabled
    },
    -- https://github.com/nvim-treesitter/nvim-tree-docs
    tree_docs = {
      enable = false
    },
    playground = {
      enable = true
    },
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
          ["øø"] = "@function.inner",
        },
        goto_next_end = {
          ["ØØ"] = "@function.inner",
        },
        goto_previous_start = {
          ["¥¥"] = "@function.inner",
        },
        goto_previous_end = {
          ["ÁÁ"] = "@function.inner",
        }
      }
    },
    fold = {
      enable = true
    },
    refactor = {
      highlight_current_scope = {
        enable = false,
        inverse_highlighting = true,
        -- disable = {"python"}
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
    ensure_installed = "all"
    --update_strategy = 'newest'
  }
  )
end

local ok, nvim_lsp = pcall(require, 'nvim_lsp')
if ok then
  local configs = require "nvim_lsp.configs"
  local default_callback = vim.lsp.callbacks["textDocument/publishDiagnostics"]
  vim.lsp.callbacks["textDocument/publishDiagnostics"] = function(...)
    default_callback(...)
    require "lsp-ext".update_diagnostics()
  end
  local function on_attach(...)
    vim.fn.NvimLspKeyMapping()
  end

  nvim_lsp.tsserver.setup { 
    on_attach = on_attach
  }
  nvim_lsp.html.setup { }
  nvim_lsp.jsonls.setup { }
  -- php
 nvim_lsp.intelephense.setup {
   on_attach = on_attach
 }
--vue
  nvim_lsp.vuels.setup {
      on_attach = on_attach
  }
-- php
-- if not nvim_lsp.php_lsp then
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
-- nvim_lsp.php_lsp.setup {
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
    --command = vim.api.nvim_get_runtime_file("gadgets/macos/vscode-php-debug/out/phpDebug.js", false)[1],
    command = "node vscode-php-debug" -- symlink from built binary from repo
  }
  dap.configurations.php = {
    type = "php",
    name = "Listen for XDebug",
    request = "Launch file",
    port = 9000,
    pathMappings = {
      ["/opt/samcart/samcart-core/current"] = "${workspaceRoot}"
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
local ok, context = pcall(require, "treesitter-context")
if ok then
  context.enable()
end



