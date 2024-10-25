return {
  {
    'norcalli/nvim-colorizer.lua',
    config = function() require('colorizer').setup() end
  },
  'chriskempson/base16-vim',
  {
    'rmehri01/onenord.nvim',
    config = function()
      require('plugins.configs.colors').setup()
    end
  },
  'miyakogi/seiya.vim', -- enable transparent background
  {
    'p00f/nvim-ts-rainbow',
    dependencies = { 'nvim-treesitter/nvim-treesitter' }
  }
}
