require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {"html", "php"} -- list of language that will be disabled
  },
  smart_rename = {
    enable = true,
    keymaps = {
      smart_rename = '<leader>rn'
    }
  },
  rainbow = {
    enable = true
  },
  playground = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    disable = {},
    keymaps = {
      init_selection = "<leader>n",
      node_incremental = "n",
      scope_incremental = "<leader>n",
      node_decremental = "m"
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
  indent = {
    enable = true
  },
  ensure_installed = {}
}
