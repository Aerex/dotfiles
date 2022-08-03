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
      ['<leader>rb']  = 'edit',
      ['<leader>b']  = 'lua require(\'nvim-fzf.buffer\')()',
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
      ['<leader>ff']  = 'lua require(\'nvim-fzf.files\')()',
      ['<leader>fh']  = 'lua require(\'nvim-fzf.helptags\')()',
      ['<leader>fM']  = 'lua require(\'nvim-fzf.manpages\')()',
      ['<leader>p']   = 'lua require(\'nvim-fzf.git\')()',
      ['<leader>rg']  = 'lua require(\'nvim-fzf.rg\')()',
      ['\\rg']        = 'lua require(\'nvim-fzf.rg\')(vim.fn.expand("<cword>"))',
      [',rg']         = 'lua require(\'nvim-fzf.rg\')(vim.fn.input("Search term: "))',
      ['<leader>nv']  = 'lua require(\'nvim-fzf.notes\')()',
      ['<leader>yr']                                                 = 'lua require(\'nvim-fzf.yank-history\')()',
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
      -- neogit variant
      ['<leader>gs']                                                 = 'Neogit kind=split_above',
      -- TODO: create map for git push --set-upstream current branch
      -- test
      ['<leader>tf']                                                 = 'Ultest',
      ['<leader>tn']                                                 = 'UltestNearest',
      ['<leader>ts']                                                 = 'UltestSummary!',
      ['<leader>tc']                                                 = 'UltestClear',
      ['<leader>to']                                                 = 'UltestOutput',
      ['<leader>tO']                                                 = 'call ultest#output#jumpto()',
      -- debugger
      ['<leader>dd']                                                 = 'lua require\'debugger\'.start_or_continue()',
      ['<leader>dD']                                                 = 'lua require\'dap.ext.vscode\'.load_launchjs(vim.lsp.buf.list_workspace_folders()[1] .. \'/.vscode/launch.json\')',
      ['<F5>']                                                       = 'lua require\'dap\'.continue()',
      ['<leader>db']                                                 = 'lua require\'dap\'.toggle_breakpoint()',
      ['<F9>']                                                       = 'lua require\'dap\'.toggle_breakpoint()',
      ['<leader>dso']                                                 = 'lua require\'dap\'.step_over()',
      ['<F10>']                                                      = 'lua require\'dap\'.step_over()',
      ['<leader>dsO']                                                 = 'lua require\'dap\'.step_out()',
      ['<leader>dsi']                                                 = 'lua require\'dap\'.step_into()',
      ['<leader>dR']  = 'lua require\'dap\'.disconnect({restart = true })',
      ['<leader>drc'] = 'lua require\'dap\'.run_to_cursor()',
      ['<leader>dK']  = 'lua require\'dap.ui.widgets\'.hover()',
      ['<leader>dv']  = 'lua require\'dapui\'.float_element(\'scopes\', { enter = true })',

      ['<leader>tdd']  = 'UltestDebug',
      ['<leader>tdn']  = 'UltestDebug:Nearest',
      ['<leader>du']  = 'lua require\'dapui\'.toggle()',
      -- TODO: Need to make a method to only call method if running debugger (might set a global variable on debug session)
      ['<leader>drp']  = 'lua require\'dap\'.repl.toggle()<CR><C-w>l',
      ['<leader>drP']  = 'lua require\'dapui\'.float_element(\'repl\', { width = 75, enter = true })',
      ['<leader>de']    = 'lua require\'dap\'.disconnect({terminateDebuggee = true })',
      ['<leader>dcb']   = 'lua require\'dap\'.set_breakpoint(vim.fn.input(\'Breakpoint condition: \'))',
      ['<leader>dLb'] = 'lua require\'dap\'.set_breakpoint(nil, nil, vim.fn.input(\'Log point message: \'))',
      ['<leader>d;'] = 'lua require\'dap\'.list_breakpoints();require\'trouble\'.toggle({providers = \'quickfix\'})',
      ['<leader>d,l'] = 'lua require\'dap\'.set_log_level("TRACE")',
        -- fcitx
      ['<M-Tab>'] = 'lua require\'fcitx5\'.toggle()',
      ['<leader>d;'] = 'lua require\'debugger\'.toggle_breakpoints_qf()',
      ['<leader>d,l'] = 'lua require\'dap\'.set_log_level("TRACE")'
    },
    v = {
      ['<leader>yg']  = 'GBrowse!',
      ['<leader>dk']  = 'lua require\'dap.ui.variables\'.visual_hover()',
    }
  }

     --['leader>dl :lua require'dap'.run_last()<CR>

local maps = {
  n = {
    p = '<Plug>(miniyank-autoput)',
    P = '<Plug>(miniyank-autoPut)'
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
vim.api.nvim_set_keymap('n', '<leader><enter>', ':', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<CR>', 'v:lua.smart_carrier_return()', { expr = true })
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-w><leader>', '<C-w>=', { noremap = true, silent = true })
vim.cmd('autocmd! TermOpen *toggleterm#* lua require\'terminals\'.set_terminal_keymaps()')
vim.api.nvim_set_keymap('', '<F2>', ":echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, \"name\")')<CR>", { silent = true})
autocmd('FileType', {
  pattern = '{lspinfo},{qf},{dap-repl}',
  callback = function(args)
    vim.keymap.set('n', 'qq', function() vim.api.nvim_win_close(0, true) end,
    { silent = true, buffer = args.buf})
  end
})



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
        vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
      end
    end
  end
end

M.set_filetype_keymap = function(m)
  for filetype, filetype_bindings in pairs(m) do
    for mode, modebindings in pairs(filetype_bindings) do
      for lhs, rhs in pairs (modebindings) do
        local cmd = string.format('autocmd FileType %s %s  %s <cmd>%s<cr>', filetype, mode, lhs, rhs)
        vim.api.nvim_exec(cmd, '')
      end
    end
  end
end

M.set_keymap(noremaps, { silent = true, noremap = true })
M.set_keymap(maps)
M.set_filetype_keymap(file_type_keymaps)

-- load which-keys if available
require'which_key'.load_maps()


return M
