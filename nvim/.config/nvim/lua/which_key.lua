local M = {}
local autocmd = require'utils'.autocmd

M.setup = function()
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
    hidden = { '<silent>', '<cmd>', '<Cmd>', '<CR>', 'call', 'lua', '^:', '^ '}, -- hide mapping boilerplate
    show_help = true, -- show help message on the command line when the popup is visible
  }
end
M.load_maps = function ()
  local opts ={
    mode = "n", -- NORMAL mode
    -- prefix: use "<leader>f" for example for mapping everything related to finding files
    -- the prefix is prepended to every mapping part of `mappings`
    prefix = "",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    triggers = {'<leader>', '\\'}, -- manually setup triggers, auto is not working
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
  }
  require('which-key').register(
      {
        ['[n'] = 'Go to previous failed test',
        [']n'] = 'Go to next failed test',
        ['\\'] = {
          ['zz'] = 'QuitAll'
        },
        ['<leader>'] = {
          g = {
            name = 'Git',
            m = {'Blame/Messages'}
          },
          p = 'Git Files',
          t = {
            name = 'Ultest/Neotest',
            f = 'Run Tests in File',
            n = 'Run Nearest',
            s = 'Summary Toggle',
            c = 'Ultest Clear',
            d = {
              name = 'Debug',
              d = 'File',
              n = 'Nearest',
            },
            o = 'Show Output',
            O = 'Show and Jump Into Output',
          },
          d = {
            name = 'Debug / Doge',
            d = {'Choose debugger / Continue'},
            b = {'Toggle breakpoint'},
            R = {'Restart debugger'},
            --L = {'Launch Filetype Debugger'},
            T = {'Debug Filetype Test'},
            e = {'Close / Reset debugger'},
            i = {'Step into'},
            o = {'Step over'},
            k = {'Step out'},
            rc = {'Run to cursor'},
            rp = {'Open REPL'},
            cb = {'Toggle conditional breakpoint'},
            --X = {'Clear all breakpoints'},
            K = {'Inspect'},
            c = {'Code window'},
            t = {'Tag window'},
            v = {'Variables window'},
            --w = {'Watches window'},
            --s = {'Stack trace window'},
          },
          x = {
            name = 'Diagnostics',
            t = {
              name = 'Todo',
              x = {'Show todo'}
            },
            x = {'Toggle Trouble window'},
            w = {'Show workspace diagnostics'},
            d = {'Show document diagnostics'},
            q = {'Show quickfix window'},
            l = {'Show location window'},
            D = {'Disable diagnostics'}
          },
          y = {
            name = 'Yank',
            g = { 'Yank Git URL to clipboard'}
          },
          f = {
            name ='Fzf',
            f = { 'Files'},
            o = { 'Most Used Files'},
            M = { 'Manpages'},
            h = { 'Help'},
          },
          ['fm'] = { 'ViFm' },
        }
      }, opts
    )
end
return M