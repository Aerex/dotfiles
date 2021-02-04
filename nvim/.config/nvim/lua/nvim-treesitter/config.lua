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
          --goto_definition = "gd",
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
-- vim: nowrap foldmethod=marker foldlevel=2
