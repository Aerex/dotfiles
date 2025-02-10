local get_workspace = require 'utils'.get_workspace
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local transform_mod = require('telescope.actions.mt').transform_mod
local M = {}

local get_dropdown = function(opts)
  opts = opts or {}
  local theme_opts = {
    winblend = 0,
    width = 0.8,
    show_line = false,
    prompt_prefix = 'Files> ',
    prompt_title = '',
    results_title = '',
    preview_title = '',
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
  }
  return vim.tbl_deep_extend("force", theme_opts, opts)
end

local telescope_multiopen = function(prompt_bufnr, method)
  local cmd_map = {
    vertical = "vsplit",
    horizontal = "split",
    tab = "tabe",
    default = "edit"
  }
  local picker = action_state.get_current_picker(prompt_bufnr)
  local multi_selection = picker:get_multi_selection()
  local has_multi_selection = (next(picker:get_multi_selection()) ~= nil)

  if has_multi_selection then
    require("telescope.pickers").on_close_prompt(prompt_bufnr)
    pcall(vim.api.nvim_set_current_win, picker.original_win_id)

    for i, entry in ipairs(multi_selection) do
      -- opinionated use-case
      local cmd = i == 1 and "edit" or cmd_map[method]
      vim.cmd(string.format("%s %s", cmd, entry.value))
    end
  else
    actions["select_" .. method](prompt_bufnr)
  end
end

local multi_select = transform_mod({
  vertical = function(prompt_bufnr)
    telescope_multiopen(prompt_bufnr, "vertical")
  end,
  horizontal = function(prompt_bufnr)
    telescope_multiopen(prompt_bufnr, "horizontal")
  end,
  tab = function(prompt_bufnr)
    telescope_multiopen(prompt_bufnr, "tab")
  end,
  open = function(prompt_bufnr)
    telescope_multiopen(prompt_bufnr, "default")
  end,
})

local multi_open_maps = {
  i = {
    ['<C-x>'] = require('telescope.actions').select_horizontal,
    ['<C-s>'] = require('telescope.actions').select_horizontal,
    ['<C-c>'] = require('telescope.actions').close,
    ['<C-j>'] = require('telescope.actions').move_selection_next,
    ['<C-k>'] = require('telescope.actions').move_selection_previous,
    ['<A-p>'] = require('telescope.actions.layout').toggle_preview,
    ['<Tab>'] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_next,
    ["<C-f>"] = require('telescope.actions').to_fuzzy_refine,
    ['<S-Tab>'] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_previous
    --['<A-x>'] = require'trouble.providers.telescope'.open_with_trouble
  },
  n = {
    ['q'] = require('telescope.actions').close,
    ['<CR>'] = multi_select.open,
    ['<C-c>'] = require('telescope.actions').close,
    ['<C-s>'] = multi_select.horizonal,
    ['<C-x>'] = multi_select.horizontal,
    ['<C-v>'] = multi_select.veritical,
    ['<C-T>'] = multi_select.tab,
    ['<A-j>'] = require('telescope.actions').preview_scrolling_up,
    ['<A-k>'] = require('telescope.actions').preview_scrolling_up,
    ['<A-p>'] = require('telescope.actions.layout').toggle_preview,
    ['<Tab>'] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_next,
    ['<S-Tab>'] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_previous
    --['<A-x>'] = require'trouble.providers.telescope'.open_with_trouble
  }
}



M.telescope = {
  setup = function()
    require('telescope').setup {
      defaults = {
        layout_strategy = 'vertical',
        path_display = {
          shorten = {
            len     = 4,
            exclude = { -1 }
          }
        },
        pickers = {
          octo = {
            theme = 'ivy'
          },
          oldfiles = {
            mappings = multi_open_maps
          },
          find_files = {
            mappings = multi_open_maps
          },
          buffers = {
            mappings = multi_open_maps
          },
          live_grep = {
            mappings = multi_open_maps
          },
          grep_string = {
            mappings = multi_open_maps
          },
          lsp_references = {
            mappings = multi_open_maps
          },
          mappings = {
            i = {
              ['<C-x>'] = require('telescope.actions').select_horizontal,
              ['<C-s>'] = require('telescope.actions').select_horizontal,
              ['<C-c>'] = require('telescope.actions').close,
              ['<C-j>'] = require('telescope.actions').move_selection_next,
              ['<C-k>'] = require('telescope.actions').move_selection_previous,
              --['<A-x>'] = require'trouble.providers.telescope'.open_with_trouble
            },
            n = {
              ['q'] = require('telescope.actions').close,
              ['<Esc>'] = require('telescope.actions').close,
              ['<C-c>'] = require('telescope.actions').close,
              ['<C-s>'] = require('telescope.actions').select_horizontal,
              ['<C-x>'] = require('telescope.actions').select_horizontal,
              ['<A-j>'] = require('telescope.actions').preview_scrolling_up,
              ['<A-k>'] = require('telescope.actions').preview_scrolling_up,
              ['<Tab>'] = require('telescope.actions').toggle_selection,
              --['<A-x>'] = require'trouble.providers.telescope'.open_with_trouble
            }
          },
          -- file_sorter = require('telescope.sorters').get_fzy_sorter,
          file_previewer = require('telescope.previewers').vim_buffer_cat.new,
          grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
          qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
        },
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
          },
        }
      }
    }
    require('telescope').load_extension('fzf')
    require('telescope').load_extension('luasnip')
    vim.g.telescope_cache_results = 1
    vim.g.telescope_prime_fuzzy_find = 1
  end,
  git_files = function()
    require('telescope.builtin').git_files(M.get_dropdown({
      layout_strategy = 'vertical',
      layout_config = {
        vertical = {
          width = 0.5,
          anchor = 'N',
          prompt_position = 'top',
        }
      },
      prompt_prefix = 'Git> ',
    }))
  end,
  document_symbols = function()
    require('telescope.builtin').lsp_document_symbols({
      fname_width = 10,
      trim_text = true,
      layout_strategy = 'vertical',
      layout_config = {
        preview_cutoff = 0, -- Preview should always show (unless previewer = false)
        width = function(_, max_columns, _)
          return math.min(max_columns, 9)
        end,
        --height = function(_, _, max_lines)
        --  return math.min(max_lines, 15)
        --end,
        vertical = {
          width = 0.5,
          anchor = 'N',
          prompt_position = 'top',
        }
      },
      prompt_prefix = 'Document Symbols> ',
    })
  end,
  lsp_ref = function()
    require('telescope.builtin').lsp_references(get_dropdown({
      fname_width = 10,
      trim_text = true,
      layout_strategy = 'vertical',
      layout_config = {
        preview_cutoff = 0, -- Preview should always show (unless previewer = false)
        width = function(_, max_columns, _)
          return math.min(max_columns, 9)
        end,
        --height = function(_, _, max_lines)
        --  return math.min(max_lines, 15)
        --end,
        vertical = {
          width = 0.5,
          anchor = 'N',
          prompt_position = 'top',
        }
      },
      prompt_prefix = 'References> ',
    }))
  end,
  rg_string = function()
    require('telescope.builtin').grep_string(get_dropdown({
      layout_strategy = 'cursor',
      cwd = get_workspace(),
      layout_config = {
        width = function(_, max_columns, _)
          return math.min(max_columns, 150)
        end,
        height = function(_, _, max_lines)
          return math.min(max_lines, 25)
        end,
        cursor = {
          anchor = 'N',
          prompt_position = 'top',
        }
      },
      prompt_prefix = 'Rg> ',
    }))
  end,
  live_grep = function()
    require('telescope.builtin').live_grep(get_dropdown({
      layout_strategy = 'cursor',
      cwd = get_workspace(),
      layout_config = {
        width = function(_, max_columns, _)
          return math.min(max_columns, 150)
        end,
        height = function(_, _, max_lines)
          return math.min(max_lines, 30)
        end,
        cursor = {
          anchor = 'N',
          prompt_position = 'top',
        }
      },
      prompt_prefix = 'Rg Search> ',
    }))
  end,
  rg_search = function()
    require('telescope').grep_string(get_dropdown({
      path_display = { 'smart' },
      search = '',
      only_sort_text = true,
      word_match = '-w',
      layout_strategy = 'cursor',
      disable_coordinates = true,
      layout_config = {
        width = function(_, max_columns, _)
          return math.min(max_columns, 150)
        end,
        height = function(_, _, max_lines)
          return math.min(max_lines, 30)
        end,
        cursor = {
          anchor = 'N',
          prompt_position = 'top',
        }
      },
      prompt_prefix = 'Rg Search> ',
    }))
  end
}

return M
