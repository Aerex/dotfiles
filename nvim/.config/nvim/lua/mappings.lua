local utils = require('utils')
local t = utils.t
local autocmd = utils.autocmd

-- slower to access vim.api direct
local api = vim.api
local M = {}

function _G.smart_carrier_return()
  return vim.v.hlsearch == 1 and ':noh' .. t'<cr>' or t'<CR>'
end

local noremaps = {
    n = {
      -- misc
      ['<leader>w']   = 'write',
      ['<C-a>']       = '<NOP>', --disable due to tmux prefix
      ['\\zz']        = 'quitall!',
      ['<leader>rb']  = 'edit',
      ['<leader>b']   = 'lua require(\'nvim-fzf.buffer\')()',
      ['<leader>rc']                                                 = function() require'nvim-reload'.Reload() end,
      ['<C-Space>']                                                  = function() require'notify'.dismiss() end,
      ['[t']          = 'tabprevious',
      [']t']          = 'tabnext',
      -- trouble
      ['<leader>xx']  = 'TroubleToggle',
      ['<leader>xw']  = 'TroubleToggle workspace_diagnostics',
      ['<leader>xd']  = 'TroubleToggle document_diagnostics',
      ['<leader>xq']  = 'TroubleToggle quickfix',
      ['<leader>xl']  = 'TroubleToggle loclist',
      ['<leader>xtq'] = 'TodoQuickFix',
      ['<leader>xtl'] = 'TodoLocList',
      ['<leader>xtx'] = 'TodoTrouble',
      -- vifm
      ['<leader>fm']  = 'VsplitVifm',
      ['<leader>Fm']  = 'Vifm',
      -- fzf
      ['<leader>ff']                                                 = function() require'nvim-fzf.files'() end,
      ['<leader>fh']                                                 = function() require'nvim-fzf.helptags'() end,
      ['<leader>fo']                                                 = 'lua require(\'nvim-fzf.mru\').get_mru()',
      ['<leader>fM']                                                 = function() require'nvim-fzf.manpages'()end,
      -- TODO: telescope seems faster here need to figure out why fzf is not
      ['<leader>p']                                                  = function() require'nvim-telescope'.git_files() end,
      [',p']                                                        = function() require'nvim-fzf.git'() end,
      ['<leader>rg']                                                 = function() require'nvim-telescope'.rg_search() end,
      ['<leader>\\rg']                                                 = function() require'nvim-fzf.rg'() end,
      ['\\rG']                                                        = function() require'nvim-fzf.rg'(vim.fn.expand('<cword>'), true) end,
      ['\\rg']                                                        = function() require'nvim-telescope'.rg_string() end,
      [',rg']                                                        = function() require'nvim-fzf.rg'(vim.fn.input('Search term: '), true) end,
      ['<leader>nv']                                                 = function() require'nvim-fzf.notes'() end,
      ['<leader>yr']                                                 = 'YankyRingHistory',
      -- docs
      ['<leader>dg'] = 'DogeGenerate',
      -- snippets
      ['<leader>ue']                                                 = 'UltiSnipsEdit',
      -- git
      ['<leader>gS']                                                 = 'Git',
      ['<leader>gl']                                                 = 'Git log',
      ['<leader>gd']                                                 = 'Gdiffsplit!',
      ['<leader>gb']                                                 = 'Git blame',
      ['<leader>gw']                                                 = 'Gwrite',
      ['<leader>gp']                                                 = 'Git push',
      ['<leader>gc']                                                 = 'Neogit commit',
      ['<leader>gz']                                                 = 'lua require\'terminals\'.lazygit_toggle()',
      ['<leader>gm']                                                 = 'GitMessenger',
      -- neogit variant
      ['<leader>gs']                                                 = 'Neogit kind=split_above',
      -- TODO: create map for git push --set-upstream current branch
      -- test
      ['<leader>tf']                                                 = function() require('test').test_file() end,
      ['<leader>tn']                                                 = function() require('test').test_nearest() end,
      ['<leader>ts']                                                 = function() require('test').summary() end,
      ['<leader>tc']                                                 = 'UltestClear',
      ['<leader>to']                                                 = function() require('test').output() end,
      ['<leader>tO']                                                 = function() require('test').output({enter = true}) end,
      -- debugger
      ['<leader>dd']                                                 = 'lua require\'debugger\'.start_or_continue()',
      ['<F5>']                                                       = function() require'debugger'.start_or_continue() end,
      ['<leader>dbb']                                                 = 'lua require\'dap\'.toggle_breakpoint()',
      ['<F9>']                                                       = 'lua require\'dap\'.toggle_breakpoint()',
      ['<leader>dso']                                                 = 'lua require\'dap\'.step_over()',
      ['<F10>']                                                      = 'lua require\'dap\'.step_over()',
      ['<leader>dsO']                                                 = 'lua require\'dap\'.step_out()',
      ['<leader>dsi']                                                 = 'lua require\'dap\'.step_into()',
      ['<leader>dR']  = 'lua require\'dap\'.disconnect({restart = true })',
      ['<leader>drc'] = 'lua require\'dap\'.run_to_cursor()',
      ['<leader>dK']  = 'lua require\'dap.ui.widgets\'.hover()',
      ['<leader>dv']  = 'lua require\'dapui\'.float_element(\'scopes\', { enter = true })',
      ['<leader>dbl'] = function() require'debugger'.toggle_breakpoints_qf() end,
      ['<leader>tdd']  = function() require'test'.debug_file() end,
      ['<leader>tdn']  = function() require'test'.debug_nearest() end,
      ['<leader>du']  = 'lua require\'dapui\'.toggle()',
      -- TODO: Need to make a method to only call method if running debugger (might set a global variable on debug session)
      ['<leader>drp']  = 'lua require\'dap\'.repl.toggle()<CR><C-w>b',
      ['<leader>drP']  = 'lua require\'dapui\'.float_element(\'repl\', { width = 75, enter = true })',
      ['<leader>de']    = 'lua require\'dap\'.disconnect({terminateDebuggee = true })',
      ['<leader>dcb']   = 'lua require\'dap\'.set_breakpoint(vim.fn.input(\'Breakpoint condition: \'))',
      ['<leader>dlb'] = 'lua require\'dap\'.set_breakpoint(nil, nil, vim.fn.input(\'Log point message: \'))',
      ['<leader>d,l'] = 'lua require\'dap\'.set_log_level("TRACE")',
      ['<leader>dL']         =  'DapShowLog',
        -- fcitx
      ['<M-Tab>'] = 'lua require\'fcitx5\'.toggle()',
      -- scratch
      ['<M-C-n>'] = function() require'scratch'.scratch() end,
      ['<M-C-m>'] = function() require'scratch'.scratchWithName() end,
      ['<M-C-o>'] = function() require'scratch'.fzfScratch() end
    }
  }


local maps = {
  n = {
    -- misc
    ['<leader>w']    = 'write',
    ['<C-a>']        = '<NOP>', --disable due to tmux prefix
    ['\\zz']         = 'quitall!',
    ['<leader>rb']   = 'edit',
    ['<leader>b']    = function() require 'telescope.builtin'.buffers() end,
    ['<leader>rc']   = function() require 'nvim-reload'.Reload() end,
    ['<C-Space>']    = function() require 'notify'.dismiss() end,
    ['[t']           = 'tabprevious',
    [']t']           = 'tabnext',
    -- trouble
    ['<leader>xx']   = 'TroubleToggle',
    ['<leader>xw']   = 'TroubleToggle workspace_diagnostics',
    ['<leader>xd']   = 'TroubleToggle document_diagnostics',
    ['<leader>xq']   = 'TroubleToggle quickfix',
    ['<leader>xl']   = 'TroubleToggle loclist',
    ['<leader>xtq']  = 'TodoQuickFix',
    ['<leader>xtl']  = 'TodoLocList',
    ['<leader>xtx']  = 'TodoTrouble',
    -- vifm
    ['<leader>fm']   = 'VsplitVifm',
    ['<leader>Fm']   = 'Vifm',
    -- fzf
    ['<leader>ff']   = function() require 'nvim-fzf.files' () end,
    ['<leader>fh']   = function() require 'nvim-fzf.helptags' () end,
    ['<leader>fo']   = function() require 'nvim-fzf.mru'.get_mru() end,
    ['<leader>fM']   = function() require 'nvim-fzf.manpages' () end,
    ['<leader>p']    = function() require 'nvim-telescope'.git_files() end,
    [',p']           = function() require 'nvim-fzf.git' () end,
    ['<leader>rg']   = function() require 'nvim-telescope'.rg_search() end,
    ['<leader>\\rg'] = function() require 'nvim-fzf.rg' () end,
    ['\\rG']         = function() require 'nvim-fzf.rg' (vim.fn.expand('<cword>'), true) end,
    ['\\rg']         = function() require 'nvim-telescope'.rg_string() end,
    [',rg']          = function() require 'nvim-fzf.rg' (vim.fn.input('Search term: '), true) end,
    ['<leader>nv']   = function() require 'nvim-fzf.notes' () end,
    ['<leader>yr']   = 'YankyRingHistory',
    -- docs
    ['<leader>dg']   = 'DogeGenerate',
    -- snippets
    ['<leader>ue']   = 'UltiSnipsEdit',
    -- git
    ['<leader>gS']   = 'Git',
    ['<leader>gl']   = 'Git log',
    ['<leader>gd']   = 'Gdiffsplit!',
    ['<leader>gb']   = 'Git blame',
    ['<leader>gw']   = 'Gwrite',
    ['<leader>gp']   = 'Git push',
    ['<leader>gc']   = 'Neogit commit',
    ['<leader>gz']   = 'lua require\'terminals\'.lazygit_toggle()',
    ['<leader>gm']   = 'GitMessenger',
    -- neogit variant
    ['<leader>gs']   = 'Neogit kind=split_above',
    -- TODO: create map for git push --set-upstream current branch
    -- test
    ['<leader>tf']   = function() require('test').test_file() end,
    ['<leader>tn']   = function() require('test').test_nearest() end,
    ['<leader>ts']   = function() require('test').summary() end,
    ['<leader>tc']   = 'UltestClear',
    ['<leader>to']   = function() require('test').output() end,
    ['<leader>tO']   = function() require('test').output({ enter = true }) end,
    -- debugger
    ['<leader>dd']   = function() require 'debugger'.start_or_continue() end,
    ['<leader>dll']  = function() require 'dap'.run_last() end,
    ['<F5>']         = function() require 'debugger'.start_or_continue() end,
    ['<leader>dbb']  = 'lua require\'dap\'.toggle_breakpoint()',
    ['<F9>']         = 'lua require\'dap\'.toggle_breakpoint()',
    ['<leader>dso']  = function() require 'dap'.step_over() end,
    ['<F10>']        = 'lua require\'dap\'.step_over()',
    ['<leader>dsO']  = 'lua require\'dap\'.step_out()',
    ['<leader>dsi']  = 'lua require\'dap\'.step_into()',
    ['<leader>dR']   = 'lua require\'dap\'.disconnect({restart = true })',
    ['<leader>drc']  = 'lua require\'dap\'.run_to_cursor()',
    ['<leader>dK']   = 'lua require\'dap.ui.widgets\'.hover()',
    ['<leader>dv']   = 'lua require\'dapui\'.float_element(\'scopes\', { enter = true })',
    ['<leader>dbl']  = function() require 'debugger'.toggle_breakpoints_qf() end,
    ['<leader>tdd']  = function() require 'test'.debug_file() end,
    ['<leader>tdn']  = function() require 'test'.debug_nearest() end,
    ['<leader>du']   = 'lua require\'dapui\'.toggle()',
    -- TODO: Need to make a method to only call method if running debugger (might set a global variable on debug session)
    ['<leader>drp']  = 'lua require\'dap\'.repl.toggle()<CR><C-w>b',
    ['<leader>drP']  = 'lua require\'dapui\'.float_element(\'repl\', { width = 75, enter = true })',
    ['<leader>de']   = 'lua require\'dap\'.disconnect({terminateDebuggee = true })',
    ['<leader>dcb']  = 'lua require\'dap\'.set_breakpoint(vim.fn.input(\'Breakpoint condition: \'))',
    ['<leader>dlb']  = 'lua require\'dap\'.set_breakpoint(nil, nil, vim.fn.input(\'Log point message: \'))',
    ['<leader>d,l']  = 'lua require\'dap\'.set_log_level("TRACE")',
    ['<leader>dL']   = 'DapShowLog',
    -- fcitx
    ['<M-Tab>']      = 'lua require\'fcitx5\'.toggle()',
    -- scratch
    ['<M-C-n>']      = function() require 'scratch'.scratch() end,
    ['<M-C-m>']      = function() require 'scratch'.scratchWithName() end,
    ['<M-C-o>']      = function() require 'scratch'.fzfScratch() end
  }
}

local file_type_keymaps = {
  markdown = {
    nnoremap =  {
      ['<leader>mp'] = 'MarkdownPreview',
      ['<leader>ms'] = 'MarkdownPreviewStop',
      ['<leader>mt'] = 'MarkdownPreviewToggle'
    }
  },
  vimwiki = {
    nmap = {
      ['\\w='] = '<Plug>VimwikiAddHeaderLevel',
      ['\\w-'] = '<Plug>VimwikiRemoveHeaderLevel',
      ['\\wx'] = '<Plug>VimwikiIndex'
    }
  },
  http = {
    nmap = {
      ['<CR>'] = 'lua require\'rest-nvim\'.run()',
      ['K'] = 'lua require\'rest-nvim\'.run(true)'
    }
  }
}

-- misc
vim.keymap.set({'n','x'}, 'p', '<Plug>(YankyPutAfter)')
vim.keymap.set({'n','x'}, 'P', '<Plug>(YankyPutBefore)')
vim.keymap.set({'n','x'}, 'gp', '<Plug>(YankyGPutAfter)')
vim.keymap.set({'n','x'}, 'gP', '<Plug>(YankyGPutBefore)')

vim.keymap.set('n', '<leader><enter>', ':', { silent = true })
vim.keymap.set('n', '<A-a>', '<C-a>', { silent = true })
vim.keymap.set('n', ']n', function() require'test'.next_fail() end, { silent = true })
vim.keymap.set('n', '[n', function() require'test'.prev_fail() end, { silent = true })
vim.keymap.set('n', '!', ':!', { silent = true })
vim.keymap.set('v', '<leader>yg', function() require 'gitlinker'.get_buf_range_url('v', {}) end, { silent = true })
vim.keymap.set('n', '<leader>yg', function() require 'gitlinker'.get_buf_range_url('n', {}) end, { silent = true })
vim.keymap.set('n', '<leader>sp', function() vim.notify(vim.fn.expand('%:p')) end, { silent = true })
api.nvim_set_keymap('n', '<CR>', 'v:lua.smart_carrier_return()', { expr = true })
api.nvim_set_keymap('n', '<C-w><leader>', '<C-w>=', { noremap = true, silent = true })
autocmd('TermOpen', {
  pattern = '*toggleterm#*',
  callback = function()
    require'terminals'.set_terminal_keymaps()
  end
})
api.nvim_set_keymap('', '<F2>', ":echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, \"name\")')<CR>", { silent = true})
autocmd('FileType', {
  pattern = '{lspinfo},{qf},{dap-repl},{man},{help},{fugitiveblame},{dap-float},{httpResult}',
  callback = function(args)
    vim.keymap.set('n', 'qq', function() api.nvim_win_close(0, true) end,
      { silent = true, buffer = args.buf })
  end
})

-- TableMode

vim.g['table_mode_motion_left_map'] = ']\\'
vim.g['table_mode_motion_right-map'] = '[\\'
vim.g['table_mode_motion_up-map']= '}\\'
vim.g['table_mode_motion_down-map'] = '{\\'



-- @param {table} m
-- @param {table|nil} opts
M.set_keymap = function(m, opts, callback)
  -- Credits to https://github.com/bsuth/dots/blob/c6fc019b417d2a32e31f4099228ffa6d89944e81/nvim/lua/mappings.lua
  opts = opts or { silent = true }
  for mode, modebindings in pairs(m) do
    for lhs, rhs in pairs(modebindings) do
      -- Append <cmd> and <cr> to better for vim command (exclude <Plug> commands)
      if type(rhs) == 'function' then
        vim.keymap.set(mode, lhs, rhs, opts)
      elseif type(rhs) == 'string' then
        if not string.find(rhs, 'v:lua') and not string.find(rhs, '<Plug>') then
          rhs = '<cmd>' .. rhs .. '<cr>'
        end
        api.nvim_set_keymap(mode, lhs, rhs, opts)
      end
    end
  end
end

M.set_filetype_keymap = function(m)
  for filetype, filetype_bindings in pairs(m) do
    for mode, modebindings in pairs(filetype_bindings) do
      for lhs, rhs in pairs(modebindings) do
        local cmd_prefix = "<cmd>"
        if string.find(rhs, '<Plug>') then
          cmd_prefix = ""
        end
        local cmd = string.format('autocmd FileType %s %s  %s %s%s<cr>', filetype, mode, lhs, cmd_prefix, rhs)
        api.nvim_exec(cmd, '')
      end
    end
  end
end

M.set_keymap(noremaps, { silent = true, noremap = true })
M.set_filetype_keymap(file_type_keymaps)

-- load which-keys if available
require 'which_key'.load_maps()


return M
