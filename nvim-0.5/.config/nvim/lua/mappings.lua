local t = require('utils').t
local M = {}

function _G.smart_carrier_return()
  return vim.v.hlsearch == 1 and ':noh' .. t'<cr>' or t'<CR>'
end

local noremaps = {
    -- misc
    n = {
      -- misc
      ['<leader>w']  = 'write',
      ['<leader>fm'] = 'VsplitVifm',
      -- fzf
      ['<leader>ff'] = 'lua require(\'nvim-fzf.files\')()',
      ['<leader>fh'] = 'lua require(\'nvim-fzf.helptags\')()',
      ['<leader>p']  = 'lua require(\'nvim-fzf.git\')()',
      ['<leader>rg'] = 'lua require(\'nvim-fzf.rg\')()',
      ['<leader>rG'] = 'lua require(\'nvim-fzf.rg\')(vim.fn.expand("<cword>"))',
      ['<leader>nv'] = 'lua require(\'nvim-fzf.notes\')()',
      ['<leader>yr'] = 'lua require(\'nvim-fzf.yank-history\')()',
      -- snippets
      ['<leader>ue'] = 'UltiSnipsEdit',
      -- git
      ['<leader>gs'] = 'Git',
      ['<leader>gd'] = 'Gdiff',
      ['<leader>gb'] = 'Git blame',
      ['<leader>gw'] = 'Gwrite',
      ['<leader>gp'] = 'Git push',
      -- neogit variant
      ['<leader>gS'] = 'Neogit kind=splitabove',
      -- TODO: create map for git push --set-upstream current branch
      -- test
      ['<leader>tf'] = 'TestFile',
      ['<leader>tn'] = 'TestNearest',
      ['<leader>ts'] = 'TestSuite',
      ['<leader>tv'] = 'TestVisit',
      -- debugger
      ['<F5>']       = 'lua require\'dap\'.continue()',
      ['<F10>']      = 'lua require\'dap\'.step_over()',
      ['<F3>']      = 'lua require\'dap\'.disconnect({terminateDebuggee = true })',
      ['<F4>']      = 'lua require\'dap\'.disconnect({restart = true })',
      ['<F11>']      = 'lua require\'dap\'.step_into()',
      ['<F12>']      = 'lua require\'dap\'.step_out()',
      ['<leader>b']  = 'lua require\'dap\'.toggle_breakpoint()',
      ['<leader>B']  = 'lua require\'dap\'.set_breakpoint(vim.fn.input(\'Breakpoint condition: \'))',
      ['<leader>lb'] = 'lua require\'dap\'.set_breakpoint(nil, nil, vim.fn.input(\'Log point message: \'))'
    }
  }

     --['<leader>dr :lua require'dap'.repl.open()<CR>
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
  }
}

-- misc
vim.api.nvim_set_keymap('n', '<leader><enter>', ':', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<CR>', 'v:lua.smart_carrier_return()', { expr = true })
vim.api.nvim_set_keymap('n', '<C-w><leader>', '<C-w>=', { noremap = true, silent = true })

-- @param {table} m
-- @param {table|nil} opts
M.set_keymap = function(m, opts)
  -- Credits to https://github.com/bsuth/dots/blob/c6fc019b417d2a32e31f4099228ffa6d89944e81/nvim/lua/mappings.lua
  opts = opts or { silent = true }
  for mode, modebindings in pairs(m) do
    for lhs, rhs in pairs(modebindings) do
      -- Append <cmd> and <cr> to better for vim command (exclude <Plug> commands)
      if not string.find(rhs, 'v:lua') and not string.find(rhs, '<Plug>') then
        rhs = '<cmd>' .. rhs .. '<cr>'
      end
      vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
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

return M
