local M = {}
local okl, lcfg = pcall(require, 'nvim-local')
M.setup_signs = function()
  local ok, gitsigns = pcall(require, 'gitsigns')
  if ok then
    gitsigns.setup {
      on_attach                    = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, { expr = true })

        map('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, { expr = true })

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk)
        map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
        map('n', '<leader>hr', gs.reset_hunk)
        map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
        map('n', '<leader>hS', gs.stage_buffer)
        map('n', '<leader>hu', gs.undo_stage_hunk)
        map('n', '<leader>hR', gs.reset_buffer)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hb', function() gs.blame_line { full = true } end)
        map('n', '<leader>tb', gs.toggle_current_line_blame)
        map('n', '<leader>hd', gs.diffthis)
        map('n', '<leader>hD', function() gs.diffthis('~') end)
        map('n', '<leader>td', gs.toggle_deleted)

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end,
      signs                        = {
        add = { hl = 'GitSignsAdd', text = '+' },
        change = { hl = 'GitSignsChange', text = '~' },
        delete = { hl = 'GitSignsDelete', text = "▂" },
        topdelete = { hl = 'GitSignsDelete', text = "▔" },
        changedelete = { hl = 'GitSignsChange', text = '▎' },
      },
      signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
      numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir                 = {
        interval = 1000,
        follow_files = true
      },
      attach_to_untracked          = true,
      current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts      = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 250,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      sign_priority                = 1,
      update_debounce              = 100,
      status_formatter             = nil, -- Use default
      max_file_length              = 40000,
      preview_config               = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
      yadm                         = {
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
    -- Hides the hints at the top of the status buffer
    disable_hint = false,
    -- Disables changing the buffer highlights based on where the cursor is.
    disable_context_highlighting = true,
    -- Disables signs for sections/items/hunks
    disable_signs = false,
    -- Do not ask to confirm the commit - just do it when the buffer is closed.
    disable_commit_confirmation = true,
    -- Uses `vim.notify` instead of the built-in notification system.
    disable_builtin_notifications = true,
    -- Changes what mode the Commit Editor starts in. `true` will leave nvim in normal mode, `false` will change nvim to insert mode, and `"auto"` will change nvim to insert mode IF the commit message is empty, otherwise leaving it in normal mode.
    disable_insert_on_commit = true,
  -- Allows a different telescope sorter. Defaults to 'fuzzy_with_index_bias'. The example below will use the native fzf
  -- sorter instead. By default, this function returns `nil`.
  telescope_sorter = function()
    return require("telescope").extensions.fzf.native_fzf_sorter()
  end,
  -- Persist the values of switches/options within and across sessions
  remember_settings = true,
  -- Scope persisted settings on a per-project basis
  use_per_project_settings = true,
  -- Table of settings to never persist. Uses format "Filetype--cli-value"
  ignored_settings = {
    "NeogitPushPopup--force-with-lease",
    "NeogitPushPopup--force",
    "NeogitPullPopup--rebase",
    "NeogitCommitPopup--allow-empty",
    "NeogitRevertPopup--no-edit",
  },
  -- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
  -- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
  auto_refresh = false,
  -- Value used for `--sort` option for `git branch` command
  -- By default, branches will be sorted by commit date descending
  -- Flag description: https://git-scm.com/docs/git-branch#Documentation/git-branch.txt---sortltkeygt
  -- Sorting keys: https://git-scm.com/docs/git-for-each-ref#_options
  sort_branches = "-committerdate",
  -- Change the default way of opening neogit
  kind = "split",
  -- The time after which an output console is shown for slow running commands
  console_timeout = 5000,
  -- Automatically show console if a command takes more than console_timeout milliseconds
  auto_show_console = true,
  status = {
    recent_commit_count = 10,
  },
  commit_editor = {
    kind = "split",
  },
  commit_select_view = {
    kind = "split",
  },
  commit_view = {
    kind = "vsplit",
  },
  log_view = {
    kind = "tab",
  },
  rebase_editor = {
    kind = "split",
  },
  reflog_view = {
    kind = "tab",
  },
  merge_editor = {
    kind = "split",
  },
  preview_buffer = {
    kind = "split",
  },
  popup = {
    kind = "split",
  },
  signs = {
    -- { CLOSED, OPENED }
    hunk = { "", "" },
    item = { ">", "v" },
    section = { ">", "v" },
  },
  -- Each Integration is auto-detected through plugin presence, however, it can be disabled by setting to `false`
  integrations = {
    -- If enabled, use telescope for menu selection rather than vim.ui.select.
    -- Allows multi-select and some things that vim.ui.select doesn't.
    telescope = true,
    -- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `diffview`.
    -- The diffview integration enables the diff popup.
    --
    -- Requires you to have `sindrets/diffview.nvim` installed.
    diffview = true,
  },
  sections = {
    -- Reverting/Cherry Picking
    sequencer = {
      folded = false,
      hidden = false,
    },
    untracked = {
      folded = false,
      hidden = false,
    },
    unstaged = {
      folded = false,
      hidden = false,
    },
    staged = {
      folded = false,
      hidden = false,
    },
    stashes = {
      folded = true,
      hidden = false,
    },
    unpulled_upstream = {
      folded = true,
      hidden = false,
    },
    unmerged_upstream = {
      folded = false,
      hidden = false,
    },
    unpulled_pushRemote = {
      folded = true,
      hidden = false,
    },
    unmerged_pushRemote = {
      folded = false,
      hidden = false,
    },
    recent = {
      folded = true,
      hidden = false,
    },
    rebase = {
      folded = true,
      hidden = false,
    },
  },
  mappings = {
    finder = {
      ["<cr>"] = "Select",
      ["<c-c>"] = "Close",
      ["<esc>"] = "Close",
      ["<c-n>"] = "Next",
      ["<c-p>"] = "Previous",
      ["<down>"] = "Next",
      ["<up>"] = "Previous",
      ["<tab>"] = "MultiselectToggleNext",
      ["<s-tab>"] = "MultiselectTogglePrevious",
      ["<c-j>"] = "NOP",
    },
    popup = {
      ["f"] = "FetchPopup",
      ["A"] = "CherryPickPopup",
      ["D"] = "DiffPopup",
      ["P"] = "PushPopup",
      ["X"] = "ResetPopup",
      ["?"] = "HelpPopup",
      ["r"] = "RebasePopup",
      ["m"] = "MergePopup",
      ["c"] = "CommitPopup",
      ["gl"] = "LogPopup",
      ["v"] = "RevertPopup",
      ["Z"] = "StashPopup",
      ["B"] = "BranchPopup",
      ["M"] = "RemotePopup",
    },
    -- Setting any of these to `false` will disable the mapping.
    status = {
      ["q"] = "Close",
      ["I"] = "InitRepo",
      ["1"] = "Depth1",
      ["2"] = "Depth2",
      ["3"] = "Depth3",
      ["4"] = "Depth4",
      ["<tab>"] = "Toggle",
      ["="] = "Toggle",
      ["x"] = "Discard",
      ["s"] = "Stage",
      ["S"] = "StageUnstaged",
      ["<c-s>"] = "StageAll",
      ["u"] = "Unstage",
      ["U"] = "UnstageStaged",
      ["dd"] = "DiffAtFile",
      ["$"] = "CommandHistory",
      ["#"] = "Console",
      ["<c-r>"] = "RefreshBuffer",
      ["<enter>"] = "GoToFile",
      ["<c-v>"] = "VSplitOpen",
      ["<c-x>"] = "SplitOpen",
      ["<c-t>"] = "TabOpen",
      ["{"] = "GoToPreviousHunkHeader",
      ["}"] = "GoToNextHunkHeader",
    },
  },
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
