local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  execute 'packadd packer.nvim'
end

-- Auto compile when there are changes in plugins.lua
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile'

-- require('packer').init({display = {non_interactive = true}})
require('packer').init({display = {auto_clean = false}})
-- Only required if you have packer in your `opt` pack
local ok, _ = pcall(vim.cmd, [[packadd packer.nvim]])

if ok then
  return require('packer').startup(
    function(use)
      -- Packer can manage itself as an optional plugin
      use {'wbthomason/packer.nvim', opt = true}

      -- lsp
      use {
        'neovim/nvim-lspconfig',
        'onsails/lspkind-nvim',
       'nvim-lua/lsp-status.nvim',
	      'ray-x/lsp_signature.nvim'
      }

      -- treesitter
      use {
        { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },
        'Aerex/nvim-treesitter-textobjects',
        'nvim-treesitter/playground'
      }

      -- textobject
      use {
        'blackCauldron7/surround.nvim'
      }

      -- fuzzy pickers / file finders
      use {
        'vijaymarupudi/nvim-fzf',
        'vijaymarupudi/nvim-fzf-commands',
        'vifm/vifm.vim'
      }

      -- git
      use {
        { 'tpope/vim-fugitive', cmd = {'Git', 'Gstatus', 'Gblame', 'Gpush', 'Gpull', 'Gwrite'} },
        { 'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'} },
        -- still has some issues need to wait before using
        { 'TimUntersberger/neogit', requires = { 'nvim-lua/plenary.nvim','sindrets/diffview.nvim' } },
        { 'pwntester/octo.nvim',
          cmd = { 'Octo' },
          requires = { {'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}, {'nvim-telescope/telescope.nvim'} } }
      }

      -- yank/undo
      use {
        { 'mbbill/undotree', cmd = 'UndotreeToggle',  config = [[vim.g.undotree_SetFocusWhenToggle = 1]] },
        { 'bfredl/nvim-miniyank' }
      }

      -- diagnostics
      use { 'folke/trouble.nvim',
        cmd = {'Trouble', 'TroubleToggle', 'TroubleClose', 'TroubleRefresh' }
      }

      -- formatting / colors
      use {
        'norcalli/nvim-colorizer.lua',
        'p00f/nvim-ts-rainbow',
        'chriskempson/base16-vim',
        'miyakogi/seiya.vim',  -- enable transparent background
        'sbdchd/neoformat',
        { 'godlygeek/tabular', cmd = { 'Tabularize' } },
        { 'lukas-reineke/indent-blankline.nvim', branch = 'lua' }
      }

      -- debugger
      --use {'mfussenegger/nvim-dap'}

      -- statusline
      use {'glepnir/galaxyline.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true}}

      -- markdown
      use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}

      -- completions
      use { 'nvim-lua/completion-nvim' }

      -- snippets
      use { 'SirVer/ultisnips', requires = {{'honza/vim-snippets' }} }

      -- profiling
      use { 'tweekmonster/startuptime.vim' }

      -- marks
      use { 'kshenoy/vim-signature' }
      -- terminal
      use {
         'akinsho/nvim-toggleterm.lua',
        config = function() require'toggleterm'.setup{ open_mapping = [[<C-t>]] } end
       }
    end
    )
end
