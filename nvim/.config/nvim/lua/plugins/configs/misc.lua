local M = {}
M.rest = {
  setup = function()
    local custom_dynamic_variables = {}
    local ok, lcfg = pcall(require, 'nvim-local')
    if ok then
      custom_dynamic_variables = lcfg.http_rest_config().custom_dynamic_variables
    end
    require('rest-nvim').setup({
      -- Open request results in a horizontal split
      result_split_horizontal = false,
      -- Skip SSL verification, useful for unknown certificates
      skip_ssl_verification = false,
      -- Highlight request on run
      highlight = {
        enabled = true,
        timeout = 150,
      },
      result = {
        -- toggle showing URL, HTTP info, headers at top the of result window
        show_url = true,
        show_http_info = true,
        show_headers = true,
      },
      -- Jump to request line on run
      jump_to_request = false,
      env_file = '.env',
      custom_dynamic_variables = custom_dynamic_variables,
      yank_dry_run = true,
    })
  end
}

M.ledger = {
  mappings = function()
    local ok, wk = pcall(require, 'which-key')
    if ok then
      wk.register({
        t = {
          name = 'Transaction State',
          t = { function() vim.cmd(":call ledger#transaction_state_toggle(line('.'), ' *?!')") end, 'Toggle State' },
          c = { function() vim.cmd(":call ledger#transaction_state_set(line('.'), '*')") end, 'Clear Transaction' },
          p = { function() vim.cmd(":call ledger#transaction_state_set(line('.'), '!')") end, 'Set Transaction to Pending' },
          u = { function() vim.cmd(":call ledger#transaction_state_set(line('.'), '?')") end, 'Set Transaction to Unknown' },
          d = 'which_key_ignore',
          n = 'which_key_ignore',
          o = 'which_key_ignore',
        }
      }, {
        buffer = 0,
        mode = 'n',
        silent = true,
        noremap = true,
        nowait = true,
        prefix = '<leader>'
      })
      wk.register({
          ["]"] = { "/^\\d", 'Next Transaction' },
          ["["] = { "?^\\d", 'Previous Transaction' }
        },
        {
          buffer = 0,
          mode = 'n',
          silent = true,
          noremap = true,
          nowait = true,
          prefix = ''
        })
    end
  end
}

M.neomutt = {
  setup = function()
    local g = vim.g

    g.notmuch_folders = {
      { 'Today',   'tag:inbox AND (NOT tag:archive) AND date:today AND (NOT tag:event)' },
      { 'Week',    'tag:inbox AND (NOT tag:archive) AND date:this_week AND (NOT tag:github) AND (NOT tag:event)' },
      { 'Month',   'tag:inbox AND (NOT tag:archive) AND date:this_month AND (NOT tag:github) AND (NOT tag:event)' },
      { 'Github',  'tag:inbox AND tag:github AND (NOT tag:archive)' },
      { 'Events',  'tag:inbox AND tag:event' },
      { 'Inbox',   'tag:inbox' },
      { 'Sent',    'tag:sent' },
      { 'Todo',    'tag:todo' },
      { 'Archive', 'tag:archive' },
      { 'Junk',    'tag:junk' },
    }

    g.notmuch_custom_folder_maps = {
      [',y'] = 'search("Today")',
      [',w'] = 'search("Week")',
      [',m'] = 'search("Month")',
      [',g'] = 'search("Github")',
      [',a'] = 'search("Archive")',
      [',i'] = 'search("Inbox")',
      c = 'folders()',
      m = 'compose()',
    }

    g.notmuch_custom_show_maps = {
      A = 'show_tag("-inbox !archive !unread")',
      E = 'show_tag("!todo")',
      c = 'folders()',
      m = 'compose()',
    }
    g.notmuch_custom_search_maps = {
      c = 'folders()',
    }

    g.notmuch_reader = 'neomutt -f %s'
  end
}

M.which_key = {
  setup = function()
    require('which-key').setup {
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on ' in NORMAL or <C-r> in INSERT mode
        spelling = {
          enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
          suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
          operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
          motions = false, -- adds help for motions
          text_objects = false, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = true, -- misc bindings to work with windows
          z = true, -- bindings for folds, spelling and others prefixed with z
          g = true, -- bindings for prefixed with g
        },
      },
      icons = {
        breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
        separator = '➜', -- symbol used between a key and it's label
        group = '+', -- symbol prepended to a group
      },
      window = {
        border = 'none', -- none, single, double, shadow
        position = 'bottom', -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
      },
      layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = 'left', -- align columns left, center or right
      },
      ignore_missing = true,
      hidden = { '<silent>', '<cmd>', '<Cmd>', '<CR>', 'call', 'lua', '^:', '^ ' }, -- hide mapping boilerplate
      show_help = true, -- show help message on the command line when the popup is visible
    }
  end
}
return M
