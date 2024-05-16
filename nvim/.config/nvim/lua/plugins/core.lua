require {

  { 'nathom/filetype.nvim' },
  { 'lewis6991/impatient.nvim' },
  {
    lazy = true,
    'famiu/nvim-reload'
  },
  {
    'tweekmonster/startuptime.vim'
  },

  {
    'kshenoy/vim-signature'
  },
  {
    'kylechui/nvim-surround'
  },
  {
    lazy = true,
    'tpope/vim-repeat'
  },
  {
    lazy = true,
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    config = function()
      vim.g.undotree_SetFocusWhenToggle = 1
    end
  },
  {
    'gbprod/yanky.nvim',
    config = function()
      require'configs.core'.yanky()
    end
  },
  {
    'kshenoy/vim-signature'
  },
  {

    'AndrewRadev/bufferize.vim',
    cmd = { 'Bufferize' }
  },
  {
    'kevinhwang91/nvim-bqf',
    dependencies = {
      'junegunn/fzf',
      build = function()
        vim.fn['fzf#install']()
      end
    },
    ft = 'qf',
    config = function()
      require 'qf'
    end
  },
  {
    'akinsho/nvim-toggleterm.lua',
    config = function()
      require 'toggleterm'.setup {
        open_mapping = [[<C-t>]],
        shading_factor = 1,
        direction = 'float'
      }
    end
  },
  {
    'tpope/vim-dispatch',
    cmd = { 'Dispatch' }
  },
  {
    'tweekmonster/startuptime.vim'
  }
}
