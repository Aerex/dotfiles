return
{

  {
    'folke/which-key.nvim',
    config = function()
      require 'plugins.configs.misc'.which_key.setup()
    end
  },
  {
    'glepnir/galaxyline.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function() require('plugins.configs.ui').galaxyline() end
  },
  {
    'AndrewRadev/bufferize.vim',
    cmd = { 'Bufferize' }
  },
  {
    'kevinhwang91/nvim-bqf',
    dependencies = {
      'junegunn/fzf',
      build = ':call fzf#install()'
    },
    ft = 'qf',
    cmd = 'QuickFixCmdPost',
    opts = {
      func_map = {
        tab = '<C-t>',
        split = '<C-s>',
        vsplit = '<C-v>',
        stoggleup = 'K',
        stoggledown = 'J',

        ptoggleitem = 'p',
        ptoggleauto = 'P',
        ptogglemode = 'zp',

        pscrollup = '<C-b>',
        pscrolldown = '<C-f>',

        prevfile = '[f',
        nextfile = ']f',

        prevhist = '<C-p>',
        nexthist = '<C-n>',
      }
    },
    config = function()
      require 'qf'
    end
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
