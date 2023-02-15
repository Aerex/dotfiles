local M = {}
local okl, lcfg = pcall(require, 'nvim-local')
M.setup_signs = function()
  local ok, gitsigns = pcall(require, 'gitsigns')
  if ok then
    gitsigns.setup {
      signs = {
        add = {hl = 'GitSignsAdd', text = '+'},
        change = {hl = 'GitSignsChange', text = '~'},
        delete = {hl = 'GitSignsDelete',  text = "▂" },
        topdelete = {hl = 'GitSignsDelete',  text = "▔" },
        changedelete = {hl = 'GitSignsChange', text = '▎'},
      },
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
        ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line({full = true })<CR>',
        ['n <leader>hS'] = '<cmd>lua require"gitsigns".stage_buffer()<CR>',
        ['n <leader>hU'] = '<cmd>lua require"gitsigns".reset_buffer_index()<CR>',
        ['n <leader>ht'] = '<cmd>lua require"gitsigns".toggle_signs()<CR>',

        -- Text objects
        ['o ih'] = '<cmd>lua require"gitsigns.actions".select_hunk()<CR>',
        ['x ih'] = '<cmd>lua require"gitsigns.actions".select_hunk()<CR>'
      },

      signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
      numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        interval = 1000,
        follow_files = true
      },
      attach_to_untracked = true,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 250,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      sign_priority = 1,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000,
    preview_config = {
      -- Options passed to nvim_open_win
      border = 'single',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1
    },
    yadm = {
      enable = false
    },
  }
  end
  -- override color highlights
  --vim.cmd[[hi GitSignsAdd guifg=#afd700 guibg=None]]
  --vim.cmd[[hi GitSignsChange guifg=#EBCB8B guibg=None]]

  local ok_d, diffview = pcall(require, 'diffview')
  if ok_d then
    diffview.setup{
      hooks = {
        view_opened = function(view)
          -- load which key labels
          local ok, wk = pcall(require, 'which-key')
          if ok then
            require'which-key'.register({
             b = { 'Toggle Diff File Panel'},
             c = {
               name = 'Choose Diff Hunk (1|2|3)',
               o = { 'Choose OURS (Head|3)' },
               t = { 'Choose the THEIRS version (Base|1)'},
               a = { 'Delete markers and keep changes|2'},
             }}, { triggers = {'<leader>'}, prefix = " "})
             require'which-key'.register({
               ['[x'] = {'Jump to Prev Conflict'},
               [']x'] = {'Jump to Next Conflict'},
             })
          end
        end
      }
    }
  end
end

M.setup_neogit = function()
  local neogit = require('neogit')

  neogit.setup {
    disable_signs = false,
    disable_hint = false,
    auto_refresh = false,
    console_timeout = 5000,
    disable_context_highlighting = true,
    disable_commit_confirmation = true,
    commit_popup = {
      kind = "split_above"
    },
    console_kind = 'floating',
    popup = {
      kind = "floating"
    },
    kind = "split_above",
    -- customize displayed signs
    signs = {
      -- { CLOSED, OPENED }
      section = { '>', 'v' },
      item = { '>', 'v' },
      hunk = { '', '' },
    },
    integrations = {
      diffview = true
    },
    -- override/add mappings
    mappings = {
      status = {
        ['B'] = 'BranchPopup',
        ['='] = 'Toggle',
        ['x'] = 'Discard',
        ['-'] = 'Stage',
        ['dd'] = 'DiffAtFile',
        ['p'] = '',
        ['pl'] = 'PullPopup',
        ['pu'] = 'PushPopup',
        ['gl'] = 'LogPopup',
        ['L'] = '',
        ['#'] = 'Console',
      }
    }
  }
end

--vim.api.nvim_create_autocmd({'BufWritePost', 'BufEnter', 'FocusGained', 'ShellCmdPost', 'VimResume'}, {
--  pattern = '*',
--  command = '<SID>neogit#refresh_manually(expand(\'<afile>\')'
--})

M.setup_octo = function()
  local octo_cfg = {}
  local cfg
  if okl and lcfg['get_octo_config'] then
    cfg = vim.tbl_deep_extend("force", octo_cfg, lcfg.get_octo_config())
  else
    cfg = octo_cfg
  end
  require'octo'.setup(cfg)
end

M.setup_gitlinker = function()
  local gcfg = {
    mappings = nil
  }
  local cfg
  if okl and lcfg['gitlinker_config']then
    cfg = vim.tbl_deep_extend('force', gcfg, lcfg.gitlinker_config())
  else
    cfg = gcfg
  end
  require'gitlinker'.setup(cfg)
end

M.setup_gh = function()
  require'litee.lib'.setup()
  require 'litee.gh'.setup({
    -- deprecated, around for compatability for now.
    -- remap the arrow keys to resize any litee.nvim windows.
    map_resize_keys = true,
    -- do not map any keys inside any gh.nvim buffers.
    disable_keymaps = false,
    -- the icon set to use.
    icon_set = "default",
    -- any custom icons to use.
    icon_set_custom = nil,
    -- whether to register the @username and #issue_number omnifunc completion
    -- in buffers which start with .git/
    git_buffer_completion = true,
    -- defines keymaps in gh.nvim buffers.
    keymaps = {
        -- when inside a gh.nvim panel, this key will open a node if it has
        -- any futher functionality. for example, hitting <CR> on a commit node
        -- will open the commit's changed files in a new gh.nvim panel.
        open = "<CR>",
        -- when inside a gh.nvim panel, expand a collapsed node
        expand = "zo",
        -- when inside a gh.nvim panel, collpased and expanded node
        collapse = "zc",
        -- when cursor is over a "#1234" formatted issue or PR, open its details
        -- and comments in a new tab.
        goto_issue = "gd",
        -- show any details about a node, typically, this reveals commit messages
        -- and submitted review bodys.
        details = "<CR>",
        -- inside a convo buffer, submit a comment
        submit_comment = "<leader>cs",
        -- inside a convo buffer, when your cursor is ontop of a comment, open
        -- up a set of actions that can be performed.
        actions = "<A-a>",
        -- inside a thread convo buffer, resolve the thread.
        resolve_thread = "<leader>rc",
        -- inside a gh.nvim panel, if possible, open the node's web URL in your
        -- browser. useful particularily for digging into external failed CI
        -- checks.
        goto_web = "gx"
    },
  })
end


return M
