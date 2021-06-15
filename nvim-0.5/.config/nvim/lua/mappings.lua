local maps = {
    -- misc
    n = {
      -- misc
      ['<leader>w'] = 'write',
      ['<leader>fm'] = 'VsplitVifm',
      -- fzf
      ['<leader>ff'] = 'lua require (\'nvim-fzf.files\')()',
      ['<leader>fh'] = 'lua require (\'nvim-fzf.helptags\')()',
      ['<leader>p'] = 'lua require (\'nvim-fzf.git\')()',
      -- snippets
      ['<leader>ue'] = 'UltiSnipsEdit',
      -- git
      ['<leader>gs'] = 'Git',
      ['<leader>gd'] = 'Gdiff',
      ['<leader>gb'] = 'Git blame',
      ['<leader>gw'] = 'Gwrite',
      -- TODO: create map for git push --set-upstream current branch
    }
}

-- Credits to https://github.com/bsuth/dots/blob/c6fc019b417d2a32e31f4099228ffa6d89944e81/nvim/lua/mappings.lua
for mode, modebindings in pairs(maps) do
  for lhs, rhs in pairs(modebindings) do
    -- Append <cmd> and <cr> to better insert command
    rhs = '<cmd>' .. rhs .. '<cr>'
    vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true, silent = true })
  end
end

