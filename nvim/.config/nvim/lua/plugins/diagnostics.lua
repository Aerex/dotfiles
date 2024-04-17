return {
  {
    'folke/trouble.nvim',
    cmd = { 'Trouble', 'TroubleToggle', 'TroubleClose', 'TroubleRefresh' }
  },
  {
    'folke/todo-comments.nvim',
    event = 'BufRead',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      require('plugins.diagnostics').setup()
    end
  }
}
