return {
  {
    'glepnir/galaxyline.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function() require('configs.statusline').galaxyline() end
  },
  {
    'alvarosevilla95/luatab.nvim',
    dependencies = 'kyazdani42/nvim-web-devicons',
    config = function()
      require 'luatab'.setup {}
    end
  }
}
