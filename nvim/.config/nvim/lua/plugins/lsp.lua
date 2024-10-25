return {
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'jose-elias-alvarez/nvim-lsp-ts-utils' },
    config = function()
      require('plugins.configs.lsp')
    end
  },
  {
    lazy = true,
    'mfussenegger/nvim-jdtls'
  },
  {
    lazy = true,
    'jose-elias-alvarez/null-ls.nvim'
  },
  {
    'onsails/lspkind-nvim'
  },
  {
    'nvim-lua/lsp-status.nvim'
  },
  {
    'ray-x/lsp_signature.nvim'
  },
  {
    'rmagatti/goto-preview'
  },
  {
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup({
        window = {
          relative = 'editor',
          blend = 0,
        },
        sources = {
          ['null-ls'] = {
            ignore = true
          },
        },
      })
    end,
  },
  {
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
    config = function()
      vim.g.code_action_menu_show_details = false
    end
  }
}
