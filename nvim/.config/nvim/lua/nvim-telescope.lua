-- TMP: use telescope when fzf provider is not available or needs optimization
local M = {}
M.setup = function()
  require('telescope').setup {
  defaults = {
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
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
      },
    }
  }
  require('telescope').load_extension('fzf')
  vim.g.telescope_cache_results = 1
  vim.g.telescope_prime_fuzzy_find = 1
end

M.get_dropdown = function(opts)
  opts = opts or {}
  local theme_opts = {
    winblend = 0;
    width = 0.8;
    show_line = false;
    prompt_prefix = 'Files> ';
    prompt_title = '';
    results_title = '';
    preview_title = '';
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'};
  }
  return vim.tbl_deep_extend("force", theme_opts, opts)
end

M.git_files = function()
  require('telescope.builtin').git_files(M.get_dropdown({
    layout_strategy = 'vertical',
    layout_config = {
      vertical = {
        width =  0.5,
        anchor = 'N',
        prompt_position = 'top',
      }
    },
    prompt_prefix = 'Git> ',
  }))
end

return M

