return {
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('plugins.configs.treesitter').setup()
    end,
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-refactor',
      'nvim-treesitter/nvim-treesitter-textobjects',
      {
        'nvim-treesitter/playground',
        cmd = 'TSPlaygroundToggle'
      }
    }
  }
}
