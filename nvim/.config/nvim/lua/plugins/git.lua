return {
  {
    'tpope/vim-fugitive',
    cmd = {
      'Git', 'Gpush', 'GBrowse', 'Gdiffsplit'
    },
    dependencies = { 'tpope/vim-rhubarb' }
  },
  {
    'ruifm/gitlinker.nvim',
    config = function()
      require('plugins.configs.git').setup_gitlinker()
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = { 'BufRead' },
    config = function()
      require('plugins.configs.git').setup_signs()
    end
  },
  {
    lazy = true,
    'rhysd/git-messenger.vim',
    cmd = { 'GitMessenger' }
  },
  {
    lazy = true,
    'Aerex/gh.nvim',
    dependencies = { 'ldelossa/litee.nvim' },
    config = function()
      require 'litee.lib'.setup(); require 'litee.gh'.setup()
    end
  },
  {
    'TimUntersberger/neogit',
    cmd = { 'Neogit' },
    config = function()
      require('plugins.configs.git').setup_neogit()
    end,
    dependencies = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' }
  }
}
