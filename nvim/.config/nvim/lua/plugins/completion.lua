return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp',
      'kirasok/cmp-hledger',
      'hrsh7th/cmp-cmdline',
      'dmitmel/cmp-cmdline-history',
      {
        'davidsierradz/cmp-conventionalcommits',
        ft = { 'NeogitCommitMessage'     }
      },
      'uga-rosa/cmp-dictionary',
      {
        lazy = true,
        'lukas-reineke/cmp-rg'
      },
      'hrsh7th/cmp-look', -- dictionary source
      'f3fora/cmp-spell', -- spell source
      {
        'SirVer/ultisnips',
        'quangnguyen30192/cmp-nvim-ultisnips',
        'honza/vim-snippets',
      }
    },
    config = function()
      require('configs.completion')
    end,
  }
}
