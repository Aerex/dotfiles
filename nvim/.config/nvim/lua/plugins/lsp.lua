return {
  {
    'neovim/nvim-lspconfig',
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
    'williamboman/mason.nvim',
    dependencies = 'williamboman/mason-lspconfig.nvim',
    config = function()
      require 'mason'.setup(); require 'mason-lspconfig'.setup()
    end
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
        notification = {
          window = {
            relative = 'editor',
            winblend = 0,
          }
        }
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
