-- TMP: use telescope when fzf provider is not available or needs optimization
local M = {}
local root_utils = require('utils')
local is_git_repo = root_utils.is_git_repo
local get_git_root_path = root_utils.get_git_root_path

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local transform_mod = require("telescope.actions.mt").transform_mod

local function telescope_multiopen(prompt_bufnr, method)
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
      vim.cmd(string.format("%s +%s %s", cmd, entry.value['lnum'], entry.value['filename']))
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
    ['?'] = require('telescope.actions.generate').which_key({
      name_width = 20, -- typically leads to smaller floats
      max_height = 0.25, -- increase potential maximum height
      separator = " > ", -- change sep between mode, keybind, and name
      close_with_action = false, -- do not close float on action
    }),
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

M.setup = function()
  require('telescope').setup {
    defaults = {
      layout_strategy = 'vertical',
      path_display = {
        shorten = {
          len     = 3,
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
          ['<Tab>'] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_next,
          ['<S-Tab>'] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_previous
          --['<A-x>'] = require'trouble.providers.telescope'.open_with_trouble
        },
        n = multi_open_maps['n'],
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
      fzf_writer = {
        minimum_grep_characters = 2,
        minimum_files_characters = 2
      }
    }
  }
  require('telescope').load_extension('fzf')
  require 'telescope'.load_extension('yank_history')
  --require('telescope').load_extension('fzf_writer')
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

M.live_grep = function()
  local workspace = vim.lsp.buf.list_workspace_folders()[1]
  workspace = workspace ~= "" and workspace or (is_git_repo() and get_git_root_path() or vim.fn.getcwd())
  vim.notify(workspace)
  require('telescope.builtin').live_grep(M.get_dropdown({
    layout_strategy = 'cursor',
    cwd = workspace,
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


M.rg_search = function()
  local workspace = vim.lsp.buf.list_workspace_folders()[1]
  workspace = workspace ~= "" and workspace or (is_git_repo() and get_git_root_path() or vim.fn.getcwd())
  require('telescope').grep_string(M.get_dropdown({
    path_display = { 'smart' },
    search = '',
    only_sort_text = true,
    word_match = '-w',
    layout_strategy = 'cursor',
    disable_coordinates = true,
    --search_dirs = { workspace, vim.fn.getcwd() },
    --cwd = workspace,
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

return M
