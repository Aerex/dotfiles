return {
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('plugins.configs.treesitter').setup()
    end,
    build = ':TSUpdate',
    branch = 'main',
    init = function ()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          -- Enable treesitter highlighting and disable regex syntax
          pcall(vim.treesitter.start)
          -- Enable treesitter-based indentation
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-locals',
      {
            'nvim-treesitter/nvim-treesitter-textobjects',
            branch = 'main'
      }
    }
  }
}
