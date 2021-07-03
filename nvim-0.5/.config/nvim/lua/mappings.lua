local M = {}
local maps = {
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
      -- snippets
      ['<leader>ue'] = 'UltiSnipsEdit',
      -- git
      ['<leader>gs'] = 'Git',
      ['<leader>gd'] = 'Gdiff',
      ['<leader>gb'] = 'Git blame',
      ['<leader>gw'] = 'Gwrite',
      ['<leader>gp'] = 'Git push'

      -- TODO: create map for git push --set-upstream current branch
    }
}

local file_type_keymaps = {
  markdown = {
    nmap =  {
      ['<leader>mp'] = 'MarkdownPreview',
      ['<leader>ms'] = 'MarkdownPreviewStop',
      ['<leader>mt'] = 'MarkdownPreviewToggle'
    }
  }

}

vim.api.nvim_set_keymap('n', '<leader><enter>', ':', { noremap = true, silent = true})
-- @param {table} m
-- @param {table|nil} opts
M.set_keymap = function(m, opts)
  -- Credits to https://github.com/bsuth/dots/blob/c6fc019b417d2a32e31f4099228ffa6d89944e81/nvim/lua/mappings.lua
  for mode, modebindings in pairs(m) do
    for lhs, rhs in pairs(modebindings) do
      -- Append <cmd> and <cr> to better for vim command
      if not string.find(rhs, 'v:lua') then
        rhs = '<cmd>' .. rhs .. '<cr>'
      end
      vim.api.nvim_set_keymap(mode, lhs, rhs, opts or { noremap = true, silent = true })
    end
  end
end

M.set_filetype_keymap = function(m)
  for filetype, filetype_bindings in pairs(m) do
    for mode, modebindings in pairs(filetype_bindings) do
      for lhs, rhs in pairs (modebindings) do
        vim.api.nvim_exec(string.format('autocmd FileType %s <silent>%s  %s <cmd>%s<cr>',
          filetype, mode, lhs, rhs), '')
      end
    end
  end
end

M.set_keymap(maps)
M.set_filetype_keymap(file_type_keymaps)

return M
