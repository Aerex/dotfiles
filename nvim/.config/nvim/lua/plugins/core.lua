return {

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
   "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end  
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
    dependencies = {
      'kkharji/sqlite.lua'
    },
    config = function()
      require 'plugins.configs.core'.yanky()
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
      require 'plugins.configs.core'.bqf.setup()
    end
  }
}
