local M = {}
local maps = {
    -- misc
    n = {
      -- misc
      ['<leader>w']  = 'write', ['<leader>fm'] = 'VsplitVifm',
      -- fzf
      ['<leader>ff'] = 'lua require(\'nvim-fzf.files\')()',
      ['<leader>fh'] = 'lua require(\'nvim-fzf.helptags\')()',
      ['<leader>p']  = 'lua require(\'nvim-fzf.git\')()',
      ['<leader>rg'] = 'lua require(\'nvim-fzf.rg\')()',
      ['<leader>rG'] = 'lua require(\'nvim-fzf.rg\')(vim.fn.expand("<cword>"))',
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

M.set_keymap(maps)

return M
