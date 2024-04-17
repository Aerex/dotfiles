require {
  {
    'mfussenegger/nvim-dap',
    dependencies = { 'rcarriga/nvim-dap-ui', 'mfussenegger/nvim-dap-python', 'theHamsta/nvim-dap-virtual-text' },
    config = function()
      require('configs.debugger')
    end
  }
}
