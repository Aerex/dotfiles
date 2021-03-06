local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

-- Auto compile when there are changes in plugins.lua
vim.cmd 'autocmd BufWrite load_plugins.lua PackerCompile'

-- Mappings for packer
vim.cmd[[autocmd BufEnter load_plugins.lua noremap <leader>ps <cmd>PackerSync<cr>]]
vim.cmd[[autocmd BufEnter load_plugins.lua noremap <leader>pc <cmd>PackerCompile<cr>]]
vim.cmd[[autocmd BufEnter load_plugins.lua noremap <leader>pS <cmd>PackerStatus<cr>]]

-- Do not remove unusued plugins
require('packer').init({display = {auto_clean = false}})
-- Only required if you have packer in your `opt` pack
local ok, _ = pcall(vim.cmd, [[packadd packer.nvim]])

if ok then
  return require('packer').startup(
  function(use)
    -- Packer can manage itself as an optional plugin
    use {'wbthomason/packer.nvim'}

    -- lsp
    use {
      { 'neovim/nvim-lspconfig', config = function() require('nvim-lsp') end },
      'onsails/lspkind-nvim',
      'nvim-lua/lsp-status.nvim',
      'ray-x/lsp_signature.nvim'
    }

     -- treesitter
    use {
      'nvim-treesitter/nvim-treesitter',
      requires = {
        'nvim-treesitter/nvim-treesitter-refactor', 'nvim-treesitter/nvim-treesitter-textobjects', 'nvim-treesitter/playground'
      },
      config = function() require('treesitter') end,
      run = ':TSUpdate'
    }
    -- textobject
    use {
      'blackCauldron7/surround.nvim', config = function() require('surround').setup{} end
    }

    -- fuzzy pickers / file finders
    use {
      'vijaymarupudi/nvim-fzf',
      'vijaymarupudi/nvim-fzf-commands',
      'vifm/vifm.vim'
    }

    -- git
    use {
      { 'tpope/vim-fugitive', cmd = {'Git', 'Gpush'} },
      { 'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}, event = {'BufRead'}, config = function() require('nvim-git').setup_signs() end },
      { 'Aerex/neogit', branch = 'feat/config-split-direction', cmd = {'Neogit'}, config = function() require('nvim-git').setup_neogit() end,
        requires = { 'nvim-lua/plenary.nvim','sindrets/diffview.nvim' }},
      { 'pwntester/octo.nvim',
      cmd = { 'Octo' },
      requires = { {'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}, {'nvim-telescope/telescope.nvim'} } }
    }

      -- yank/undo
      use {
        { 'mbbill/undotree', cmd = 'UndotreeToggle',  config = [[vim.g.undotree_SetFocusWhenToggle = 1]] },
        { 'bfredl/nvim-miniyank', as = 'miniyank' }
      }

      -- diagnostics
      use { 'folke/trouble.nvim',
      cmd = {'Trouble', 'TroubleToggle', 'TroubleClose', 'TroubleRefresh' }
    }

    -- formatting
    use {
      'sbdchd/neoformat',
      { 'godlygeek/tabular', cmd = { 'Tabularize' } },
      { 'lukas-reineke/indent-blankline.nvim' },
    }
    -- colors
    use {
      { 'norcalli/nvim-colorizer.lua', config = function() require('colorizer').setup() end },
      'chriskempson/base16-vim',
      'miyakogi/seiya.vim',  -- enable transparent background
      { 'p00f/nvim-ts-rainbow', requires = { 'nvim-treesitter/nvim-treesitter' } }
    }

    -- debugger
    --use {'mfussenegger/nvim-dap'}
    use {
      'rcarriga/vim-ultest',
      requires = {'vim-test/vim-test'}, run = ':UpdateRemotePlugins' ,
      cmd = { 'TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit' }
    }

    -- statusline
    use {'glepnir/galaxyline.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true},
      config = function() require('statusline') end
    }

    -- markdown
    use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install',
      cmd = {'MarkdownPreview', 'MarkdownPreviewStop'} , ft = {'markdown'}
    }

   -- completions / snippets
   use {
     { 'hrsh7th/nvim-compe', event = 'InsertEnter *', config = function() require('completion') end },
     {'SirVer/ultisnips', requires = {{'honza/vim-snippets' }}, setup = [[require('snippets')]] }
   }
    -- profiling
    use { 'tweekmonster/startuptime.vim' }

    -- marks
    use { 'kshenoy/vim-signature' }
    -- terminal
    use {
      'akinsho/nvim-toggleterm.lua',
     config = function() require'toggleterm'.setup{ open_mapping = [[<C-t>]], shading_factor = 1 } end
    }
    use {
      'AndrewRadev/bufferize.vim',
      cmd = {'Bufferize'}
    }
  end
  )
end
