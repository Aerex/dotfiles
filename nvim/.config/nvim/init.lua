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
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = {"html", "lua"} -- list of language that will be disabled
    },
    tree_docs = {
      enable = true,
      keymaps = {
        doc_node_at_cursor = "<leader>GDD",
        doc_all_in_range = "<leader>GDD"
      }
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
          ["oo"] = "@function.inner",
        },
        goto_next_end = {
          ["OO"] = "@function.inner",
        },
        goto_previous_start = {
          ["uu"] = "@function.inner",
        },
        goto_previous_end = {
          ["UU"] = "@function.inner",
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
  nvim_lsp.tsserver.setup { }
  nvim_lsp.html.setup { }
  nvim_lsp.jsonls.setup { }
  nvim_lsp.intelephense.setup { }
  -- php
  -- nvm_lsp.intelephense.setup { }
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
  vim.g.dap_virtual_text = true -- 'all frames'
  vim.fn.sign_define("DapBreakpoint", {text = "●", texthl = "", linehl = "", numhl = ""})
  vim.fn.sign_define('DapStopped', {text='▶', texthl='', linehl='NvimDapStopped', numhl=''})
end
--"internalConsole",
--"integratedTerminal",
--"externalTerminal",


