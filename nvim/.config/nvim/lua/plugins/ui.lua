return
{

  {
    'folke/which-key.nvim',
    config = function()
      require 'plugins.configs.misc'.which_key.setup()
    end
  },
  {
    'AndrewRadev/bufferize.vim',
    cmd = { 'Bufferize' }
  },
  {
    'rcarriga/nvim-notify',
    config = function()
      require 'notify'.setup({
        background_colour = "#646A76",
        timeout = 1500,
        render = 'minimal'
      })
    end
  }
}
