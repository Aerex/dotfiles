-- TMP: use telescope when fzf provider is not available or needs optimization
local M = {}
local root_utils = require('utils')
local is_git_repo = root_utils.is_git_repo
local get_git_root_path = root_utils.get_git_root_path

M.setup = function()
  require('telescope').setup {
    defaults = {
      layout_strategy = 'vertical',
      path_display = {
        shorten = {
          len     = 2,
          exclude = { -1 }
        }
      },
      mappings = {
        i = {
          ['<C-x>'] = require('telescope.actions').select_horizontal,
          ['<C-s>'] = require('telescope.actions').select_horizontal,
          ['<C-c>'] = require('telescope.actions').close,
          ['<C-j>'] = require('telescope.actions').move_selection_next,
          ['<C-k>'] = require('telescope.actions').move_selection_previous,
          ['<A-p>'] = require('telescope.actions.layout').toggle_preview,
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
          ['<A-p>'] = require('telescope.actions.layout').toggle_preview,
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
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      },
    }
  }
  require('telescope').load_extension('fzf')
  require 'telescope'.load_extension('yank_history')
  vim.g.telescope_cache_results = 1
  vim.g.telescope_prime_fuzzy_find = 1
end

M.get_dropdown = function(opts)
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

M.git_files = function()
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
end

M.document_symbols = function()
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
end

M.lsp_ref = function()
  require('telescope.builtin').lsp_references(M.get_dropdown({
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
end

M.rg_string = function()
  local workspace = vim.lsp.buf.list_workspace_folders()[1]
  workspace = workspace ~= "" and workspace or (is_git_repo() and get_git_root_path() or vim.fn.getcwd())
  require('telescope.builtin').grep_string(M.get_dropdown({
    layout_strategy = 'cursor',
    cwd = workspace,
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
end

M.rg_search = function()
  local workspace = vim.lsp.buf.list_workspace_folders()[1]
  workspace = workspace ~= "" and workspace or (is_git_repo() and get_git_root_path() or vim.fn.getcwd())
  vim.notify('workspace -> ' .. workspace)
  require('telescope.builtin').live_grep(M.get_dropdown({
    layout_strategy = 'cursor',
    disable_coordinates = true,
    cwd = workspace,
    glob_pattern = { '!go.sum' },
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
    prompt_prefix = 'Rg> ',
  }))
end

return M
