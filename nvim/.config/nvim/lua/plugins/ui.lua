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
  },
  {
    'norcalli/nvim-colorizer.lua',
    config = function() require('colorizer').setup() end
  },
  'chriskempson/base16-vim',
  {
    'rmehri01/onenord.nvim',
    config = function()
      require('plugins.configs.ui').colors.setup()
    end
  },
  'miyakogi/seiya.vim', -- enable transparent background
  {
    'p00f/nvim-ts-rainbow',
    dependencies = { 'nvim-treesitter/nvim-treesitter' }
  },
  {
    'glepnir/galaxyline.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function() require('plugins.configs.ui').galaxy() end
  },
  {
    'alvarosevilla95/luatab.nvim',
    dependencies = 'kyazdani42/nvim-web-devicons',
    config = function()
      require 'luatab'.setup {}
    end
  }
}
