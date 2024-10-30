return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/neotest-go',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'antoinemadec/FixCursorHold.nvim'
    },
    config = function()
      require('plugins.configs.test').setup()
    end
  }
}
