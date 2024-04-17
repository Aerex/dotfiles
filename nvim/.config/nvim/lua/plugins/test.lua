return {
  {
    'rcarriga/vim-ultest',
    cmd = { 'Ultest', 'UltestNearest' },
    build = ':UpdateRemotePlugins',
    setup = function()
      vim.g.ultest_deprecation_notice = 0
    end,
    dependencies = { { 'vim-test/vim-test', cmd = { 'TestFile', 'TestLast', 'TestSuite', 'TestVisit', 'TestNearest' } } },
    config = function()
      require('configs.test').setup()
    end
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/neotest-go',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'antoinemadec/FixCursorHold.nvim'
    },
    config = function()
      require('configs.test').setup()
    end
  }
}
