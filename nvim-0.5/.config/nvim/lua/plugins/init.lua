-- Only required if you have packer in your `opt` pack
local ok, _ = pcall(vim.cmd, [[packadd packer.nvim]])

if ok then
  return require('packer').startup(
    function()
      -- Packer can manage itself as an optional plugin
      use {'wbthomason/packer.nvim', opt = true}
      -- Collection of common configurations for Neovim's built-in language server client.
      use { 'neovim/nvim-lspconfig' }
      -- This tiny plugin adds vscode-like pictograms to neovim built-in lsp:
      use { 'onsails/lspkind-nvim' }
      -- This is a Neovim plugin/library for generating statusline components from the built-in LSP client.
      use { 'nvim-lua/lsp-status.nvim' }
      -- galaxyline is a light-weight and Super Fast statusline plugin.
      -- Not working for some reason
      use {'glepnir/galaxyline.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true}}
      -- An asynchronous Lua API for using fzf
      use { 'vijaymarupudi/nvim-fzf' }
      use { 'vijaymarupudi/nvim-fzf-commands' }
      -- telescope.nvim is a highly extendable fuzzy finder over lists.
      use { 'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}} }
      -- Preview markdown on your modern browser with synchronised scrolling and flexible configuration
      use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}
      -- Rainbow parentheses for neovim using tree-sitter.
      use { 'p00f/nvim-ts-rainbow' }
      -- Configurations and abstraction layer for Neovim.
      use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
      -- View treesitter information directly in Neovim!
      use { 'nvim-treesitter/playground' }
      -- Create your own textobjects using tree-sitter queries!
      use { 'Aerex/nvim-treesitter-textobjects' }
      -- Plugin to work with GitHub issues and PRs from Neovim.
      use { 'pwntester/octo.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}} }
      -- completion-nvim is an auto completion framework that aims to provide a better completion experience with neovim's built-in LSP.
      use { 'nvim-lua/completion-nvim' }
      -- Show function signature when you types
      use { 'ray-x/lsp_signature.nvim'}
      -- A collection of language packs for Vim.
      use { 'sheerun/vim-polyglot' }
      -- This repository contains snippets files for various programming languages.
      use { 'honza/vim-snippets', requires =  {{'honza/vim-snippets' }} }
      -- nvim-dap is a Debug Adapter Protocol client implementation for Neovim
      use {'mfussenegger/nvim-dap'}
      -- Vim plugin that allows use of vifm as a file picker
      use { 'vifm/vifm.vim' }
      -- Ease your git workflow within vim using buffers
      use { 'jreybert/vimagit' }
      -- Magit clone for Neovim that is geared toward the Vim philosophy.
      use { 'TimUntersberger/neogit'}
      -- A high-performance color highlighter for Neovim which has no external dependencies! Written in performant Luajit
      use { 'norcalli/nvim-colorizer.lua' }
      -- Theme using a base of 16 colors
      use { 'chriskempson/base16-vim' }
      -- Plugin to measure how long it takes for vim to start up and what is slowing it down
      use { 'tweekmonster/startuptime.vim' }
      -- A (Neo)vim plugin for formatting code.
      use { 'sbdchd/neoformat' }
      -- vim-signature is a plugin to place, toggle and display marks.
      use { 'kshenoy/vim-signature' }
      -- Has some problems
      --use { 'oberblastmeister/neuron.nvim', requires = {{'vim-lua/popup.nvim'},
      --  {'nvim-lua/plenary.nvim'},
      --  {'nvim-telescope/telescope.nvim'}
      --}}
    end
    )
end

require('lsp')
require('statusline')
--require('markdown-preview')
--require('treesitter')
