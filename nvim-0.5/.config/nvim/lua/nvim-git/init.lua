local M = {}
M.setup_signs = function()
  require('gitsigns').setup {
    signs = {
      add = {hl = 'GitSignsAdd', text = '+'},
      change = {hl = 'GitSignsChange', text = '~'},
      delete = {hl = 'GitSignsDelete', text = '契'},
      topdelete = {hl = 'GitSignsDelete', text = '契'},
      changedelete = {hl = 'GitSignsChange', text = '▎'},
    },
    numhl = false,
    linehl = false,
    keymaps = {
      -- Default keymap options
      noremap = true,
      buffer = true,

      ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
      ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

      ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
      ['v <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
      ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
      ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
      ['v <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
      ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
      ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
      ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
      ['n <leader>ht'] = '<cmd>lua require"gitsigns".toggle_signs()<CR>',

      -- Text objects
      ['o ih'] = '<cmd>lua require"gitsigns.actions".select_hunk()<CR>',
      ['x ih'] = '<cmd>lua require"gitsigns.actions".select_hunk()<CR>'
    },
    watch_index = {
      interval = 1000,
      follow_files = true
    },
    current_line_blame = false,
    current_line_blame_delay = 1000,
    current_line_blame_position = 'eol',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    word_diff = false,
    use_decoration_api = true,
    use_internal_diff = true,  -- If luajit is present
  }
  -- override color highlights
  vim.cmd[[hi GitSignsAdd guifg=#afd700 guibg=None]]
  vim.cmd[[hi GitSignsChange guifg=#EBCB8B guibg=None]]
end
M.setup_neogit = function()
  local neogit = require("neogit")

  neogit.setup {
    disable_signs = false,
    disable_context_highlighting = false,
    disable_commit_confirmation = false,
    -- customize displayed signs
    signs = {
      -- { CLOSED, OPENED }
      section = { ">", "v" },
      item = { ">", "v" },
      hunk = { "", "" },
    },
    integrations = {
      diffview = true
    },
    -- override/add mappings
    mappings = {
      status = {
        ["B"] = "BranchPopup",
        ["="] = "Toggle"
      }
    }
  }
end

return M
