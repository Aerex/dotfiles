require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
    disable = {'html', 'php', 'ledger'} -- list of language that will be disabled
  },
  smart_rename = {
    enable = true,
    keymaps = {
      smart_rename = '<leader>rn'
    }
  },
  rainbow = {
    enable = false
  },
  playground = {
    enable = true
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = {'BufWrite', 'CursorHold'},
  },
  incremental_selection = {
    enable = true,
    disable = {},
    keymaps = {
      init_selection = '<leader>n',
      node_incremental = 'n',
      scope_incremental = '<leader>n',
      node_decremental = 'm'
    }
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      disable = {},
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['aC'] = '@class.outer',
        ['iC'] = '@class.inner',
        ['ac'] = '@conditional.outer',
        ['ic'] = '@conditional.inner',
        ['ae'] = '@block.outer',
        ['ie'] = '@block.inner',
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
        ['is'] = '@statement.inner',
        ['as'] = '@statement.outer',
        ['ad'] = '@comment.outer',
        ['id'] = '@comment.inner',
        ['am'] = '@call.outer',
        ['im'] = '@call.inner',
        ['iS'] = {
          ledger = '@status'
        },
        ['aE'] = {
          ledger = '@entry.outer'
        },
        ['iE'] = {
          ledger = '@entry.inner'
        }
      }
    },
    swap = {
      enable = true,
      swap_next = {
        ['<a-l>'] = '@parameter.inner',
        ['<a-f>'] = '@function.outer',
        ['<a-s>'] = '@statement.outer'
      },
      swap_previous = {
        ['<a-L>'] = '@parameter.inner',
        ['<a-F>'] = '@function.outer',
        ['<a-S>'] = '@statement.outer'
      }
    },
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ['<leader>df'] = '@function.outer',
        ['<leader>dF'] = '@class.outer'
      },
      peek_type_definition_code = {
        ['<leader>TF'] = '@class.outer'
      }
    },
    move = {
      enable = true,
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
        [']e'] = '@entry.outer',
      },
      goto_next_end = {
        ['ØØ'] = '@function.inner',
        [']E'] = '@entry.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
        ['[e'] = '@entry.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
        ['[E'] = '@entry.outer',
      }
    }
  },
  indent = {
    enable = true
  },
  ensure_installed = { 'javascript', 'ledger', 'python', 'c', 'query', 'go', 'bash', 'json', 'php'}
}
