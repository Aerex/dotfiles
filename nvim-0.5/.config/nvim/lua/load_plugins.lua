-- Only required if you have packer in your `opt` pack
local ok, _ = pcall(vim.cmd, [[packadd packer.nvim]])

if ok then
  return require('packer').startup(
    function()
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

      -- fuzzy pickers / file finders
      use {
        'vijaymarupudi/nvim-fzf',
        'vijaymarupudi/nvim-fzf-commands',
        'vifm/vifm.vim'
      }

      -- git
      use {
        { 'tpope/vim-fugitive', cmd = {'Git', 'Gstatus', 'Gblame', 'Gpush', 'Gpull'} },
        { 'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'} },
        { 'TimUntersberger/neogit', opt = true },  -- still has some issues need to wait before using
        { 'pwntester/octo.nvim',
          cmd = { 'Octo' },
          requires = { {'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}, {'nvim-telescope/telescope.nvim'} } }
      }

      -- undo
      use { 'mbbill/undotree', cmd = 'UndotreeToggle',  config = [[vim.g.undotree_SetFocusWhenToggle = 1]] }

      -- formatting / colors
      use {
        'norcalli/nvim-colorizer.lua',
        'p00f/nvim-ts-rainbow',
        'chriskempson/base16-vim',
        'miyakogi/seiya.vim',  -- enable transparent background
        'sbdchd/neoformat',
        { 'lukas-reineke/indent-blankline.nvim', branch = 'lua' }
      }

      -- debugger
      use {'mfussenegger/nvim-dap'}

      -- statusline
      use {'glepnir/galaxyline.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true}}

      -- languages
      use { 'sheerun/vim-polyglot', opt = true }
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

    -- notes
    use {
        'alok/notational-fzf-vim', cmd = 'NV', requires = { 'junegunn/fzf.vim' },
      }
    end
    )
end
