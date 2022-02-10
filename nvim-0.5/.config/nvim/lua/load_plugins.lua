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

      use {'folke/which-key.nvim', config = function() require'which-key' end }

    -- lsp
    use {
      { 'neovim/nvim-lspconfig', config = function() require('nvim-lsp') end },
      'onsails/lspkind-nvim',
      'nvim-lua/lsp-status.nvim',
      'ray-x/lsp_signature.nvim'
    }
    use {
        'weilbith/nvim-code-action-menu',
        cmd = 'CodeActionMenu'
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
    use { 'tpope/vim-fugitive', cmd = {'Git', 'Gpush'} }
    use { 'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}, event = {'BufRead'}, config = function() require('nvim-git').setup_signs() end }
    use { 'Aerex/neogit', branch = 'feat/config-split-direction', cmd = {'Neogit'}, config = function() require('nvim-git').setup_neogit() end,
      requires = { 'nvim-lua/plenary.nvim','sindrets/diffview.nvim' }}
    use { 'pwntester/octo.nvim', cmd = { 'Octo' }, requires = { {'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}, {'Aerex/telescope.nvim'  } } }

      -- yank/undo
      use {
        { 'mbbill/undotree', cmd = 'UndotreeToggle',  config = [[vim.g.undotree_SetFocusWhenToggle = 1]] },
        { 'bfredl/nvim-miniyank', as = 'miniyank' }
      }

      -- diagnostics
      use {'folke/trouble.nvim', cmd = {'Trouble', 'TroubleToggle', 'TroubleClose', 'TroubleRefresh' } }
      use {'folke/todo-comments.nvim', requires = 'nvim-lua/plenary.nvim', config = function() require('todo').setup() end }

    -- formatting
    use {
      'sbdchd/neoformat',
      { 'godlygeek/tabular', cmd = { 'Tabularize' } },
      { 'lukas-reineke/indent-blankline.nvim', config = function() require('indentlines') end },
    }
    -- colors
    use {
      { 'norcalli/nvim-colorizer.lua', config = function() require('colorizer').setup() end },
      { opt = true,  'chriskempson/base16-vim' },
        'rmehri01/onenord.nvim', config = function() require('colors').setup() end,
        'miyakogi/seiya.vim',  -- enable transparent background
      { 'p00f/nvim-ts-rainbow', requires = { 'nvim-treesitter/nvim-treesitter' } }
    }

    -- debugger
    use {
      'mfussenegger/nvim-dap',
      requires = { 'rcarriga/nvim-dap-ui', 'mfussenegger/nvim-dap-python', 'theHamsta/nvim-dap-virtual-text'},
      config = function() require('debugger') end
    }

    -- test
    use {
      'rcarriga/vim-ultest',
        run = ':UpdateRemotePlugins',
        requires = {'vim-test/vim-test'},
        config = function() require('test') end
    }

    -- statusline
    use {'glepnir/galaxyline.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true},
      config = function() require('statusline') end
    }
    use {'tpope/vim-dispatch'}

   -- completions / snippets
    use({ -- nvim-cmp
        'hrsh7th/nvim-cmp',
        requires = {
          'hrsh7th/cmp-buffer',
          'hrsh7th/cmp-path',
          'hrsh7th/cmp-nvim-lua',
          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/cmp-look', -- dictionary source
          'https://github.com/f3fora/cmp-spell', -- spell source
          {
            'SirVer/ultisnips',
            'quangnguyen30192/cmp-nvim-ultisnips',
            'honza/vim-snippets',
          }
        },
        config = function()
          require('completion')
        end,
      })
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
    -- misc
    use {'kkoomen/vim-doge', opt = true, run = ':call doge#install()', config = 'vim.g.doge_enable_mappings = 0'}
    use {'vimwiki/vimwiki', ft = {'vimwiki', 'markdown'}, config = function()
        vim.g.vimwiki_global_vars.key_mappings = { headers = 0, html = 0, global  = 0   }
      end }
    use {'dhruvasagar/vim-table-mode', cmd = {'TableModeToggle', 'TableModeEnable', 'TableModeDisable', 'Tabelize', 'TableModeRealign'}}
    use {
      'voldikss/vim-translator', cmd = {'Translate', 'TranslateR', 'TranslateW', 'TranslateL'}, ft = {"trans"}
    }
    use {  'NTBBloodbath/rest.nvim',  requires = { "nvim-lua/plenary.nvim" }, ft = {'http'},
    config = function()
      require("rest-nvim").setup({
      -- Open request results in a horizontal split
      result_split_horizontal = false,
      -- Skip SSL verification, useful for unknown certificates
      skip_ssl_verification = false,
      -- Highlight request on run
      highlight = {
        enabled = true,
        timeout = 150,
      },
      result = {
        -- toggle showing URL, HTTP info, headers at top the of result window
        show_url = true,
        show_http_info = true,
        show_headers = true,
      },
      -- Jump to request line on run
      jump_to_request = false,
      env_file = '.env',
      custom_dynamic_variables = {},
    })
  end
}
    use { 'ledger/vim-ledger', ft = {'ledger'} }
    use {'iamcco/markdown-preview.nvim', run = 'cd app && npm install',
      cmd = {'MarkdownPreview', 'MarkdownPreviewStop'} , ft = {'markdown'},
      config = function() vim.g.mkdp_filetypes = { 'markdown', 'vimwiki' } end
    }
  end
  )
end
